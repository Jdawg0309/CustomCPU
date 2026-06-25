"""Game rules: check, checkmate, stalemate, castling rights, en passant, promotion."""

from pieces import WHITE, BLACK, KING, ROOK, PAWN
from moves import is_in_check, get_legal_moves


def is_checkmate(board, color, en_passant_target=None, castling_rights=None):
    """Color is in check and has no legal moves."""
    if not is_in_check(board, color):
        return False
    return len(get_legal_moves(board, color, en_passant_target, castling_rights)) == 0


def is_stalemate(board, color, en_passant_target=None, castling_rights=None):
    """Color is NOT in check but has no legal moves."""
    if is_in_check(board, color):
        return False
    return len(get_legal_moves(board, color, en_passant_target, castling_rights)) == 0


def is_insufficient_material(board):
    """Check for draw by insufficient material (K vs K)."""
    import numpy as np
    pieces = board.array[board.array != 0]
    abs_pieces = np.abs(pieces)
    # Remove kings
    non_kings = abs_pieces[abs_pieces != KING]
    if len(non_kings) == 0:
        return True  # K vs K
    if len(non_kings) == 1 and non_kings[0] in (3, 4):
        return True  # K+B vs K or K+N vs K
    return False


def initial_castling_rights():
    """Return default castling rights at game start."""
    return {
        (WHITE, 'K'): True,
        (WHITE, 'Q'): True,
        (BLACK, 'K'): True,
        (BLACK, 'Q'): True,
    }


def update_castling_rights(castling_rights, board, from_r, from_c, to_r, to_c):
    """Update castling rights after a move. Returns new castling rights dict."""
    rights = dict(castling_rights)
    piece = board.get_piece(from_r, from_c)
    piece_type = abs(piece)

    # King moved — lose both castling rights
    if piece_type == KING:
        color = 1 if piece > 0 else -1
        rights[(color, 'K')] = False
        rights[(color, 'Q')] = False

    # Rook moved — lose that side's castling right
    if piece_type == ROOK:
        if from_r == 7 and from_c == 0:
            rights[(WHITE, 'Q')] = False
        elif from_r == 7 and from_c == 7:
            rights[(WHITE, 'K')] = False
        elif from_r == 0 and from_c == 0:
            rights[(BLACK, 'Q')] = False
        elif from_r == 0 and from_c == 7:
            rights[(BLACK, 'K')] = False

    # Rook captured — lose that side's castling right
    if to_r == 7 and to_c == 0:
        rights[(WHITE, 'Q')] = False
    elif to_r == 7 and to_c == 7:
        rights[(WHITE, 'K')] = False
    elif to_r == 0 and to_c == 0:
        rights[(BLACK, 'Q')] = False
    elif to_r == 0 and to_c == 7:
        rights[(BLACK, 'K')] = False

    return rights


def is_fifty_move_draw(halfmove_clock):
    """Draw if 50 moves (100 half-moves) without a pawn move or capture."""
    return halfmove_clock >= 100
