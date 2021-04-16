"""
Generate Data

Script allows the user to generate fake data that could be used
for populating Athena tables (JSON files living inside S3 bucket).
"""

import argparse
from typing import NoReturn


def main(n: int) -> NoReturn:
    pass


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Generate fake data for Athena.")
    parser.add_argument("n", type=int, help="Amount of rows that will be generated.")

    args = parser.parse_args()
    main(n=args.n)
