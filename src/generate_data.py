"""
Generate Data

Script allows the user to generate fake data that could be used
for populating Athena tables (JSON files living inside S3 bucket).
"""

import argparse
import datetime
import itertools
import json
import pathlib
import random
from typing import Dict, NoReturn

import faker

id_sequence = itertools.count(0)
prod_choices = "ABC"


def _generate_row_dict() -> Dict:
    """
    Generate a JSON row with random data.
    JSON schema:
    - id (int)
    - date (date in str format YYYY-MM-DD)
    - product (string)
    :return: str
    """
    return {
        "id": next(id_sequence),
        "date": faker.Faker()
        .date_between_dates(
            datetime.date(2020, 1, 1),
            datetime.date(2020, 12, 31),
        )
        .strftime("%Y-%m-%d"),
        "product": random.choice(prod_choices),
    }


def main(n: int, p: pathlib.Path) -> NoReturn:
    for _ in range(n):
        row = _generate_row_dict()
        row_path = p / f"{row['id']}.json"
        with open(row_path, "wt") as f:
            json.dump(row, f)


if __name__ == "__main__":
    data_path = pathlib.Path("../data")

    if not data_path.exists():
        data_path.mkdir()

    parser = argparse.ArgumentParser(description="Generate fake data for Athena.")
    parser.add_argument("n", type=int, help="Amount of rows that will be generated.")

    args = parser.parse_args()
    main(n=args.n, p=data_path)
