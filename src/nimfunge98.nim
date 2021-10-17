import field
import interpreter
import pointer

import os
import parseopt
import strformat

proc Usage(i: int = 0) =
  let filename = getAppFilename().extractFilename()
  echo fmt"""Usage: {filename} [FLAGS] filename

FLAGS:
  -h         display this help message"""
  if i != 0:
    quit i

var filename: string

for kind, key, value in getOpt():
  case kind
    of cmdArgument:
      if filename != "":
        echo "Invalid argument: ", key
        Usage(1)
      filename = key
    of cmdLongOption, cmdShortOption:
      case key
        of "h":
          Usage()
          quit 0
        else:
          echo "Unknown option: ", key
          Usage(1)
    of cmdEnd:
      discard

var f = Load(filename)
if f == nil:
  echo "Failed to load ", filename
  quit 1
let argv = @[filename]
var p = NewPointer(argv = argv)
let v = NewInterpreter(f, p)[].Run()
quit v
