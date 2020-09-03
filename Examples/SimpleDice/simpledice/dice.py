import random


def roll_die(sides):
    return random.randint(1, sides)


def print_roll(sides):
    result = roll_die(sides)
    print(f"You rolled {result}.")

