"""Game loop: alternating turns, game state tracking, result determination."""

import numpy as np
from board import Board
from pieces import WHITE, BLACK, PAWN, QUEEN
from moves import get_legal_moves, execute_move, is_in_check
from rules import (
    is_checkmate, is_stalemate, is_insufficient_material,
    initial_castling_rights, update_castling_rights, is_fifty_move_draw,
)


class Game:
    """Manages a chess game: board, turns, move history, and game state."""

    def __init__(self):
        self.board = Board()
        self.turn = WHITE  # White moves first
        self.move_history = []
        self.board_history = []  # For threefold repetition (board, turn, castling, ep)
        self.en_passant_target = None
        self.castling_rights = initial_castling_rights()
        self.halfmove_clock = 0  # For fifty-move rule
        self.result = None  # None = ongoing, 1 = white wins, -1 = black wins, 0 = draw

    def get_legal_moves(self):
        """Get legal moves for the current side to move."""
        return get_legal_moves(
            self.board, self.turn, self.en_passant_target, self.castling_rights
        )

    def play_move(self, from_r, from_c, to_r, to_c, promotion_piece=QUEEN):
        """Execute a move, update game state. Returns True if move was legal."""
        legal_moves = self.get_legal_moves()
        if (from_r, from_c, to_r, to_c) not in legal_moves:
            return False

        piece = self.board.get_piece(from_r, from_c)
        piece_type = abs(piece)
        captured = self.board.get_piece(to_r, to_c)

        # Update castling rights before the move
        new_castling = update_castling_rights(
            self.castling_rights, self.board, from_r, from_c, to_r, to_c
        )

        # Execute the move
        new_board, new_ep, promoted = execute_move(
            self.board, from_r, from_c, to_r, to_c,
            self.en_passant_target, promotion_piece
        )

        # Record history
        self.move_history.append((from_r, from_c, to_r, to_c))
        self.board_history.append(self._position_key())

        # Update state
        self.board = new_board
        self.en_passant_target = new_ep
        self.castling_rights = new_castling

        # Update halfmove clock
        if piece_type == PAWN or captured != 0:
            self.halfmove_clock = 0
        else:
            self.halfmove_clock += 1

        # Switch turn
        self.turn = -self.turn

        # Check for game-ending conditions
        self._check_game_over()

        return True

    def _check_game_over(self):
        """Check if the game has ended after a move."""
        if is_checkmate(self.board, self.turn, self.en_passant_target, self.castling_rights):
            self.result = -self.turn  # The side that just moved wins
            return

        if is_stalemate(self.board, self.turn, self.en_passant_target, self.castling_rights):
            self.result = 0
            return

        if is_insufficient_material(self.board):
            self.result = 0
            return

        if is_fifty_move_draw(self.halfmove_clock):
            self.result = 0
            return

        if self._is_threefold_repetition():
            self.result = 0
            return

    def _position_key(self):
        """Return a hashable key representing the full position state."""
        return (
            self.board.array.tobytes(),
            self.turn,
            tuple(sorted(self.castling_rights.items())),
            self.en_passant_target,
        )

    def _is_threefold_repetition(self):
        """Check if current position has occurred 3 times.

        Per FIDE rules, two positions are the same only if the same player
        is to move, the same castling rights exist, and the same en passant
        target is available, in addition to identical piece placement.
        """
        if len(self.board_history) < 6:
            return False
        current = self._position_key()
        count = 0
        for past_key in self.board_history:
            if current == past_key:
                count += 1
                if count >= 2:  # Current + 2 past = 3 occurrences
                    return True
        return False

    def is_game_over(self):
        return self.result is not None

    def get_result(self):
        """Return 1 (white wins), -1 (black wins), 0 (draw), or None (ongoing)."""
        return self.result

    def get_board_state(self):
        """Return a copy of the current board array."""
        return self.board.array.copy()

    def display(self):
        """Display the current board and game info."""
        self.board.display()
        side = "White" if self.turn == WHITE else "Black"
        if self.result is None:
            check_str = " (in check)" if is_in_check(self.board, self.turn) else ""
            print(f"Turn: {side}{check_str}")
        else:
            if self.result == 1:
                print("Result: White wins!")
            elif self.result == -1:
                print("Result: Black wins!")
            else:
                print("Result: Draw")
        print(f"Moves played: {len(self.move_history)}")
