"""Comprehensive tests for chess engine rules."""

import numpy as np
import sys

from board import Board
from pieces import WHITE, BLACK, EMPTY, PAWN, KNIGHT, BISHOP, ROOK, QUEEN, KING
from moves import (
    get_legal_moves, execute_move, is_in_check,
    is_square_attacked, generate_pseudo_legal_moves,
)
from rules import (
    is_checkmate, is_stalemate, is_insufficient_material,
    initial_castling_rights, update_castling_rights, is_fifty_move_draw,
)
from game import Game


def make_board(layout):
    """Create a board from an 8x8 list of lists."""
    return Board(array=np.array(layout, dtype=np.int8))


def empty_board():
    """Create an empty board."""
    return make_board([[0]*8 for _ in range(8)])


passed = 0
failed = 0


def check(name, condition):
    global passed, failed
    if condition:
        passed += 1
        print(f"  PASS: {name}")
    else:
        failed += 1
        print(f"  FAIL: {name}")


def move_in(moves, from_r, from_c, to_r, to_c):
    return (from_r, from_c, to_r, to_c) in moves


# ===================================================================
# 1. Initial board setup
# ===================================================================
def test_initial_board():
    print("\n=== Initial Board Setup ===")
    b = Board()
    # White pieces on rank 1 (row 7)
    check("White rook a1", b.get_piece(7, 0) == ROOK)
    check("White knight b1", b.get_piece(7, 1) == KNIGHT)
    check("White bishop c1", b.get_piece(7, 2) == BISHOP)
    check("White queen d1", b.get_piece(7, 3) == QUEEN)
    check("White king e1", b.get_piece(7, 4) == KING)
    check("White bishop f1", b.get_piece(7, 5) == BISHOP)
    check("White knight g1", b.get_piece(7, 6) == KNIGHT)
    check("White rook h1", b.get_piece(7, 7) == ROOK)
    # White pawns on rank 2 (row 6)
    for c in range(8):
        check(f"White pawn on col {c}", b.get_piece(6, c) == PAWN)
    # Black pieces on rank 8 (row 0)
    check("Black rook a8", b.get_piece(0, 0) == -ROOK)
    check("Black knight b8", b.get_piece(0, 1) == -KNIGHT)
    check("Black bishop c8", b.get_piece(0, 2) == -BISHOP)
    check("Black queen d8", b.get_piece(0, 3) == -QUEEN)
    check("Black king e8", b.get_piece(0, 4) == -KING)
    # Black pawns on rank 7 (row 1)
    for c in range(8):
        check(f"Black pawn on col {c}", b.get_piece(1, c) == -PAWN)
    # Empty squares
    for r in range(2, 6):
        for c in range(8):
            check(f"Empty ({r},{c})", b.is_empty(r, c))


# ===================================================================
# 2. Pawn movement
# ===================================================================
def test_pawn_moves():
    print("\n=== Pawn Movement ===")
    b = empty_board()
    # White pawn on e2 (row 6, col 4)
    b.set_piece(6, 4, PAWN)
    b.set_piece(0, 0, KING)       # need kings for legality
    b.set_piece(7, 7, -KING)
    moves = get_legal_moves(b, WHITE)
    check("Pawn can move e2-e3", move_in(moves, 6, 4, 5, 4))
    check("Pawn can move e2-e4 (double push)", move_in(moves, 6, 4, 4, 4))

    # Pawn not on starting row
    b2 = empty_board()
    b2.set_piece(5, 4, PAWN)  # e3
    b2.set_piece(0, 0, KING)
    b2.set_piece(7, 7, -KING)
    moves2 = get_legal_moves(b2, WHITE)
    check("Pawn e3-e4 allowed", move_in(moves2, 5, 4, 4, 4))
    check("Pawn e3-e5 NOT allowed (not on start row)", not move_in(moves2, 5, 4, 3, 4))

    # Pawn blocked
    b3 = empty_board()
    b3.set_piece(6, 4, PAWN)  # e2
    b3.set_piece(5, 4, -PAWN)  # e3 blocked
    b3.set_piece(0, 0, KING)
    b3.set_piece(7, 7, -KING)
    moves3 = get_legal_moves(b3, WHITE)
    check("Pawn blocked by piece ahead", not move_in(moves3, 6, 4, 5, 4))
    check("Pawn double push blocked too", not move_in(moves3, 6, 4, 4, 4))

    # Pawn double push blocked by piece on 4th rank
    b4 = empty_board()
    b4.set_piece(6, 4, PAWN)  # e2
    b4.set_piece(4, 4, -PAWN)  # e4 blocked
    b4.set_piece(0, 0, KING)
    b4.set_piece(7, 7, -KING)
    moves4 = get_legal_moves(b4, WHITE)
    check("Pawn e2-e3 still allowed", move_in(moves4, 6, 4, 5, 4))
    check("Pawn double push blocked by piece on e4", not move_in(moves4, 6, 4, 4, 4))

    # Pawn captures
    b5 = empty_board()
    b5.set_piece(4, 4, PAWN)  # e4
    b5.set_piece(3, 3, -PAWN)  # d5
    b5.set_piece(3, 5, -PAWN)  # f5
    b5.set_piece(0, 0, KING)
    b5.set_piece(7, 7, -KING)
    moves5 = get_legal_moves(b5, WHITE)
    check("Pawn can capture d5", move_in(moves5, 4, 4, 3, 3))
    check("Pawn can capture f5", move_in(moves5, 4, 4, 3, 5))

    # Pawn cannot capture own piece
    b6 = empty_board()
    b6.set_piece(4, 4, PAWN)
    b6.set_piece(3, 3, PAWN)  # own pawn
    b6.set_piece(0, 0, KING)
    b6.set_piece(7, 7, -KING)
    moves6 = get_legal_moves(b6, WHITE)
    check("Pawn cannot capture own piece", not move_in(moves6, 4, 4, 3, 3))

    # Black pawn moves
    b7 = empty_board()
    b7.set_piece(1, 4, -PAWN)  # e7
    b7.set_piece(0, 0, KING)
    b7.set_piece(7, 7, -KING)
    moves7 = get_legal_moves(b7, BLACK)
    check("Black pawn e7-e6", move_in(moves7, 1, 4, 2, 4))
    check("Black pawn e7-e5 (double push)", move_in(moves7, 1, 4, 3, 4))


# ===================================================================
# 3. Knight movement
# ===================================================================
def test_knight_moves():
    print("\n=== Knight Movement ===")
    b = empty_board()
    b.set_piece(4, 4, KNIGHT)  # Knight on e4
    b.set_piece(0, 0, KING)
    b.set_piece(7, 7, -KING)
    moves = get_legal_moves(b, WHITE)
    knight_moves = [(r, c) for fr, fc, r, c in moves if fr == 4 and fc == 4]
    expected = [(2, 3), (2, 5), (3, 2), (3, 6), (5, 2), (5, 6), (6, 3), (6, 5)]
    check("Knight on e4 has 8 moves", len(knight_moves) == 8)
    for er, ec in expected:
        check(f"Knight can move to ({er},{ec})", (er, ec) in knight_moves)

    # Knight in corner
    b2 = empty_board()
    b2.set_piece(0, 0, KNIGHT)  # a8
    b2.set_piece(7, 4, KING)
    b2.set_piece(0, 7, -KING)
    moves2 = get_legal_moves(b2, WHITE)
    knight_moves2 = [(r, c) for fr, fc, r, c in moves2 if fr == 0 and fc == 0]
    check("Knight in corner has 2 moves", len(knight_moves2) == 2)


# ===================================================================
# 4. Sliding pieces (bishop, rook, queen)
# ===================================================================
def test_sliding_pieces():
    print("\n=== Sliding Pieces ===")

    # Bishop
    b = empty_board()
    b.set_piece(4, 4, BISHOP)  # e4
    b.set_piece(0, 0, KING)
    b.set_piece(7, 7, -KING)
    moves = get_legal_moves(b, WHITE)
    bishop_moves = [(r, c) for fr, fc, r, c in moves if fr == 4 and fc == 4]
    check("Bishop on e4 has 12 moves (own king blocks 1 diagonal)", len(bishop_moves) == 12)

    # Bishop blocked by own piece
    b2 = empty_board()
    b2.set_piece(4, 4, BISHOP)
    b2.set_piece(3, 3, PAWN)  # own pawn blocks diagonal
    b2.set_piece(0, 0, KING)
    b2.set_piece(7, 7, -KING)
    moves2 = get_legal_moves(b2, WHITE)
    bishop_moves2 = [(r, c) for fr, fc, r, c in moves2 if fr == 4 and fc == 4]
    check("Bishop blocked by own piece on d5", (3, 3) not in bishop_moves2)
    check("Bishop blocked from reaching c6", (2, 2) not in bishop_moves2)

    # Rook
    b3 = empty_board()
    b3.set_piece(4, 4, ROOK)  # e4
    b3.set_piece(0, 0, KING)
    b3.set_piece(7, 7, -KING)
    moves3 = get_legal_moves(b3, WHITE)
    rook_moves = [(r, c) for fr, fc, r, c in moves3 if fr == 4 and fc == 4]
    check("Rook on e4 has 14 moves", len(rook_moves) == 14)

    # Rook capture
    b4 = empty_board()
    b4.set_piece(4, 4, ROOK)
    b4.set_piece(4, 7, -PAWN)  # enemy pawn on h4
    b4.set_piece(0, 0, KING)
    b4.set_piece(7, 7, -KING)
    moves4 = get_legal_moves(b4, WHITE)
    check("Rook can capture enemy on h4", move_in(moves4, 4, 4, 4, 7))

    # Queen combines bishop and rook
    b5 = empty_board()
    b5.set_piece(4, 4, QUEEN)
    b5.set_piece(0, 0, KING)
    b5.set_piece(7, 7, -KING)
    moves5 = get_legal_moves(b5, WHITE)
    queen_moves = [(r, c) for fr, fc, r, c in moves5 if fr == 4 and fc == 4]
    check("Queen on e4 has 26 moves (own king blocks 1 diagonal)", len(queen_moves) == 26)


# ===================================================================
# 5. King movement
# ===================================================================
def test_king_moves():
    print("\n=== King Movement ===")
    b = empty_board()
    b.set_piece(4, 4, KING)    # e4
    b.set_piece(0, 0, -KING)
    moves = get_legal_moves(b, WHITE)
    king_moves = [(r, c) for fr, fc, r, c in moves if fr == 4 and fc == 4]
    check("King in center has 8 moves", len(king_moves) == 8)

    # King cannot move into check
    b2 = empty_board()
    b2.set_piece(4, 4, KING)
    b2.set_piece(3, 0, -ROOK)  # rook controls rank 3
    b2.set_piece(0, 0, -KING)
    moves2 = get_legal_moves(b2, WHITE)
    king_moves2 = [(r, c) for fr, fc, r, c in moves2 if fr == 4 and fc == 4]
    check("King cannot move to row 3 (rook controls it)",
          all(r != 3 for r, c in king_moves2))


# ===================================================================
# 6. En passant
# ===================================================================
def test_en_passant():
    print("\n=== En Passant ===")
    # White pawn on e5, black pawn just double-pushed to d5
    b = empty_board()
    b.set_piece(3, 4, PAWN)    # e5
    b.set_piece(3, 3, -PAWN)   # d5 (just double-pushed)
    b.set_piece(7, 4, KING)
    b.set_piece(0, 4, -KING)
    ep_target = (2, 3)  # d6

    moves = get_legal_moves(b, WHITE, en_passant_target=ep_target)
    check("White can capture en passant on d6", move_in(moves, 3, 4, 2, 3))

    # Execute en passant and verify captured pawn is removed
    new_board, new_ep, _ = execute_move(b, 3, 4, 2, 3, en_passant_target=ep_target)
    check("Pawn moved to d6", new_board.get_piece(2, 3) == PAWN)
    check("Original square empty", new_board.is_empty(3, 4))
    check("Captured pawn removed from d5", new_board.is_empty(3, 3))

    # Black en passant
    b2 = empty_board()
    b2.set_piece(4, 4, -PAWN)   # e4
    b2.set_piece(4, 5, PAWN)    # f4 (just double-pushed)
    b2.set_piece(7, 4, KING)
    b2.set_piece(0, 4, -KING)
    ep_target2 = (5, 5)  # f3

    moves2 = get_legal_moves(b2, BLACK, en_passant_target=ep_target2)
    check("Black can capture en passant on f3", move_in(moves2, 4, 4, 5, 5))

    new_board2, _, _ = execute_move(b2, 4, 4, 5, 5, en_passant_target=ep_target2)
    check("Black pawn moved to f3", new_board2.get_piece(5, 5) == -PAWN)
    check("Captured white pawn removed from f4", new_board2.is_empty(4, 5))

    # En passant sets target from double push
    b3 = empty_board()
    b3.set_piece(6, 4, PAWN)  # e2
    b3.set_piece(7, 4, KING)
    b3.set_piece(0, 4, -KING)
    _, new_ep3, _ = execute_move(b3, 6, 4, 4, 4)  # e2-e4
    check("Double push sets en passant target to e3", new_ep3 == (5, 4))


# ===================================================================
# 7. Castling
# ===================================================================
def test_castling():
    print("\n=== Castling ===")
    rights = initial_castling_rights()

    # Kingside castling for white
    b = empty_board()
    b.set_piece(7, 4, KING)
    b.set_piece(7, 7, ROOK)
    b.set_piece(0, 4, -KING)
    moves = get_legal_moves(b, WHITE, castling_rights=rights)
    check("White can castle kingside", move_in(moves, 7, 4, 7, 6))

    # Verify rook moves during kingside castling
    new_board, _, _ = execute_move(b, 7, 4, 7, 6)
    check("King on g1 after O-O", new_board.get_piece(7, 6) == KING)
    check("Rook on f1 after O-O", new_board.get_piece(7, 5) == ROOK)
    check("h1 empty after O-O", new_board.is_empty(7, 7))
    check("e1 empty after O-O", new_board.is_empty(7, 4))

    # Queenside castling for white
    b2 = empty_board()
    b2.set_piece(7, 4, KING)
    b2.set_piece(7, 0, ROOK)
    b2.set_piece(0, 4, -KING)
    moves2 = get_legal_moves(b2, WHITE, castling_rights=rights)
    check("White can castle queenside", move_in(moves2, 7, 4, 7, 2))

    new_board2, _, _ = execute_move(b2, 7, 4, 7, 2)
    check("King on c1 after O-O-O", new_board2.get_piece(7, 2) == KING)
    check("Rook on d1 after O-O-O", new_board2.get_piece(7, 3) == ROOK)
    check("a1 empty after O-O-O", new_board2.is_empty(7, 0))

    # Cannot castle through check
    b3 = empty_board()
    b3.set_piece(7, 4, KING)
    b3.set_piece(7, 7, ROOK)
    b3.set_piece(0, 5, -ROOK)  # Controls f1
    b3.set_piece(0, 4, -KING)
    moves3 = get_legal_moves(b3, WHITE, castling_rights=rights)
    check("Cannot castle kingside through check (f1 attacked)",
          not move_in(moves3, 7, 4, 7, 6))

    # Cannot castle out of check
    b4 = empty_board()
    b4.set_piece(7, 4, KING)
    b4.set_piece(7, 7, ROOK)
    b4.set_piece(0, 4, -ROOK)  # Controls e-file -> king in check
    b4.set_piece(0, 0, -KING)
    moves4 = get_legal_moves(b4, WHITE, castling_rights=rights)
    check("Cannot castle when in check",
          not move_in(moves4, 7, 4, 7, 6))

    # Cannot castle if pieces in the way
    b5 = empty_board()
    b5.set_piece(7, 4, KING)
    b5.set_piece(7, 7, ROOK)
    b5.set_piece(7, 5, BISHOP)  # f1 occupied
    b5.set_piece(0, 4, -KING)
    moves5 = get_legal_moves(b5, WHITE, castling_rights=rights)
    check("Cannot castle with piece on f1", not move_in(moves5, 7, 4, 7, 6))

    # Cannot castle if right is lost (king moved)
    no_k_rights = dict(rights)
    no_k_rights[(WHITE, 'K')] = False
    b6 = empty_board()
    b6.set_piece(7, 4, KING)
    b6.set_piece(7, 7, ROOK)
    b6.set_piece(0, 4, -KING)
    moves6 = get_legal_moves(b6, WHITE, castling_rights=no_k_rights)
    check("Cannot castle kingside without right", not move_in(moves6, 7, 4, 7, 6))

    # Black castling
    b7 = empty_board()
    b7.set_piece(0, 4, -KING)
    b7.set_piece(0, 7, -ROOK)
    b7.set_piece(7, 4, KING)
    moves7 = get_legal_moves(b7, BLACK, castling_rights=rights)
    check("Black can castle kingside", move_in(moves7, 0, 4, 0, 6))

    # Queenside castling: b-file (col 1) must be empty but not unattacked
    b8 = empty_board()
    b8.set_piece(7, 4, KING)
    b8.set_piece(7, 0, ROOK)
    b8.set_piece(0, 4, -KING)
    b8.set_piece(0, 1, -ROOK)  # Controls b-file (col 1) - should NOT block queenside
    # But wait, col 1 on row 0 is controlled by the rook... we need it to attack row 7 col 1
    # Let's use a different setup
    b8 = empty_board()
    b8.set_piece(7, 4, KING)
    b8.set_piece(7, 0, ROOK)
    b8.set_piece(3, 1, -ROOK)  # Attacks b1 (7,1) vertically
    b8.set_piece(0, 4, -KING)
    moves8 = get_legal_moves(b8, WHITE, castling_rights=rights)
    check("Can castle queenside even if b1 is attacked", move_in(moves8, 7, 4, 7, 2))


# ===================================================================
# 8. Castling rights updates
# ===================================================================
def test_castling_rights_update():
    print("\n=== Castling Rights Updates ===")
    rights = initial_castling_rights()
    b = Board()

    # King moves -> lose both rights
    new_rights = update_castling_rights(rights, b, 7, 4, 6, 4)
    check("King move loses white kingside", not new_rights[(WHITE, 'K')])
    check("King move loses white queenside", not new_rights[(WHITE, 'Q')])
    check("Black rights unchanged", new_rights[(BLACK, 'K')] and new_rights[(BLACK, 'Q')])

    # Kingside rook moves
    new_rights2 = update_castling_rights(rights, b, 7, 7, 5, 7)
    check("h1 rook move loses white kingside", not new_rights2[(WHITE, 'K')])
    check("White queenside still OK", new_rights2[(WHITE, 'Q')])

    # Queenside rook moves
    new_rights3 = update_castling_rights(rights, b, 7, 0, 5, 0)
    check("a1 rook move loses white queenside", not new_rights3[(WHITE, 'Q')])
    check("White kingside still OK", new_rights3[(WHITE, 'K')])

    # Rook captured on h1
    new_rights4 = update_castling_rights(rights, b, 0, 7, 7, 7)
    check("Capture on h1 loses white kingside", not new_rights4[(WHITE, 'K')])

    # Rook captured on a8
    new_rights5 = update_castling_rights(rights, b, 7, 0, 0, 0)
    check("Capture on a8 loses black queenside", not new_rights5[(BLACK, 'Q')])


# ===================================================================
# 9. Pawn promotion
# ===================================================================
def test_pawn_promotion():
    print("\n=== Pawn Promotion ===")
    b = empty_board()
    b.set_piece(1, 4, PAWN)   # White pawn on e7
    b.set_piece(7, 4, KING)
    b.set_piece(0, 0, -KING)
    moves = get_legal_moves(b, WHITE)
    check("Pawn on 7th rank can advance to 8th", move_in(moves, 1, 4, 0, 4))

    # Execute promotion (default = queen)
    new_board, _, promoted = execute_move(b, 1, 4, 0, 4)
    check("Promotion flag set", promoted)
    check("Promoted to white queen", new_board.get_piece(0, 4) == QUEEN)

    # Promotion with capture
    b2 = empty_board()
    b2.set_piece(1, 4, PAWN)
    b2.set_piece(0, 3, -ROOK)
    b2.set_piece(7, 4, KING)
    b2.set_piece(0, 7, -KING)
    moves2 = get_legal_moves(b2, WHITE)
    check("Pawn can promote with capture", move_in(moves2, 1, 4, 0, 3))

    # Underpromotion to knight
    new_board2, _, promoted2 = execute_move(b, 1, 4, 0, 4, promotion_piece=KNIGHT)
    check("Underpromotion to knight", new_board2.get_piece(0, 4) == KNIGHT)

    # Black promotion
    b3 = empty_board()
    b3.set_piece(6, 4, -PAWN)  # Black pawn on e2
    b3.set_piece(0, 4, -KING)
    b3.set_piece(7, 0, KING)
    new_board3, _, promoted3 = execute_move(b3, 6, 4, 7, 4)
    check("Black pawn promotes to queen", new_board3.get_piece(7, 4) == -QUEEN)
    check("Black promotion flag set", promoted3)


# ===================================================================
# 10. Check detection
# ===================================================================
def test_check():
    print("\n=== Check Detection ===")
    b = empty_board()
    b.set_piece(7, 4, KING)
    b.set_piece(0, 4, -ROOK)   # rook on e8 attacks e1
    b.set_piece(0, 0, -KING)
    check("White king in check from rook on e-file", is_in_check(b, WHITE))

    b2 = empty_board()
    b2.set_piece(7, 4, KING)
    b2.set_piece(5, 3, -PAWN)  # Black pawn on d3 attacks e2, not e1
    b2.set_piece(0, 0, -KING)
    check("White king NOT in check from distant pawn", not is_in_check(b2, WHITE))

    # Pawn check
    b3 = empty_board()
    b3.set_piece(4, 4, KING)    # e4
    b3.set_piece(3, 3, -PAWN)   # d5 attacks e4
    b3.set_piece(0, 0, -KING)
    check("White king in check from black pawn on d5", is_in_check(b3, WHITE))

    # Knight check
    b4 = empty_board()
    b4.set_piece(4, 4, KING)
    b4.set_piece(2, 3, -KNIGHT)  # Knight on d6 attacks e4
    b4.set_piece(0, 0, -KING)
    check("White king in check from knight", is_in_check(b4, WHITE))

    # Bishop check
    b5 = empty_board()
    b5.set_piece(7, 4, KING)
    b5.set_piece(4, 1, -BISHOP)  # diagonal to e1
    b5.set_piece(0, 0, -KING)
    check("White king in check from bishop", is_in_check(b5, WHITE))

    # Check blocked by piece
    b6 = empty_board()
    b6.set_piece(7, 4, KING)
    b6.set_piece(0, 4, -ROOK)
    b6.set_piece(3, 4, PAWN)    # blocks the rook
    b6.set_piece(0, 0, -KING)
    check("Check blocked by own pawn", not is_in_check(b6, WHITE))


# ===================================================================
# 11. Pinned pieces
# ===================================================================
def test_pins():
    print("\n=== Pinned Pieces ===")
    # White bishop pinned to king by black rook
    b = empty_board()
    b.set_piece(7, 4, KING)     # e1
    b.set_piece(5, 4, BISHOP)   # e3 (pinned along e-file)
    b.set_piece(0, 4, -ROOK)    # e8 pins the bishop
    b.set_piece(0, 0, -KING)
    moves = get_legal_moves(b, WHITE)
    bishop_moves = [(fr, fc, tr, tc) for fr, fc, tr, tc in moves if fr == 5 and fc == 4]
    check("Pinned bishop has no legal moves", len(bishop_moves) == 0)

    # Pinned pawn can still advance along pin line
    b2 = empty_board()
    b2.set_piece(7, 4, KING)    # e1
    b2.set_piece(6, 4, PAWN)    # e2 (pinned along e-file by rook)
    b2.set_piece(0, 4, -ROOK)   # e8
    b2.set_piece(0, 0, -KING)
    moves2 = get_legal_moves(b2, WHITE)
    pawn_moves = [(fr, fc, tr, tc) for fr, fc, tr, tc in moves2 if fr == 6 and fc == 4]
    check("Pinned pawn on same file can still advance", len(pawn_moves) > 0)


# ===================================================================
# 12. Checkmate
# ===================================================================
def test_checkmate():
    print("\n=== Checkmate ===")
    # Back rank mate
    b = empty_board()
    b.set_piece(7, 7, KING)     # h1
    b.set_piece(6, 6, PAWN)     # g2
    b.set_piece(6, 7, PAWN)     # h2
    b.set_piece(7, 0, -ROOK)    # a1 delivers check
    b.set_piece(0, 0, -KING)
    check("Back rank mate detected", is_checkmate(b, WHITE))
    check("Not stalemate", not is_stalemate(b, WHITE))

    # Scholar's mate position (simplified)
    b2 = empty_board()
    b2.set_piece(0, 4, -KING)
    b2.set_piece(1, 5, -PAWN)   # f7
    b2.set_piece(0, 5, -BISHOP) # f8
    b2.set_piece(4, 7, QUEEN)   # Qh4... actually let's do a clean mate
    # Simpler: Fool's mate
    b3 = empty_board()
    b3.set_piece(0, 4, -KING)
    b3.set_piece(0, 3, -QUEEN)
    b3.set_piece(1, 0, -PAWN)
    b3.set_piece(1, 1, -PAWN)
    b3.set_piece(1, 2, -PAWN)
    b3.set_piece(1, 3, -PAWN)
    b3.set_piece(1, 5, -PAWN)
    b3.set_piece(1, 6, -PAWN)
    b3.set_piece(1, 7, -PAWN)
    b3.set_piece(7, 4, KING)
    b3.set_piece(6, 5, PAWN)    # blocks f7
    b3.set_piece(3, 7, -QUEEN)  # Qh5 gives check — actually let me just do a known mate
    # Use a simple 2-rook mate
    b4 = empty_board()
    b4.set_piece(7, 0, KING)    # Ka1... actually row 0 col 0
    b4.set_piece(0, 0, KING)    # White king a8
    b4.set_piece(7, 7, -KING)   # Black king h1
    b4.set_piece(6, 0, -ROOK)   # rook on a2 (blocks rank 6)
    # Hmm, let me just do the clearest possible mate
    # Black king on h8, white queen on g7, white king on f6
    b5 = empty_board()
    b5.set_piece(2, 5, KING)    # Kf6
    b5.set_piece(1, 6, QUEEN)   # Qg7
    b5.set_piece(0, 7, -KING)   # Kh8
    check("Queen+King mate", is_checkmate(b5, BLACK))

    # Not checkmate if can escape
    b6 = empty_board()
    b6.set_piece(7, 7, KING)
    b6.set_piece(7, 0, -ROOK)  # check on rank 8... er row 7
    b6.set_piece(0, 0, -KING)
    # King can escape to g2 (6,6), h2 (6,7)
    check("Not checkmate if king can escape", not is_checkmate(b6, WHITE))

    # Not checkmate if piece can block
    b7 = empty_board()
    b7.set_piece(7, 7, KING)    # h1
    b7.set_piece(6, 6, PAWN)    # g2
    b7.set_piece(6, 7, PAWN)    # h2
    b7.set_piece(7, 0, -ROOK)   # a1 delivers check
    b7.set_piece(3, 3, ROOK)    # White rook can block on row 7
    b7.set_piece(0, 0, -KING)
    check("Not checkmate if rook can block", not is_checkmate(b7, WHITE))


# ===================================================================
# 13. Stalemate
# ===================================================================
def test_stalemate():
    print("\n=== Stalemate ===")
    # Classic stalemate: king trapped in corner
    b = empty_board()
    b.set_piece(0, 0, KING)     # Ka8
    b.set_piece(1, 2, -QUEEN)   # Qc7 (controls a7, b7, c7, but also b8?)
    # Actually, let's use a textbook stalemate
    # White king on a8, Black queen on b6, Black king on c8
    # Wait: White king a8 = (0,0), queen b6 = (2,1), king c8 = (0,2)
    # King on a8: can go to a7(1,0), b8(0,1), b7(1,1)
    # Queen on b6 controls: b7(1,1), b8(0,1), a7(1,0), a5, c7, etc.
    # a7 controlled by queen? b6 to a7 is diagonal -> yes
    # b8 controlled by queen? b6 to b8 is file -> yes
    # b7 controlled by queen? b6 to b7 is file -> yes
    # And king on c8 doesn't attack a7,b8... wait c8 is adjacent to b8? No - (0,2) to (0,1) yes adjacent!
    # So b8 is controlled by both queen and king. a7 by queen. b7 by queen.
    # White king has no moves -> stalemate (if not in check)
    # Is white king in check? Queen on b6 doesn't reach a8. King on c8 doesn't reach a8. -> Not in check. Good.
    b = empty_board()
    b.set_piece(0, 0, KING)     # Ka8
    b.set_piece(2, 1, -QUEEN)   # Qb6
    b.set_piece(0, 2, -KING)    # Kc8
    check("Stalemate: king trapped in corner", is_stalemate(b, WHITE))
    check("Not checkmate when stalemated", not is_checkmate(b, WHITE))

    # Not stalemate if has legal move
    b2 = empty_board()
    b2.set_piece(0, 0, KING)
    b2.set_piece(2, 2, -QUEEN)
    b2.set_piece(5, 5, -KING)
    check("Not stalemate if king has escape", not is_stalemate(b2, WHITE))


# ===================================================================
# 14. Insufficient material
# ===================================================================
def test_insufficient_material():
    print("\n=== Insufficient Material ===")
    # K vs K
    b = empty_board()
    b.set_piece(0, 0, KING)
    b.set_piece(7, 7, -KING)
    check("K vs K is insufficient", is_insufficient_material(b))

    # K+B vs K
    b2 = empty_board()
    b2.set_piece(0, 0, KING)
    b2.set_piece(3, 3, BISHOP)
    b2.set_piece(7, 7, -KING)
    check("K+B vs K is insufficient", is_insufficient_material(b2))

    # K+N vs K
    b3 = empty_board()
    b3.set_piece(0, 0, KING)
    b3.set_piece(3, 3, KNIGHT)
    b3.set_piece(7, 7, -KING)
    check("K+N vs K is insufficient", is_insufficient_material(b3))

    # K+R vs K is sufficient
    b4 = empty_board()
    b4.set_piece(0, 0, KING)
    b4.set_piece(3, 3, ROOK)
    b4.set_piece(7, 7, -KING)
    check("K+R vs K is sufficient", not is_insufficient_material(b4))

    # K+Q vs K is sufficient
    b5 = empty_board()
    b5.set_piece(0, 0, KING)
    b5.set_piece(3, 3, QUEEN)
    b5.set_piece(7, 7, -KING)
    check("K+Q vs K is sufficient", not is_insufficient_material(b5))

    # K+P vs K is sufficient
    b6 = empty_board()
    b6.set_piece(0, 0, KING)
    b6.set_piece(3, 3, PAWN)
    b6.set_piece(7, 7, -KING)
    check("K+P vs K is sufficient", not is_insufficient_material(b6))


# ===================================================================
# 15. Fifty-move rule
# ===================================================================
def test_fifty_move_rule():
    print("\n=== Fifty-Move Rule ===")
    check("99 half-moves is not draw", not is_fifty_move_draw(99))
    check("100 half-moves is draw", is_fifty_move_draw(100))
    check("101 half-moves is draw", is_fifty_move_draw(101))

    # Integration: halfmove clock resets on pawn move and capture
    game = Game()
    game.halfmove_clock = 99
    # Simulate a pawn move to reset
    # Move e2-e4
    game.play_move(6, 4, 4, 4)  # White e2-e4 (pawn move resets clock)
    check("Halfmove clock resets on pawn move", game.halfmove_clock == 0)


# ===================================================================
# 16. Threefold repetition
# ===================================================================
def test_threefold_repetition():
    print("\n=== Threefold Repetition ===")
    game = Game()
    # Play moves to repeat position: Nf3 Nc6 Ng1 Nb8 (x3)
    moves_sequence = [
        (7, 6, 5, 5),  # Nf3
        (0, 1, 2, 2),  # Nc6
        (5, 5, 7, 6),  # Ng1
        (2, 2, 0, 1),  # Nb8
        (7, 6, 5, 5),  # Nf3
        (0, 1, 2, 2),  # Nc6
        (5, 5, 7, 6),  # Ng1
        (2, 2, 0, 1),  # Nb8
        (7, 6, 5, 5),  # Nf3
        (0, 1, 2, 2),  # Nc6
        (5, 5, 7, 6),  # Ng1
        (2, 2, 0, 1),  # Nb8
    ]
    for move in moves_sequence:
        ok = game.play_move(*move)
        if not ok:
            break
        if game.is_game_over():
            break
    check("Threefold repetition detected as draw", game.result == 0)

    # Same board but different castling rights should NOT be threefold
    # White moves king back and forth (loses castling rights on first king move)
    # vs starting position (has castling rights) — board is identical but position differs
    game2 = Game()
    moves2 = [
        (7, 6, 5, 5),  # Nf3
        (0, 1, 2, 2),  # Nc6
        (5, 5, 7, 6),  # Ng1
        (2, 2, 0, 1),  # Nb8
        # Now move the white king out and back (loses castling rights)
        (7, 4, 6, 4),  # Ke2 (White king moves — loses both castling rights)
        (0, 1, 2, 2),  # Nc6
        (6, 4, 7, 4),  # Ke1 (king returns — board looks like start but no castling)
        (2, 2, 0, 1),  # Nb8
        # Now repeat Nf3/Nc6/Ng1/Nb8 — board matches start position but
        # castling rights differ, so should NOT trigger threefold
        (7, 6, 5, 5),  # Nf3
        (0, 1, 2, 2),  # Nc6
        (5, 5, 7, 6),  # Ng1
        (2, 2, 0, 1),  # Nb8
    ]
    for move in moves2:
        ok = game2.play_move(*move)
        if not ok:
            break
        if game2.is_game_over():
            break
    check("Different castling rights prevents threefold", game2.result is None)

    # Same board but different en passant target should NOT be threefold
    # Position repeats with identical pieces but one has an ep target and another doesn't
    game3 = Game()
    moves3 = [
        (6, 4, 4, 4),  # e4
        (1, 0, 2, 0),  # a6
        (7, 6, 5, 5),  # Nf3
        (0, 1, 2, 2),  # Nc6
        (5, 5, 7, 6),  # Ng1
        (2, 2, 0, 1),  # Nb8
        (7, 6, 5, 5),  # Nf3
        (0, 1, 2, 2),  # Nc6
        (5, 5, 7, 6),  # Ng1
        (2, 2, 0, 1),  # Nb8
        # Board now matches the position after 1. e4 a6 2. Nf3 Nc6
        # Both times: same pieces, same turn, same castling rights
        # But the first occurrence (after move 4) had no ep target (Nc6 cleared it)
        # and the current position also has no ep target — so these ARE the same
        # Let me construct a proper test instead
    ]
    for move in moves3:
        ok = game3.play_move(*move)
        if not ok:
            break
        if game3.is_game_over():
            break
    # For a proper ep test: use a scenario where same board arises once with ep and once without
    # After e2-e4, ep target is e3. If the board repeats but without a double push, ep differs.
    # This is hard to construct in a full game, so just verify the position key directly.
    game4 = Game()
    game4.play_move(6, 4, 4, 4)  # e4 (ep = e3)
    key_with_ep = game4._position_key()
    game4.play_move(1, 0, 2, 0)  # a6
    game4.play_move(4, 4, 3, 4)  # e5
    game4.play_move(0, 1, 2, 2)  # Nc6
    game4.play_move(7, 6, 5, 5)  # Nf3
    game4.play_move(2, 2, 0, 1)  # Nb8
    game4.play_move(5, 5, 7, 6)  # Ng1 — not same board as after e4 anyway

    # Directly test position key includes ep
    game5 = Game()
    game5.en_passant_target = (5, 4)
    key_a = game5._position_key()
    game5.en_passant_target = None
    key_b = game5._position_key()
    check("Position keys differ when en passant target differs", key_a != key_b)

    # Directly test position key includes castling rights
    game6 = Game()
    key_c = game6._position_key()
    game6.castling_rights[(WHITE, 'K')] = False
    key_d = game6._position_key()
    check("Position keys differ when castling rights differ", key_c != key_d)

    # Directly test position key includes turn
    game7 = Game()
    key_e = game7._position_key()
    game7.turn = BLACK
    key_f = game7._position_key()
    check("Position keys differ when turn differs", key_e != key_f)


# ===================================================================
# 17. Game integration
# ===================================================================
def test_game_integration():
    print("\n=== Game Integration ===")
    game = Game()
    check("Game starts with white to move", game.turn == WHITE)
    check("Game not over at start", not game.is_game_over())

    # Legal first move
    ok = game.play_move(6, 4, 4, 4)  # e2-e4
    check("e2-e4 is legal", ok)
    check("Now black's turn", game.turn == BLACK)

    # Illegal move
    ok2 = game.play_move(6, 3, 4, 3)  # d2-d4 is a white move, but it's black's turn
    check("White move rejected on black's turn", not ok2)

    # Black responds
    ok3 = game.play_move(1, 4, 3, 4)  # e7-e5
    check("e7-e5 is legal", ok3)

    # En passant target set after double push
    game2 = Game()
    game2.play_move(6, 4, 4, 4)  # e4
    check("En passant target set to e3 after e4", game2.en_passant_target == (5, 4))
    game2.play_move(1, 3, 3, 3)  # d5
    check("En passant target updated to d6 after d5", game2.en_passant_target == (2, 3))
    # After a non-double push, ep target should be None
    game2.play_move(4, 4, 3, 3)  # exd5 (wait, pawn is on row 4 col 4)
    # Actually after e4 d5, white pawn is on e4 (row 4 col 4), black on d5 (row 3 col 3)
    # exd5 = (4,4) -> (3,3)
    check("En passant target cleared after non-double-push", game2.en_passant_target is None)


# ===================================================================
# 18. Square attack detection
# ===================================================================
def test_square_attacked():
    print("\n=== Square Attack Detection ===")
    b = empty_board()
    b.set_piece(4, 4, ROOK)  # White rook on e4
    b.set_piece(0, 0, KING)
    b.set_piece(7, 7, -KING)

    check("Rook attacks e1", is_square_attacked(b, 7, 4, WHITE))
    check("Rook attacks e8", is_square_attacked(b, 0, 4, WHITE))
    check("Rook attacks a4", is_square_attacked(b, 4, 0, WHITE))
    check("Rook attacks h4", is_square_attacked(b, 4, 7, WHITE))
    check("Rook does not attack d5", not is_square_attacked(b, 3, 3, WHITE))

    # Pawn attacks
    b2 = empty_board()
    b2.set_piece(4, 4, PAWN)  # White pawn on e4
    b2.set_piece(0, 0, KING)
    b2.set_piece(7, 7, -KING)
    check("White pawn attacks d5", is_square_attacked(b2, 3, 3, WHITE))
    check("White pawn attacks f5", is_square_attacked(b2, 3, 5, WHITE))
    check("White pawn does NOT attack e5", not is_square_attacked(b2, 3, 4, WHITE))
    check("White pawn does NOT attack d3", not is_square_attacked(b2, 5, 3, WHITE))


# ===================================================================
# 19. Edge cases
# ===================================================================
def test_edge_cases():
    print("\n=== Edge Cases ===")

    # Double check: only king can move
    b = empty_board()
    b.set_piece(4, 4, KING)     # White king e4
    b.set_piece(4, 0, -ROOK)    # Black rook a4 (check along rank)
    b.set_piece(0, 0, -BISHOP)  # Black bishop a8 (check along diagonal)
    b.set_piece(7, 7, -KING)
    # King is in check from rook on a4 and... is it also in check from bishop on a8?
    # a8 to e4: (0,0) to (4,4) is diagonal. Yes!
    # Double check: only king moves are legal
    in_chk = is_in_check(b, WHITE)
    check("Double check detected", in_chk)
    moves = get_legal_moves(b, WHITE)
    # All moves should be king moves
    all_king = all(b.get_piece(fr, fc) == KING for fr, fc, tr, tc in moves)
    check("In double check, only king can move", all_king)

    # Pawn on edge of board
    b2 = empty_board()
    b2.set_piece(4, 0, PAWN)  # a4
    b2.set_piece(7, 4, KING)
    b2.set_piece(0, 4, -KING)
    moves2 = get_legal_moves(b2, WHITE)
    pawn_moves = [(fr, fc, tr, tc) for fr, fc, tr, tc in moves2 if fr == 4 and fc == 0]
    check("Pawn on a-file can only move forward", len(pawn_moves) == 1)
    check("Pawn on a-file moves to a5", move_in(moves2, 4, 0, 3, 0))


# ===================================================================
# Run all tests
# ===================================================================
if __name__ == '__main__':
    test_initial_board()
    test_pawn_moves()
    test_knight_moves()
    test_sliding_pieces()
    test_king_moves()
    test_en_passant()
    test_castling()
    test_castling_rights_update()
    test_pawn_promotion()
    test_check()
    test_pins()
    test_checkmate()
    test_stalemate()
    test_insufficient_material()
    test_fifty_move_rule()
    test_threefold_repetition()
    test_game_integration()
    test_square_attacked()
    test_edge_cases()

    print(f"\n{'='*50}")
    print(f"Results: {passed} passed, {failed} failed out of {passed + failed} tests")
    if failed == 0:
        print("All tests passed!")
    else:
        print(f"WARNING: {failed} test(s) FAILED")
    sys.exit(0 if failed == 0 else 1)
