"""Piece constants, value mapping, and shift vectors for move generation."""

import numpy as np

# Piece constants (absolute values; White = positive, Black = negative)
EMPTY = 0
PAWN = 1
KNIGHT = 3
BISHOP = 4
ROOK = 5
QUEEN = 9
KING = 10

# Colors
WHITE = 1
BLACK = -1

# Piece symbol mapping for display
PIECE_SYMBOLS = {
    0: '.',
    1: 'P', -1: 'p',
    3: 'N', -3: 'n',
    4: 'B', -4: 'b',
    5: 'R', -5: 'r',
    9: 'Q', -9: 'q',
    10: 'K', -10: 'k',
}

PIECE_NAMES = {
    PAWN: 'Pawn',
    KNIGHT: 'Knight',
    BISHOP: 'Bishop',
    ROOK: 'Rook',
    QUEEN: 'Queen',
    KING: 'King',
}

# Shift vectors (dr, dc) for each piece type
KNIGHT_SHIFTS = [
    (-2, -1), (-2, 1), (-1, -2), (-1, 2),
    (1, -2), (1, 2), (2, -1), (2, 1),
]

BISHOP_SHIFTS = [(-1, -1), (-1, 1), (1, -1), (1, 1)]

ROOK_SHIFTS = [(-1, 0), (1, 0), (0, -1), (0, 1)]

QUEEN_SHIFTS = BISHOP_SHIFTS + ROOK_SHIFTS

KING_SHIFTS = QUEEN_SHIFTS  # Same directions, but only 1 step

# Map piece type to its shift vectors
PIECE_SHIFTS = {
    KNIGHT: KNIGHT_SHIFTS,
    BISHOP: BISHOP_SHIFTS,
    ROOK: ROOK_SHIFTS,
    QUEEN: QUEEN_SHIFTS,
    KING: KING_SHIFTS,
}

# Sliding pieces repeat their shift until blocked
SLIDING_PIECES = {BISHOP, ROOK, QUEEN}

# Pawn shifts are handled separately in moves.py because they depend on color,
# starting row, and whether the move is a capture or push.
