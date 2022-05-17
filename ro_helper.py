#!/usr/bin/env python3

#
# this script is used to help on various file changes needed to make things
# work in a readonly system.
#
# runs in stock python and not a venv
#
# usage:
#
#  python3 ./ro_helper.py fix-fstab --file /etc/fstab
#  python3 ./ro_helper.py fix-cmdline --file /boot/cmdline.txt
#  python3 ./ro_helper.py fix-random-seed --file /lib/systemd/system/systemd-random-seed.service
#
#  other options are
#   --verbose
#   --replace
#   --output file (default output.txt)

import argparse
import re


def fix_cmdline(args):
    if args.file == "":
        args.file = "/boot/cmdline.txt"

    with open(args.file, "r") as f:
        lines = f.read()

    if re.search("fastboot noswap ro", lines) is not None:
        print(f"command line already set for readonly")
        return

    rc = re.sub("rootwait", "rootwait fastboot noswap ro", lines)

    if args.verbose:
        print(f"result is '{rc}'")

    if args.replace:
        args.output = args.file

    with open(args.output, "w") as f:
        f.write(rc)


def fix_fstab(args):
    if args.file == "":
        args.file = "/etc/fstab"

    with open(args.file, "r") as f:
        lines = f.readlines()

    for line in lines:
        if re.search("defaults,ro", line) is not None or \
           re.search("defaults,noatime,ro", line) is not None:
            print(f"fstab already set for readonly")
            return

    rc = list()
    for line in lines:
        newline = line
        if re.search("vfat", line):
            newline = re.sub("defaults", "defaults,ro", line)
            pass
        elif re.search("ext4", line):
            newline = re.sub("defaults[,]noatime", "defaults,noatime,ro", line)

        rc.append(newline)

    rc = ''.join(rc)

    if args.verbose:
        print(f"result is '{rc}'")

    if args.replace:
        args.output = args.file

    with open(args.output, "w") as f:
        f.write(rc)


def fix_random_seed(args):
    if args.file == "":
        args.file = "/lib/systemd/system/systemd-random-seed.service"

    with open(args.file, "r") as f:
        lines = f.read()

    if re.search('ExecStartPre=/bin/echo '' >/tmp/random-seed', lines) is not None:
        print(f"systemd-random-seed.service already set for readonly")
        return

    rc = re.sub(
        "ExecStart=/lib/systemd/systemd-random-seed load",
        "ExecStartPre=/bin/echo '' >/tmp/random-seed\nExecStart=/lib/systemd/systemd-random-seed load",
        lines
    )

    if args.verbose:
        print(f"result is '{rc}'")

    if args.replace:
        args.output = args.file

    with open(args.output, "w") as f:
        f.write(rc)


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("command", type=str, nargs=1)
    ap.add_argument("--file", type=str, required=False, default="")
    ap.add_argument("--output", type=str, required=False, default="output.txt")
    ap.add_argument("--verbose", action="store_true", default=False)
    ap.add_argument("--replace", action="store_true", default=False)

    args = ap.parse_args()
    cmd = args.command[0]

    if args.verbose:
        print(f"cmd is {cmd}")

    if cmd not in ["fix-fstab", "fix-cmdline", "fix-random-seed"]:
        print(f"Error, invalid command {cmd}")
        exit(1)

    if cmd == "fix-cmdline":
        fix_cmdline(args)
    elif cmd == "fix-fstab":
        fix_fstab(args)
    elif cmd == "fix-random-seed":
        fix_random_seed(args)


if __name__ == "__main__":
    main()


