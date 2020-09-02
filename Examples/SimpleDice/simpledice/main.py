from argparse import ArgumentParser
import random


def roll_die(sides):
    return random.randint(1, sides)


def print_roll(sides):
    result = roll_die(sides)
    print(f"You rolled {result}.")


def parse_args():
    parser = ArgumentParser("Roll the dice.")

    parser.add_argument("-n", "--number-of-rolls", type=int, default=1)
    parser.add_argument("-s", "--sides", type=int, default=6)

    return parser.parse_args()


def main():
    args = parse_args()
    for i in range(args.number_of_rolls):
        print_roll(args.sides)

