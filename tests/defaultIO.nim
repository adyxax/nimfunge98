discard """
  input: "ab1234cd12f"
  output: '''
[Suite] defaultIO
gh789
  '''
"""

import unittest

include ../src/defaultIO

suite "defaultIO":
  test "defaultCharacterInput":
    check defaultCharacterInput() == 'a'.int
    check defaultCharacterInput() == 'b'.int
    check defaultCharacterInput() == '1'.int
  test "defaultDecimalInput":
    check defaultDecimalInput() == 234
    check defaultCharacterInput() == 'c'.int
  test "defaultCharacterOutput":
    defaultCharacterOutput('g'.int)
    defaultCharacterOutput('h'.int)
  test "defaultDecimalOutput":
    defaultDecimalOutput(789)
