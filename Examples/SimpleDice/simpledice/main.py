from argparse import ArgumentParser
from .dice import print_roll, roll_die


def parse_args():
    parser = ArgumentParser("Roll the dice.")

    parser.add_argument(
        "--number-of-rolls",
        "-r",
        type=int,
        default=1,
        metavar="N",
        help="the number of rolls",
    )
    parser.add_argument(
        "--number-of-sides", "-n", type=int, default=6, help="the number of sides",
    )
    parser.add_argument(
        "--summary",
        "-s",
        # type=bool,
        action="store_true",
        help="print summary instead of individual rolls",
    )

    return parser.parse_args()


def print_summary_result(index, results):
    print(f"{index + 1} was rolled {results[index]} times.")


def main():
    args = parse_args()
    if args.summary or args.number_of_rolls > 100:
        results = [0] * args.number_of_sides
        for i in range(args.number_of_rolls):
            results[roll_die(args.number_of_sides) - 1] += 1
        for i in range(args.number_of_sides):
            print_summary_result(i, results)
    else:
        for i in range(args.number_of_rolls):
            print_roll(args.number_of_sides)

