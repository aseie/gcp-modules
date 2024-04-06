#!/usr/bin/env python3

''' Combine file from:
  * script argument 1
  with content of file from:
  * script argument 2
  using the beginning of line separators
  hardcoded using regexes in this file:
  We exclude any text using the separate
  regex specified here
'''

import os
import re
import sys

insert_separator_regex = r'(.*?\[\^\]\:\ \(autogen_docs_start\))(.*?)(\n\[\^\]\:\ \(autogen_docs_end\).*?$)'  # noqa: E501

if len(sys.argv) != 3:
    sys.exit(1)

if not os.path.isfile(sys.argv[1]):
    sys.exit(0)

input = open(sys.argv[1], "r").read()
replace_content = open(sys.argv[2], "r").read()

# Find where to put the replacement content, overwrite the input file
match = re.match(insert_separator_regex, input, re.DOTALL)
if match is None:
    print("ERROR: Could not find autogen docs anchors in", sys.argv[1])
    print("To fix this, insert the following anchors in your README where "
          "module inputs and outputs should be documented.")
    print("[^]: (autogen_docs_start)")
    print("[^]: (autogen_docs_end)")
    sys.exit(0)
groups = match.groups(0)
output = groups[0] + "\n" + replace_content + groups[2] + "\n"
open(sys.argv[1], "w").write(output)