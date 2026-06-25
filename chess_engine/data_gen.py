"""Training data generation: self-play games, export to .npy and CSV."""

import os
import random
import numpy as np
from game import Game


MAX_MOVES_PER_GAME = 300  # Safety limit to prevent infinite games


def play_random_game(seed=None):
    """Play a game with random legal moves. Returns list of (board_state, move, material_balance) and result."""
    if seed is not None:
        random.seed(seed)

    game = Game()
    records = []

    for _ in range(MAX_MOVES_PER_GAME):
        if game.is_game_over():
            break

        board_state = game.get_board_state()
        material = game.board.material_balance()
        legal_moves = game.get_legal_moves()

        if not legal_moves:
            break

        move = random.choice(legal_moves)
        records.append((board_state, move, material))
        game.play_move(*move)

    result = game.get_result()
    if result is None:
        result = 0  # Treat unfinished games as draws

    return records, result


def generate_training_data(num_games, output_dir, verbose=True):
    """Play N random games and collect training data.

    Exports:
      - board_states.npy: shape (num_positions, 8, 8)
      - labels.npy: shape (num_positions,) — game result for each position
      - training_data.csv: flattened board + move + result + material_balance
    """
    os.makedirs(output_dir, exist_ok=True)

    all_boards = []
    all_moves = []
    all_results = []
    all_material = []

    game_results = {1: 0, -1: 0, 0: 0}

    for i in range(num_games):
        records, result = play_random_game()
        game_results[result] = game_results.get(result, 0) + 1

        for board_state, move, material in records:
            all_boards.append(board_state)
            all_moves.append(move)
            all_results.append(result)
            all_material.append(material)

        if verbose and (i + 1) % max(1, num_games // 10) == 0:
            print(f"  Game {i + 1}/{num_games} completed ({len(all_boards)} positions)")

    # Convert to arrays
    board_array = np.array(all_boards, dtype=np.int8)   # (N, 8, 8)
    result_array = np.array(all_results, dtype=np.int8)  # (N,)
    move_array = np.array(all_moves, dtype=np.int16)     # (N, 4)
    material_array = np.array(all_material, dtype=np.int16)  # (N,)

    # Save .npy files
    np.save(os.path.join(output_dir, 'board_states.npy'), board_array)
    np.save(os.path.join(output_dir, 'labels.npy'), result_array)
    np.save(os.path.join(output_dir, 'moves.npy'), move_array)

    # Save CSV
    csv_path = os.path.join(output_dir, 'training_data.csv')
    _export_csv(csv_path, board_array, move_array, result_array, material_array)

    stats = {
        'num_games': num_games,
        'num_positions': len(all_boards),
        'white_wins': game_results[1],
        'black_wins': game_results[-1],
        'draws': game_results[0],
        'board_shape': board_array.shape,
    }

    return stats


def _export_csv(csv_path, boards, moves, results, materials):
    """Export training data as CSV with header."""
    with open(csv_path, 'w') as f:
        # Header: 64 board squares + move (4 values) + result + material_balance
        board_cols = [f"sq_{r}{c}" for r in range(8) for c in range(8)]
        move_cols = ["from_r", "from_c", "to_r", "to_c"]
        header = ','.join(board_cols + move_cols + ["result", "material_balance"])
        f.write(header + '\n')

        for i in range(len(boards)):
            board_flat = boards[i].flatten()
            row_data = list(board_flat) + list(moves[i]) + [results[i], materials[i]]
            f.write(','.join(str(int(x)) for x in row_data) + '\n')
