"""Move generation using shift matrices, move validation, and move execution."""

import numpy as np
from pieces import (
    PAWN, KNIGHT, BISHOP, ROOK, QUEEN, KING,
    WHITE, BLACK, PIECE_SHIFTS, SLIDING_PIECES,
)


def in_bounds(r, c):
    return 0 <= r < 8 and 0 <= c < 8


def _generate_pawn_moves(board, r, c, color):
    """Generate pseudo-legal pawn moves for a pawn at (r, c)."""
    moves = []
    direction = -1 if color == WHITE else 1  # White moves up (decreasing row)
    start_row = 6 if color == WHITE else 1

    # Forward one step
    nr, nc = r + direction, c
    if in_bounds(nr, nc) and board.is_empty(nr, nc):
        moves.append((r, c, nr, nc))
        # Forward two steps from starting row
        nr2 = r + 2 * direction
        if r == start_row and board.is_empty(nr2, nc):
            moves.append((r, c, nr2, nc))

    # Diagonal captures
    for dc in [-1, 1]:
        nr, nc = r + direction, c + dc
        if in_bounds(nr, nc):
            target = board.get_piece(nr, nc)
            if target != 0 and np.sign(target) != color:
                moves.append((r, c, nr, nc))

    return moves


def _generate_piece_moves(board, r, c, piece_type, color):
    """Generate pseudo-legal moves for a non-pawn piece at (r, c)."""
    moves = []
    shifts = PIECE_SHIFTS[piece_type]
    sliding = piece_type in SLIDING_PIECES

    for dr, dc in shifts:
        nr, nc = r + dr, c + dc
        if sliding:
            while in_bounds(nr, nc):
                target = board.get_piece(nr, nc)
                if target == 0:
                    moves.append((r, c, nr, nc))
                elif np.sign(target) != color:
                    moves.append((r, c, nr, nc))
                    break
                else:
                    break  # Blocked by own piece
                nr += dr
                nc += dc
        else:
            if in_bounds(nr, nc):
                target = board.get_piece(nr, nc)
                if target == 0 or np.sign(target) != color:
                    moves.append((r, c, nr, nc))

    return moves


def generate_pseudo_legal_moves(board, color, en_passant_target=None):
    """Generate all pseudo-legal moves for a color (doesn't check for leaving king in check)."""
    moves = []
    for r in range(8):
        for c in range(8):
            piece = board.get_piece(r, c)
            if piece == 0 or np.sign(piece) != color:
                continue
            piece_type = abs(piece)
            if piece_type == PAWN:
                moves.extend(_generate_pawn_moves(board, r, c, color))
                # En passant
                if en_passant_target is not None:
                    ep_r, ep_c = en_passant_target
                    direction = -1 if color == WHITE else 1
                    if r + direction == ep_r and abs(c - ep_c) == 1:
                        moves.append((r, c, ep_r, ep_c))
            else:
                moves.extend(_generate_piece_moves(board, r, c, piece_type, color))

    return moves


def is_square_attacked(board, r, c, by_color):
    """Check if square (r, c) is attacked by any piece of by_color."""
    # Check knight attacks
    for dr, dc in PIECE_SHIFTS[KNIGHT]:
        nr, nc = r + dr, c + dc
        if in_bounds(nr, nc) and board.get_piece(nr, nc) == KNIGHT * by_color:
            return True

    # Check sliding attacks (bishop/queen on diagonals, rook/queen on orthogonals)
    for dr, dc in PIECE_SHIFTS[BISHOP]:
        nr, nc = r + dr, c + dc
        while in_bounds(nr, nc):
            piece = board.get_piece(nr, nc)
            if piece != 0:
                if piece == BISHOP * by_color or piece == QUEEN * by_color:
                    return True
                break
            nr += dr
            nc += dc

    for dr, dc in PIECE_SHIFTS[ROOK]:
        nr, nc = r + dr, c + dc
        while in_bounds(nr, nc):
            piece = board.get_piece(nr, nc)
            if piece != 0:
                if piece == ROOK * by_color or piece == QUEEN * by_color:
                    return True
                break
            nr += dr
            nc += dc

    # Check king attacks (adjacent squares)
    for dr, dc in PIECE_SHIFTS[KING]:
        nr, nc = r + dr, c + dc
        if in_bounds(nr, nc) and board.get_piece(nr, nc) == KING * by_color:
            return True

    # Check pawn attacks
    pawn_dir = 1 if by_color == WHITE else -1  # Direction pawns of by_color attack FROM
    for dc in [-1, 1]:
        nr, nc = r + pawn_dir, c + dc
        if in_bounds(nr, nc) and board.get_piece(nr, nc) == PAWN * by_color:
            return True

    return False


def is_in_check(board, color):
    """Check if the given color's king is in check."""
    king_pos = board.find_king(color)
    if king_pos is None:
        return True  # King captured (shouldn't happen in legal play)
    return is_square_attacked(board, king_pos[0], king_pos[1], -color)


def execute_move(board, from_r, from_c, to_r, to_c, en_passant_target=None, promotion_piece=QUEEN):
    """Execute a move on a copy of the board. Returns (new_board, new_en_passant_target, promoted)."""
    new_board = board.copy()
    piece = new_board.get_piece(from_r, from_c)
    piece_type = abs(piece)
    color = np.sign(piece)
    new_ep = None
    promoted = False

    # En passant capture
    if piece_type == PAWN and en_passant_target is not None:
        ep_r, ep_c = en_passant_target
        if to_r == ep_r and to_c == ep_c:
            # Remove the captured pawn
            capture_r = from_r  # The captured pawn is on the same row as the moving pawn
            new_board.set_piece(capture_r, to_c, 0)

    # Move the piece
    new_board.set_piece(to_r, to_c, piece)
    new_board.set_piece(from_r, from_c, 0)

    # Pawn double push — set en passant target
    if piece_type == PAWN and abs(to_r - from_r) == 2:
        new_ep = ((from_r + to_r) // 2, from_c)

    # Pawn promotion
    if piece_type == PAWN:
        promo_row = 0 if color == WHITE else 7
        if to_r == promo_row:
            new_board.set_piece(to_r, to_c, promotion_piece * color)
            promoted = True

    # Castling — move the rook
    if piece_type == KING and abs(to_c - from_c) == 2:
        if to_c == 6:  # Kingside
            new_board.set_piece(from_r, 5, ROOK * color)
            new_board.set_piece(from_r, 7, 0)
        elif to_c == 2:  # Queenside
            new_board.set_piece(from_r, 3, ROOK * color)
            new_board.set_piece(from_r, 0, 0)

    return new_board, new_ep, promoted


def get_legal_moves(board, color, en_passant_target=None, castling_rights=None):
    """Generate all legal moves for a color (filters out moves that leave king in check).
    Also generates castling moves if castling_rights is provided."""
    pseudo_moves = generate_pseudo_legal_moves(board, color, en_passant_target)

    # Add castling moves
    if castling_rights is not None:
        pseudo_moves.extend(_generate_castling_moves(board, color, castling_rights))

    legal_moves = []
    for move in pseudo_moves:
        from_r, from_c, to_r, to_c = move
        new_board, _, _ = execute_move(board, from_r, from_c, to_r, to_c, en_passant_target)
        if not is_in_check(new_board, color):
            legal_moves.append(move)

    return legal_moves


def _generate_castling_moves(board, color, castling_rights):
    """Generate castling moves if conditions are met."""
    moves = []
    if is_in_check(board, color):
        return moves

    row = 7 if color == WHITE else 0

    # Kingside castling
    if castling_rights.get((color, 'K'), False):
        if (board.is_empty(row, 5) and board.is_empty(row, 6)
                and board.get_piece(row, 4) == KING * color
                and board.get_piece(row, 7) == ROOK * color):
            if (not is_square_attacked(board, row, 5, -color)
                    and not is_square_attacked(board, row, 6, -color)):
                moves.append((row, 4, row, 6))

    # Queenside castling
    if castling_rights.get((color, 'Q'), False):
        if (board.is_empty(row, 3) and board.is_empty(row, 2) and board.is_empty(row, 1)
                and board.get_piece(row, 4) == KING * color
                and board.get_piece(row, 0) == ROOK * color):
            if (not is_square_attacked(board, row, 3, -color)
                    and not is_square_attacked(board, row, 2, -color)):
                moves.append((row, 4, row, 2))

    return moves
