"""Interactive play mode: human vs simple AI in the terminal."""

import random
from game import Game
from pieces import (
    WHITE, BLACK, EMPTY, PAWN, KNIGHT, BISHOP, ROOK, QUEEN, KING,
    PIECE_NAMES, PIECE_SYMBOLS,
)


# Material values for the AI heuristic
PIECE_VALUES = {
    PAWN: 1,
    KNIGHT: 3,
    BISHOP: 3,
    ROOK: 5,
    QUEEN: 9,
    KING: 0,  # King can't really be captured, but needed for lookup
}


# ---------------------------------------------------------------------------
# Coordinate conversion helpers
# ---------------------------------------------------------------------------

def sq_to_alg(r, c):
    """Convert internal (row, col) to algebraic notation like 'e4'."""
    return chr(ord('a') + c) + str(8 - r)


def alg_to_sq(alg):
    """Convert algebraic notation like 'e4' to internal (row, col).

    Returns (row, col) or None if invalid.
    """
    if len(alg) != 2:
        return None
    file_ch, rank_ch = alg[0], alg[1]
    if file_ch < 'a' or file_ch > 'h' or rank_ch < '1' or rank_ch > '8':
        return None
    col = ord(file_ch) - ord('a')
    row = 8 - int(rank_ch)
    return (row, col)


def move_to_alg(from_r, from_c, to_r, to_c):
    """Convert a move tuple to algebraic string like 'e2e4'."""
    return sq_to_alg(from_r, from_c) + sq_to_alg(to_r, to_c)


def parse_move_input(text):
    """Parse user input into (from_r, from_c, to_r, to_c) or a single square.

    Accepted formats:
      'e2e4'   -> move tuple
      'e2 e4'  -> move tuple
      'e2'     -> single square (for showing legal moves)

    Returns:
      ('move', (from_r, from_c, to_r, to_c))  -- valid move input
      ('square', (r, c))                       -- single square query
      ('quit', None)                           -- resign / exit
      ('error', message)                       -- parse failure
    """
    text = text.strip().lower()
    if text in ('quit', 'resign', 'exit', 'q'):
        return ('quit', None)

    parts = text.split()
    if len(parts) == 2:
        # "e2 e4" format
        src = alg_to_sq(parts[0])
        dst = alg_to_sq(parts[1])
        if src is None or dst is None:
            return ('error', "Invalid square(s). Use a-h for file and 1-8 for rank.")
        return ('move', (src[0], src[1], dst[0], dst[1]))

    if len(parts) == 1:
        token = parts[0]
        if len(token) == 4:
            # "e2e4" format
            src = alg_to_sq(token[:2])
            dst = alg_to_sq(token[2:])
            if src is None or dst is None:
                return ('error', "Invalid square(s). Use a-h for file and 1-8 for rank.")
            return ('move', (src[0], src[1], dst[0], dst[1]))
        if len(token) == 2:
            sq = alg_to_sq(token)
            if sq is None:
                return ('error', "Invalid square. Use a-h for file and 1-8 for rank.")
            return ('square', sq)

    return ('error', "Enter a move like 'e2e4' or 'e2 e4', a square like 'e2', or 'quit'.")


# ---------------------------------------------------------------------------
# Move description helpers
# ---------------------------------------------------------------------------

def describe_move(game, from_r, from_c, to_r, to_c):
    """Return a human-readable description of a move."""
    piece = game.board.get_piece(from_r, from_c)
    piece_type = abs(piece)
    captured = game.board.get_piece(to_r, to_c)
    name = PIECE_NAMES.get(piece_type, '?')
    src = sq_to_alg(from_r, from_c)
    dst = sq_to_alg(to_r, to_c)

    # Detect castling
    if piece_type == KING and abs(from_c - to_c) == 2:
        if to_c > from_c:
            return f"O-O (kingside castling)"
        else:
            return f"O-O-O (queenside castling)"

    # Detect en passant
    if piece_type == PAWN and captured == EMPTY and from_c != to_c:
        return f"{name} {src} captures en passant on {dst}"

    if captured != EMPTY:
        cap_name = PIECE_NAMES.get(abs(captured), '?')
        return f"{name} {src} captures {cap_name} on {dst}"

    return f"{name} {src} to {dst}"


# ---------------------------------------------------------------------------
# Simple AI
# ---------------------------------------------------------------------------

def ai_pick_move(game):
    """Pick a move for the AI using a material-greedy heuristic.

    Strategy:
      1. Prefer captures, ordered by victim value (highest first).
      2. Among non-captures, pick randomly.
    """
    legal_moves = game.get_legal_moves()
    if not legal_moves:
        return None

    captures = []
    non_captures = []

    for move in legal_moves:
        from_r, from_c, to_r, to_c = move
        target = game.board.get_piece(to_r, to_c)
        piece = game.board.get_piece(from_r, from_c)

        # Also count en passant as a capture
        if target != EMPTY:
            captures.append((PIECE_VALUES.get(abs(target), 0), move))
        elif abs(piece) == PAWN and from_c != to_c:
            # En passant capture
            captures.append((PIECE_VALUES[PAWN], move))
        else:
            non_captures.append(move)

    if captures:
        # Sort by victim value descending, pick the best
        captures.sort(key=lambda x: x[0], reverse=True)
        best_value = captures[0][0]
        # Among captures of equal value, pick randomly
        best = [m for v, m in captures if v == best_value]
        return random.choice(best)

    return random.choice(non_captures)


# ---------------------------------------------------------------------------
# Main game loop
# ---------------------------------------------------------------------------

def play_interactive():
    """Run an interactive game in the terminal."""
    print("=================================")
    print("  Chess Engine -- Interactive Play")
    print("=================================")
    print()

    # Ask for color choice
    while True:
        choice = input("Play as (w)hite or (b)lack? ").strip().lower()
        if choice in ('w', 'white'):
            human_color = WHITE
            break
        elif choice in ('b', 'black'):
            human_color = BLACK
            break
        else:
            print("Please enter 'w' for White or 'b' for Black.")

    ai_color = -human_color
    human_name = "White" if human_color == WHITE else "Black"
    ai_name = "White" if ai_color == WHITE else "Black"
    print(f"\nYou are playing {human_name}. AI is playing {ai_name}.")
    print("Enter moves like 'e2e4' or 'e2 e4'.")
    print("Type a square like 'e2' to see legal moves from that square.")
    print("Type 'quit' to resign.\n")

    game = Game()
    game.display()
    print()

    while not game.is_game_over():
        if game.turn == human_color:
            # Human's turn
            move_made = False
            while not move_made:
                try:
                    raw = input(f"Your move ({human_name}): ")
                except (EOFError, KeyboardInterrupt):
                    print("\nGame ended by user.")
                    return

                parsed = parse_move_input(raw)

                if parsed[0] == 'quit':
                    print(f"\nYou resigned. {ai_name} wins!")
                    return

                if parsed[0] == 'error':
                    print(f"  {parsed[1]}")
                    continue

                if parsed[0] == 'square':
                    r, c = parsed[1]
                    piece = game.board.get_piece(r, c)
                    if piece == EMPTY:
                        print(f"  {sq_to_alg(r, c)} is empty.")
                        continue
                    # Show legal moves from this square
                    legal = game.get_legal_moves()
                    from_sq = [(fr, fc, tr, tc) for fr, fc, tr, tc in legal
                               if fr == r and fc == c]
                    if not from_sq:
                        sym = PIECE_SYMBOLS.get(piece, '?')
                        print(f"  {sym} on {sq_to_alg(r, c)} has no legal moves.")
                    else:
                        sym = PIECE_SYMBOLS.get(piece, '?')
                        dests = [sq_to_alg(tr, tc) for _, _, tr, tc in from_sq]
                        print(f"  {sym} on {sq_to_alg(r, c)} can move to: {', '.join(dests)}")
                    continue

                # parsed[0] == 'move'
                from_r, from_c, to_r, to_c = parsed[1]
                desc = describe_move(game, from_r, from_c, to_r, to_c)
                ok = game.play_move(from_r, from_c, to_r, to_c)
                if not ok:
                    print("  Illegal move. Type a square (e.g. 'e2') to see legal moves.")
                    continue

                print(f"  -> {desc}")
                move_made = True

        else:
            # AI's turn
            move = ai_pick_move(game)
            if move is None:
                break  # Game should already be over
            from_r, from_c, to_r, to_c = move
            desc = describe_move(game, from_r, from_c, to_r, to_c)
            game.play_move(from_r, from_c, to_r, to_c)
            print(f"  AI ({ai_name}): {desc}")

        # Display board after each move
        print()
        game.display()
        print()

    # Announce result
    result = game.get_result()
    print("=== Game Over ===")
    if result == 1:
        print("White wins by checkmate!")
    elif result == -1:
        print("Black wins by checkmate!")
    elif result == 0:
        print("The game is a draw.")
    else:
        print("Game ended.")


if __name__ == '__main__':
    play_interactive()
