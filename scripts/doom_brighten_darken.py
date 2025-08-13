#!/usr/bin/env python3

import argparse
import logging
from pathlib import Path

logger = logging.getLogger(__name__)


def run(args):
    op = args.op
    amount = args.amount or 0
    r_amount = args.r or 0
    g_amount = args.g or 0
    b_amount = args.b or 0

    if (r_amount or g_amount or b_amount) and amount:
        logger.error("error: cannot set individual colors and total amount simultaneously. exiting...")
        exit(1)

    if not (r_amount or g_amount or b_amount or amount):
        logger.error("error: no amounts chosen. exiting...")
        exit(1)

    if not args.doom_theme and args.theme:
        logger.error("error: theme specified without doom-theme. exiting...")
        exit(1)

    if args.doom_theme and not args.theme:
        logger.error("error: doom-theme specified without theme. exiting...")
        exit(1)

    if args.doom_theme:
        doom_theme_file = Path(Path.home() / "dotfiles" / ".doom.d" / "themes" / f"{args.theme}-theme.el")

        with doom_theme_file.open("r") as f:
            data = f.readlines()

        doom_theme_lines = []
        zero_padding = "0"

        for idx, line in enumerate(data):
            if '("#' in line:
                default_hash_idx = line.index('("#')
                secondary_hash_idx = line.index(' "#')

                default_hex_color = line[default_hash_idx + 3 : default_hash_idx + 9]
                secondary_hex_color = line[secondary_hash_idx + 3 : secondary_hash_idx + 9]

                default_r = default_hex_color[:2]
                default_g = default_hex_color[2:4]
                default_b = default_hex_color[4:6]
                secondary_r = secondary_hex_color[:2]
                secondary_g = secondary_hex_color[2:4]
                secondary_b = secondary_hex_color[4:6]

                if op == "+":
                    int_new_default_r = int(default_r, 16) + int(r_amount or amount)
                    int_new_default_g = int(default_g, 16) + int(g_amount or amount)
                    int_new_default_b = int(default_b, 16) + int(b_amount or amount)
                    int_new_secondary_r = int(secondary_r, 16) + int(r_amount or amount)
                    int_new_secondary_g = int(secondary_g, 16) + int(g_amount or amount)
                    int_new_secondary_b = int(secondary_b, 16) + int(b_amount or amount)

                elif op == "-":
                    int_new_default_r = int(default_r, 16) - int(r_amount or amount)
                    int_new_default_g = int(default_g, 16) - int(g_amount or amount)
                    int_new_default_b = int(default_b, 16) - int(b_amount or amount)
                    int_new_secondary_r = int(secondary_r, 16) - int(r_amount or amount)
                    int_new_secondary_g = int(secondary_g, 16) - int(g_amount or amount)
                    int_new_secondary_b = int(secondary_b, 16) - int(b_amount or amount)

                if int_new_default_r < 16:
                    new_default_r = zero_padding + hex(int_new_default_r)[2:]
                else:
                    new_default_r = hex(int_new_default_r)[2:]

                if int_new_default_g < 16:
                    new_default_g = zero_padding + hex(int_new_default_g)[2:]
                else:
                    new_default_g = hex(int_new_default_g)[2:]

                if int_new_default_b < 16:
                    new_default_b = zero_padding + hex(int_new_default_b)[2:]
                else:
                    new_default_b = hex(int_new_default_b)[2:]

                if int_new_secondary_r < 16:
                    new_secondary_r = zero_padding + hex(int_new_secondary_r)[2:]
                else:
                    new_secondary_r = hex(int_new_secondary_r)[2:]

                if int_new_secondary_g < 16:
                    new_secondary_g = zero_padding + hex(int_new_secondary_g)[2:]
                else:
                    new_secondary_g = hex(int_new_secondary_g)[2:]

                if int_new_secondary_b < 16:
                    new_secondary_b = zero_padding + hex(int_new_secondary_b)[2:]
                else:
                    new_secondary_b = hex(int_new_secondary_b)[2:]

                new_default_hex_color = f"{new_default_r}{new_default_g}{new_default_b}"
                new_secondary_hex_color = f"{new_secondary_r}{new_secondary_g}{new_secondary_b}"

                doom_theme_lines.append(
                    [
                        idx,
                        default_hex_color,
                        new_default_hex_color,
                        secondary_hex_color,
                        new_secondary_hex_color,
                    ]
                )

        for line in doom_theme_lines:
            data[line[0]] = data[line[0]].replace(line[1], line[2])
            data[line[0]] = data[line[0]].replace(line[3], line[4])

        with doom_theme_file.open("w") as f:
            for line in data:
                f.write(line)

    if args.alacritty:
        alacritty_file = Path(Path.home() / "dotfiles" / f"alacritty-{args.theme}.toml")

        with alacritty_file.open() as f:
            alacritty_data = f.readlines()

        alacritty_lines = []
        zero_padding = "0"

        for idx, line in enumerate(alacritty_data):
            if ' "#' in line:
                hash_idx = line.index(' "#')
                hex_color = line[hash_idx + 3 : hash_idx + 9]

                r = hex_color[:2]
                g = hex_color[2:4]
                b = hex_color[4:6]

                if op == "+":
                    int_new_r = int(r, 16) + int(r_amount or amount)
                    int_new_g = int(g, 16) + int(g_amount or amount)
                    int_new_b = int(b, 16) + int(b_amount or amount)

                elif op == "-":
                    int_new_r = int(r, 16) - int(r_amount or amount)
                    int_new_g = int(g, 16) - int(g_amount or amount)
                    int_new_b = int(b, 16) - int(b_amount or amount)

                if int_new_r < 16:
                    new_r = zero_padding + hex(int_new_r)[2:]
                else:
                    new_r = hex(int_new_r)[2:]

                if int_new_g < 16:
                    new_g = zero_padding + hex(int_new_g)[2:]
                else:
                    new_g = hex(int_new_g)[2:]

                if int_new_b < 16:
                    new_b = zero_padding + hex(int_new_b)[2:]
                else:
                    new_b = hex(int_new_b)[2:]

                new_hex_color = f"{new_r}{new_g}{new_b}"

                alacritty_lines.append(
                    [
                        idx,
                        hex_color,
                        new_hex_color,
                    ]
                )

        for line in alacritty_lines:
            alacritty_data[line[0]] = alacritty_data[line[0]].replace(line[1], line[2])

        with alacritty_file.open("w") as f:
            for line in alacritty_data:
                f.write(line)

    if args.k9s:
        k9s_skin_file = Path(Path.home() / "devtools" / "kubernetes-devtools" / "k9s" / "skins" / f"{args.theme}.yaml")

        with k9s_skin_file.open() as f:
            k9s_skin_data = f.readlines()

        k9s_lines = []
        zero_padding = "0"

        for idx, line in enumerate(k9s_skin_data):
            if ' "#' in line:
                hash_idx = line.index(' "#')
                hex_color = line[hash_idx + 3 : hash_idx + 9]

                r = hex_color[:2]
                g = hex_color[2:4]
                b = hex_color[4:6]

                if op == "+":
                    int_new_r = int(r, 16) + int(r_amount or amount)
                    int_new_g = int(g, 16) + int(g_amount or amount)
                    int_new_b = int(b, 16) + int(b_amount or amount)

                elif op == "-":
                    int_new_r = int(r, 16) - int(r_amount or amount)
                    int_new_g = int(g, 16) - int(g_amount or amount)
                    int_new_b = int(b, 16) - int(b_amount or amount)

                if int_new_r < 16:
                    new_r = zero_padding + hex(int_new_r)[2:]
                else:
                    new_r = hex(int_new_r)[2:]

                if int_new_g < 16:
                    new_g = zero_padding + hex(int_new_g)[2:]
                else:
                    new_g = hex(int_new_g)[2:]

                if int_new_b < 16:
                    new_b = zero_padding + hex(int_new_b)[2:]
                else:
                    new_b = hex(int_new_b)[2:]

                new_hex_color = f"{new_r}{new_g}{new_b}"

                k9s_lines.append(
                    [
                        idx,
                        hex_color,
                        new_hex_color,
                    ]
                )

        for line in k9s_lines:
            k9s_skin_data[line[0]] = k9s_skin_data[line[0]].replace(line[1], line[2])

        with k9s_skin_file.open("w") as f:
            for line in k9s_skin_data:
                f.write(line)


def main():
    logging.basicConfig(level=logging.INFO)

    parser = argparse.ArgumentParser(prog="doombd", description="brighten or darken doom themes")

    parser.add_argument("-o", "--op", help="the operation to use, e.g., + or -")
    parser.add_argument("--amount", help="the amount to increase or decrease for all colors")
    parser.add_argument("-r", help="the amount to increase or decrease for red")
    parser.add_argument("-g", help="the amount to increase or decrease for green")
    parser.add_argument("-b", help="the amount to increase or decrease for blue")
    parser.add_argument("--doom-theme", action="store_true", help="set to enable changing colors for selected doom theme")
    parser.add_argument("--theme", help="set to enable changing colors for selected theme")
    parser.add_argument("--alacritty", action="store_true", help="set to enable changing colors for alacritty")
    parser.add_argument("--k9s", action="store_true", help="set to enable changing colors for k9s skin")

    args = parser.parse_args()

    run(args)


if __name__ == "__main__":
    main()
