#! /usr/bin/env python2
SOURCE_DIR = "$HOME/git/scale-product/"

# import glob
# import os.path

# for filename in glob.iglob(os.path.join(SOURCE_DIR, '/**/*.c'), recursive=True):
#     print(filename)

import sys
import os.path

# sys.stdout = os.fdopen(sys.stdout.fileno(), 'w', 0)
sys.stdin = os.fdopen(sys.stdin.fileno(), 'r', 200)

translation_map = {}

for fname in sys.argv:
    basename = os.path.basename(fname)
    translation_map[basename] = fname

for line in sys.stdin:
    for key in translation_map.keys():
        if key in line:
            line = line.replace(key, translation_map[key])
    print line,
    sys.stdout.flush()
