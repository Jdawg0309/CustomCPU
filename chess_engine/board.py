"""Board class: 8x8 NumPy array representation of the chess board."""

import numpy as np
from pieces import PIECE_SYMBOLS


INITIAL_BOARD = np.array([
    [-5, -3, -4, -9, -10, -4, -3, -5],
    [-1, -1, -1, -1,  -1, -1, -1, -1],
    [ 0,  0,  0,  0,   0,  0,  0,  0],
    [ 0,  0,  0,  0,   0,  0,  0,  0],
    [ 0,  0,  0,  0,   0,  0,  0,  0],
    [ 0,  0,  0,  0,   0,  0,  0,  0],
    [ 1,  1,  1,  1,   1,  1,  1,  1],
    [ 5,  3,  4,  9,  10,  4,  3,  5],
], dtype=np.int8)


class Board:
    """8x8 chess board backed by a NumPy int8 array."""

    def __init__(self, array=None):
        if array is not None:
            self.array = array.copy()
        else:
            self.array = INITIAL_BOARD.copy()

    def get_piece(self, r, c):
        return int(self.array[r, c])

    def set_piece(self, r, c, val):
        self.array[r, c] = val

    def is_empty(self, r, c):
        return self.array[r, c] == 0

    def copy(self):
        return Board(array=self.array)

    def find_king(self, color):
        """Return (row, col) of the king for the given color."""
        king_val = 10 * color
        positions = np.argwhere(self.array == king_val)
        if len(positions) == 0:
            return None
        return int(positions[0][0]), int(positions[0][1])

    def material_balance(self):
        """Sum of all piece values on the board (positive favors white)."""
        return int(np.sum(self.array))

    def display(self):
        """Print the board with piece symbols and coordinates."""
        print("  a b c d e f g h")
        for r in range(8):
            rank = 8 - r
            row_str = f"{rank} "
            for c in range(8):
                val = self.array[r, c]
                row_str += PIECE_SYMBOLS.get(val, '?') + ' '
            print(row_str + f"{rank}")
        print("  a b c d e f g h")

    def __repr__(self):
        return f"Board(\n{self.array}\n)"
