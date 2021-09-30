type
  Line = ref object
    x, l: int
    columns: seq[int]

  Field* = ref object
    x, y: int
    lx, ly: int
    lines: seq[Line]

proc get*(f: Field, x, y: int): int =
  if y >= f.y and y < f.y + f.ly:
    let l = f.lines[y-f.y]
    if x >= l.x and x < l.x + l.l:
      return l.columns[x-l.x]
  return int(' ')

proc isIn*(f: Field, x, y: int): bool =
  return x >= f.x and y >= f.y and x < f.x+f.lx and y < f.y+f.ly

when defined(unitTesting):
  let minimal = Field(
    x: 0,
    y: 0,
    lx: 1,
    ly: 1,
    lines: @[
      Line(x: 0, l: 1, columns: @[int('@')])
    ]
  )
  suite "Field":
    test "Field.get":
      check minimal.get(0,0) == int('@')
      check minimal.get(1,0) == int(' ')
    test "Field.isIn":
      check minimal.isIn(0, 0) == true
      check minimal.isIn(1, 0) == false
