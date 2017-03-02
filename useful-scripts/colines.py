#!/usr/bin/env python
# -*- coding: utf-8 -*-
# @Function
# cat lines colorfully. colines means COLorful LINES.
#
# @Usage
#   $ echo -n 'Hello\nWorld' | colines
#   $ colines /path/to/file1
#   $ colines /path/to/file1 /path/to/file2


__author__ = 'Strong It'

import sys

ECHO_COLORS = (37, 31, 32, 34, 33, 35, 56)
idx = 0


def color_print(*args):
    line = " ".join(args)
    global idx
    idx += 1
    color = ECHO_COLORS[idx % len(ECHO_COLORS)]
    if sys.stdout.isatty():
        line_ = """\033[1;%sm%s\033[0m""" % (color, line)
        print line_
    else:
        print(line)


if __name__ == '__main__':
    if len(sys.argv) > 1:
        for arg in sys.argv[1:]:
            if len(sys.argv) > 2:
                print('=' * 80)
                print(arg)
                print('=' * 80)
            for line in open(arg).readlines():
                color_print(line.rstrip('\r\n'))
    else:
        # Read from std input
        while True:
            line = sys.stdin.readline()
            if not line:
                break
            color_print(line.rstrip('\r\n'))
