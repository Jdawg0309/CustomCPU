"""Entry point: run games, configure data generation."""

import argparse
import os
import sys
import numpy as np

from data_gen import generate_training_data
from board import Board


def main():
    parser = argparse.ArgumentParser(description='Chess Engine Training Data Generator')
    parser.add_argument('--games', type=int, default=10,
                        help='Number of games to play (default: 10)')
    parser.add_argument('--output', type=str, default=None,
                        help='Output directory for training data')
    parser.add_argument('--show-board', action='store_true',
                        help='Display the initial board and exit')
    parser.add_argument('--play', action='store_true',
                        help='Launch interactive play mode (human vs AI)')

    args = parser.parse_args()

    if args.play:
        from play import play_interactive
        play_interactive()
        return

    if args.show_board:
        board = Board()
        board.display()
        return

    # Default output directory
    if args.output is None:
        script_dir = os.path.dirname(os.path.abspath(__file__))
        args.output = os.path.join(script_dir, 'training_data')

    print(f"Chess Engine Training Data Generator")
    print(f"=====================================")
    print(f"Games to play: {args.games}")
    print(f"Output directory: {args.output}")
    print()

    # Show initial board
    print("Initial board position:")
    Board().display()
    print()

    # Generate data
    print("Generating training data...")
    stats = generate_training_data(args.games, args.output)

    # Print summary
    print()
    print(f"Summary")
    print(f"-------")
    print(f"Games played:     {stats['num_games']}")
    print(f"Total positions:  {stats['num_positions']}")
    print(f"White wins:       {stats['white_wins']}")
    print(f"Black wins:       {stats['black_wins']}")
    print(f"Draws:            {stats['draws']}")
    print(f"Board data shape: {stats['board_shape']}")
    print()

    # Verify output files
    npy_path = os.path.join(args.output, 'board_states.npy')
    csv_path = os.path.join(args.output, 'training_data.csv')

    if os.path.exists(npy_path):
        data = np.load(npy_path)
        print(f"board_states.npy: shape={data.shape}, dtype={data.dtype}")

    labels_path = os.path.join(args.output, 'labels.npy')
    if os.path.exists(labels_path):
        labels = np.load(labels_path)
        print(f"labels.npy:       shape={labels.shape}, dtype={labels.dtype}")

    if os.path.exists(csv_path):
        with open(csv_path) as f:
            lines = f.readlines()
        print(f"training_data.csv: {len(lines) - 1} rows (+ header)")

    print()
    print(f"Output saved to: {args.output}")


if __name__ == '__main__':
    main()
