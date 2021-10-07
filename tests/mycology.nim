import ../src/field
import ../src/interpreter
import ../src/pointer

import unittest

suite "Mycology":
  const filename = "mycology/mycology.b98"
  var f = Load(filename)
  check f != nil
  let argv = @[filename]
  var p = NewPointer(argv = argv)
  let v = NewInterpreter(f, p)[].Run()
  check v == 15
