import defaultIO
import field
import stackStack

import os
import random
import times

randomize()

type
  Pointer* = object
    x, y: int                          # The pointer's position
    dx, dy: int                        # The pointer's traveling delta
    sox, soy: int                      # The storage offset
    stringMode, lastCharWasSpace: bool # The string mode flags
    ss: ref StackStack
    next*: ref Pointer                 # the next element for multi-threaded funge-98
    characterInput*: proc(): int
    decimalInput*: proc(): int
    characterOutput*: proc(v: int)
    decimalOutput*: proc(v: int)
    argv: seq[string]

func NewPointer*(next: ref Pointer = nil, argv: seq[string]): ref Pointer =
  new(result)
  result.dx = 1
  result.ss = NewStackStack()
  result.next = next
  result.characterInput = defaultCharacterInput
  result.decimalInput = defaultDecimalInput
  result.characterOutput = defaultCharacterOutput
  result.decimalOutput = defaultDecimalOutput
  result.argv = argv

#func Split(p: var Pointer) =
#  # TODO check the spec, maybe we need to duplicate the stack?
#  p.next = NewPointer(p.next)

func Step(p: var Pointer, f: Field) =
  (p.x, p.y) = f.Step((p.x, p.y), (p.dx, p.dy))

func StepAndGet(p: var Pointer, f: Field): int =
  p.Step(f)
  return f.Get(p.x, p.y)

func Reverse(p: var Pointer) =
  p.dx = -p.dx; p.dy = -p.dy

proc Redirect(p: var Pointer, c: int): bool =
  ## Redirects the pointer according to c's value.
  ## Returns true if a redirect has been performed
  case c:
    of int('^'): p.dx = 0; p.dy = -1
    of int('>'): p.dx = 1; p.dy = 0
    of int('v'): p.dx = 0; p.dy = 1
    of int('<'): p.dx = -1; p.dy = 0
    of int('?'):
      const directions = [0, -1, 1, 0, 0, 1, -1, 0]
      let r = 2 * rand(3)
      p.dx = directions[r]; p.dy = directions[r+1]
    of int('['): (p.dx, p.dy) = (p.dy, -p.dx)
    of int(']'): (p.dx, p.dy) = (-p.dy, p.dx)
    of int('r'): p.Reverse()
    of int('x'): p.dy = p.ss[].Pop(); p.dx = p.ss[].Pop()
    else: return false
  return true

proc Eval(p: var Pointer, f: var Field, c: int): (bool, ref int) =
  ## Executes the instruction on the field
  ## Returns true if the pointer terminated, and a return code if
  ## the program should terminate completely
  case c:
    of int('@'): return (true, nil)
    of int('z'): discard
    of int('#'): p.Step(f)
    of int('j'):
      let n = p.ss[].Pop()
      if n > 0:
        for j in 0..<n:
          p.Step(f)
      else:
        p.Reverse()
        for j in 0 ..< -n:
          p.Step(f)
        p.Reverse()
    of int('q'):
      var i: ref int
      new(i); i[] = p.ss[].Pop()
      return (true, i)
    of int('k'):
      let x = p.x
      let y = p.y
      let n = p.ss[].Pop()
      var v = p.StepAndGet(f)
      var jumpingMode = false
      while jumpingMode or v == int(' ') or v == int(';'):
        if v == int(';'):
          jumpingMode = not jumpingMode
        v = p.StepAndGet(f)
      if n > 0:
        p.x = x; p.y = y
        if v != int(' ') and v != int(';'):
          if v == int('q') or v == int('@'):
            return p.Eval(f, v)
          for i in 0..<n:
            discard p.Eval(f, v)
    of int('!'):
      if p.ss[].Pop() == 0:
        p.ss[].Push(1)
      else:
        p.ss[].Push(0)
    of int('`'):
      let (a, b) = p.ss[].PopVector()
      if a > b:
        p.ss[].Push(1)
      else:
        p.ss[].Push(0)
    of int('_'):
      if p.ss[].Pop() == 0:
        p.dx = 1
      else:
        p.dx = -1
      p.dy = 0
    of int('|'):
      p.dx = 0
      if p.ss[].Pop() == 0:
        p.dy = 1
      else:
        p.dy = -1
    of int('w'):
      let (a, b) = p.ss[].PopVector()
      if a < b:
        (p.dx, p.dy) = (p.dy, -p.dx)
      elif a > b:
        (p.dx, p.dy) = (-p.dy, p.dx)
    of int('+'):
      let (a, b) = p.ss[].PopVector()
      p.ss[].Push(a+b)
    of int('*'):
      let (a, b) = p.ss[].PopVector()
      p.ss[].Push(a*b)
    of int('-'):
      let (a, b) = p.ss[].PopVector()
      p.ss[].Push(a-b)
    of int('/'):
      let (a, b) = p.ss[].PopVector()
      if b == 0:
        p.ss[].Push(0)
      else:
        p.ss[].Push(a div b)
    of int('%'):
      let (a, b) = p.ss[].PopVector()
      if b == 0:
        p.ss[].Push(0)
      else:
        p.ss[].Push(a mod b)
    of int('"'):
      p.stringMode = true
    of int('\''):
      p.ss[].Push(p.StepAndGet(f))
    of int('s'):
      p.Step(f)
      f.Set(p.x, p.y, p.ss[].Pop())
    of int('$'):
      discard p.ss[].Pop()
    of int(':'):
      p.ss[].Duplicate()
    of int('\\'):
      p.ss[].Swap()
    of int('n'):
      p.ss[].Clear()
    of int('{'):
      p.ss[].Begin((p.sox, p.soy))
      p.sox = p.x + p.dx
      p.soy = p.y + p.dy
    of int('}'):
      var v: tuple[x, y: int]
      if p.ss[].End(v):
        p.Reverse()
      p.sox = v.x; p.soy = v.y
    of int('u'):
      if p.ss[].Under():
        p.Reverse()
    of int('g'):
      let (x, y) = p.ss[].PopVector()
      p.ss[].Push(f.Get(x+p.sox, y+p.soy))
    of int('p'):
      let (x, y) = p.ss[].PopVector()
      let v = p.ss[].Pop()
      f.Set(x+p.sox, y+p.soy, v)
    of int('.'):
      p.decimalOutput(p.ss[].Pop())
    of int(','):
      p.characterOutput(p.ss[].Pop())
    of int('&'):
      p.ss[].Push(p.decimalInput())
    of int('~'):
      p.ss[].Push(p.characterInput())
    of int('y'):
      let n = p.ss[].Pop()
      let now = now()
      let (x, y, lx, ly) = f.GetSize()
      let heights = p.ss[].GetHeights()
      # 20
      for key, value in envPairs():
        case key
          of "LC_ALL": discard
          of "PWD": discard
          of "PATH": discard
          of "DISPLAY": discard
          of "USER": discard
          of "TERM": discard
          of "LANG": discard
          of "HOME": discard
          of "EDITOR": discard
          of "SHELL": discard
          else: continue
        p.ss[].Push(0)
        for i in countdown(value.len-1, 0):
          p.ss[].Push(int(value[i]))
        p.ss[].Push(int('='))
        for i in countdown(key.len-1, 0):
          p.ss[].Push(int(key[i]))
      # 19
      p.ss[].PushVector((0, 0))
      for i in 0..<p.argv.len:
        p.ss[].Push(0)
        for j in countdown(p.argv[i].len-1, 0):
          p.ss[].Push(int(p.argv[i][j]))
      # 18
      for i in 0..<heights.len:
        p.ss[].Push(heights[i])
      # 17
      p.ss[].Push(heights.len)
      # 16
      p.ss[].Push(now.hour * 256 * 256 + now.minute * 256 + now.second)
      # 15
      p.ss[].Push((now.year - 1900) * 256 * 256 + int(now.month) * 256 + int(now.monthday))
      # 14
      p.ss[].PushVector((lx-1, ly-1))
      # 13
      p.ss[].PushVector((x, y))
      # 12
      p.ss[].PushVector((p.sox, p.soy))
      # 11
      p.ss[].PushVector((p.dx, p.dy))
      # 10
      p.ss[].PushVector((p.x, p.y))
      # 9
      p.ss[].Push(0)
      # 8
      p.ss[].Push(cast[int](addr p))
      # 7
      p.ss[].Push(2)
      # 6
      p.ss[].Push(int('/'))
      # 5
      p.ss[].Push(0) # TODO update when implementing =
      # 4
      p.ss[].Push(1)
      # 3
      p.ss[].Push(1048577)
      # 2
      p.ss[].Push(sizeof(int))
      # 1
      p.ss[].Push(0b00000) # TODO update when implementing t, i, o and =
      if n > 0:
        p.ss[].YCommandPick(n, heights[0])
    of int('('):
      let n = p.ss[].Pop()
      var v = 0
      for i in 0..<n:
        v = v*256+p.ss[].Pop()
      p.Reverse() # No fingerprints supported yet
    of int(')'):
      let n = p.ss[].Pop()
      var v = 0
      for i in 0..<n:
        v = v*256+p.ss[].Pop()
      p.Reverse() # No fingerprints supported yet
    of int('i'):
      quit("not implemented yet", 1)
    of int('o'):
      quit("not implemented yet", 1)
    of int('='):
      quit("not implemented yet", 1)
    of int('t'):
      quit("not implemented yet", 1)
    else:
      if not p.Redirect(c):
        if c >= int('0') and c <= int('9'):
          p.ss[].Push(c - int('0'))
        elif c >= int('a') and c <= int('f'):
          p.ss[].Push(c - int('a') + 10)
        else:
          p.Reverse()
  return (false, nil)

proc Exec*(p: var Pointer, f: var Field): (bool, ref int) =
  ## Advances to the next instruction of the field and executes it
  ## Returns true if the pointer terminated, and a return code if
  ## the program should terminate completely
  var c = f.Get(p.x, p.y)
  if p.stringMode:
    if p.lastCharWasSpace:
      while c == int(' '):
        c = p.StepAndGet(f)
      p.lastCharWasSpace = false
    if c == int('"'):
      p.stringMode = false
    else:
      if c == int(' '):
        p.lastCharWasSpace = true
      p.ss[].Push(c)
  else:
    var jumpingMode = false
    while jumpingMode or c == int(' ') or c == int(';'):
      if c == int(';'):
        jumpingMode = not jumpingMode
      c = p.StepAndGet(f)
    result = p.Eval(f, c)
  p.Step(f)
  return result
