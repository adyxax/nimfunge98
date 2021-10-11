import unittest

include ../src/field

func `==`(a, b: Field): bool =
  if a.x == b.x and a.lx == b.lx and a.y == b.y and a.ly == b.ly:
    for i in 0..<a.ly:
      if a.lines[i] == nil and b.lines[i] == nil:
        continue
      if a.lines[i] == nil xor b.lines[i] == nil:
        return false
      if a.lines[i].x != b.lines[i].x or a.lines[i].columns != b.lines[i].columns:
        return false
    return true
  return false

func cols(a: openarray[char]): seq[int] =
  result.setlen(a.len)
  for i in 0..<a.len:
    result[i] = a[i].int()

let minimal = Field(x: 0, y: 0, lx: 1, ly: 1, lines: @[Line(x: 0, columns: @[int('@')])])

suite "Field":
  test "Blank":
    var f = Field(x: -7, y: -5, lx: 17, ly: 10, lines: @[
      Line(x: -5, columns: @[int('x')]),
      nil,
      Line(x: 8, columns: @[int('u')]),
      Line(x: 9, columns: @[int('e')]),
      nil,
      Line(x: -2, columns: @[int('l'), 32, int('@'), int('z'), 32, 32, int('r')]),
      Line(x: -3, columns: @[int('f')]),
      Line(x: 5, columns: @[int('d')]),
      nil,
      Line(x: -7, columns: @[int('y')]),
    ])
    let moinsz = Field(x: -7, y: -5, lx: 17, ly: 10, lines: @[
      Line(x: -5, columns: @[int('x')]),
      nil,
      Line(x: 8, columns: @[int('u')]),
      Line(x: 9, columns: @[int('e')]),
      nil,
      Line(x: -2, columns: @[int('l'), 32, int('@'), 32, 32, 32, int('r')]),
      Line(x: -3, columns: @[int('f')]),
      Line(x: 5, columns: @[int('d')]),
      nil,
      Line(x: -7, columns: @[int('y')]),
    ])
    f.Blank(1, 0)
    check f == moinsz
    let moinsy = Field(x: -5, y: -5, lx: 15, ly: 8, lines: @[
      Line(x: -5, columns: @[int('x')]),
      nil,
      Line(x: 8, columns: @[int('u')]),
      Line(x: 9, columns: @[int('e')]),
      nil,
      Line(x: -2, columns: @[int('l'), 32, int('@'), 32, 32, 32, int('r')]),
      Line(x: -3, columns: @[int('f')]),
      Line(x: 5, columns: @[int('d')]),
    ])
    f.Blank(-7, 4)
    check f == moinsy
    let moinsx = Field(x: -3, y: -3, lx: 13, ly: 6, lines: @[
      Line(x: 8, columns: @[int('u')]),
      Line(x: 9, columns: @[int('e')]),
      nil,
      Line(x: -2, columns: @[int('l'), 32, int('@'), 32, 32, 32, int('r')]),
      Line(x: -3, columns: @[int('f')]),
      Line(x: 5, columns: @[int('d')]),
    ])
    f.Blank(-5, -5)
    check f == moinsx
    let moinsf = Field(x: -2, y: -3, lx: 12, ly: 6, lines: @[
      Line(x: 8, columns: @[int('u')]),
      Line(x: 9, columns: @[int('e')]),
      nil,
      Line(x: -2, columns: @[int('l'), 32, int('@'), 32, 32, 32, int('r')]),
      Line(x: -3, columns: @[]),
      Line(x: 5, columns: @[int('d')]),
    ])
    f.Blank(-3, 1)
    check f == moinsf
    let moinse = Field(x: -2, y: -3, lx: 11, ly: 6, lines: @[
      Line(x: 8, columns: @[int('u')]),
      Line(x: 9, columns: @[]),
      nil,
      Line(x: -2, columns: @[int('l'), 32, int('@'), 32, 32, 32, int('r')]),
      Line(x: -3, columns: @[]),
      Line(x: 5, columns: @[int('d')]),
    ])
    f.Blank(9, -2)
    check f == moinse
    let moinsu = Field(x: -2, y: 0, lx: 8, ly: 3, lines: @[
      Line(x: -2, columns: @[int('l'), 32, int('@'), 32, 32, 32, int('r')]),
      Line(x: -3, columns: @[]),
      Line(x: 5, columns: @[int('d')]),
    ])
    f.Blank(8, -3)
    check f == moinsu
    let moinsd = Field(x: -2, y: 0, lx: 7, ly: 1, lines: @[Line(x: -2, columns: @[int('l'), 32, int('@'), 32, 32, 32, int('r')])])
    f.Blank(5, 2)
    check f == moinsd
    let moinsl = Field(x: 0, y: 0, lx: 5, ly: 1, lines: @[Line(x: 0, columns: @[int('@'), 32, 32, 32, int('r')])])
    f.Blank(-2, 0)
    check f == moinsl
    let moinsr = Field(x: 0, y: 0, lx: 1, ly: 1, lines: @[Line(x: 0, columns: @[int('@')])])
    f.Blank(4, 0)
    check f == moinsr
  test "Get":
    check minimal.Get(0, 0) == int('@')
    check minimal.Get(1, 0) == int(' ')
  test "IsIn":
    check minimal.IsIn(0, 0) == true
    check minimal.IsIn(1, 0) == false
  test "Load":
    check Load("nonexistant") == nil
    check Load("examples/invalid.b98") == nil
    check Load("examples/empty.b98") == nil
    check Load("examples/minimal.b98")[] == Field(lx: 1, ly: 1, lines: @[Line(columns: @['@'].cols)])
    let hello = Field(lx: 24, ly: 1, lines: @[Line(columns: @['6', '4', '+', '"', '!', 'd', 'l', 'r', 'o', 'W', ' ', ',', 'o', 'l', 'l', 'e', 'H', '"', '>', ':', '#', ',', '_', '@'].cols)])
    check Load("examples/hello.b98")[] == hello
    check Load("examples/rn.b98")[] == hello
    check Load("examples/hello2.b98")[] == Field(x: 1, lx: 33, ly: 2, lines: @[
      Line(x: 33, columns: @['v'].cols),
      Line(x: 1, columns: @['@', ' ', '>', ' ', '#', ';', '>', ':', '#', ',', '_', 'e', '-', 'j', ';', ' ', '"', 'H', 'e', 'l', 'l', 'o', ' ', 'w', 'o', 'r', 'l', 'd', '!',
          '"', 'd', 'a', '<'].cols)
    ])
    check Load("examples/factorial.b98")[] == Field(x: 0, lx: 15, ly: 2, lines: @[
      Line(x: 0, columns: @['&', '>', ':', '1', '-', ':', 'v', ' ', 'v', ' ', '*', '_', '$', '.', '@'].cols),
      Line(x: 1, columns: @['^', ' ', ' ', ' ', ' ', '_', '$', '>', '\\', ':', '^'].cols)
    ])
    check Load("examples/dna.b98")[] == Field(x: 0, lx: 7, ly: 8, lines: @[
      Line(x: 0, columns: @['7', '^', 'D', 'N', '>', 'v', 'A'].cols),
      Line(x: 0, columns: @['v', '_', '#', 'v', '?', ' ', 'v'].cols),
      Line(x: 0, columns: @['7', '^', '<', '"', '"', '"', '"'].cols),
      Line(x: 0, columns: @['3', ' ', ' ', 'A', 'C', 'G', 'T'].cols),
      Line(x: 0, columns: @['9', '0', '!', '"', '"', '"', '"'].cols),
      Line(x: 0, columns: @['4', '*', ':', '>', '>', '>', 'v'].cols),
      Line(x: 0, columns: @['+', '8', '^', '-', '1', ',', '<'].cols),
      Line(x: 0, columns: @['>', ' ', ',', '+', ',', '@', ')'].cols),
    ])
  test "Set":
    var f = Field(x: 0, y: 0, lx: 1, ly: 1, lines: @[Line(x: 0, columns: @['>'].cols)])
    f.Set(0, 0, int('@'))
    check f == minimal
    f.Set(1, 0, int(' '))
    check f == minimal
    let xappend = Field(x: 0, y: 0, lx: 5, ly: 1, lines: @[Line(x: 0, columns: @[int('@'), 32, 32, 32, int('r')])])
    f.Set(4, 0, int('r'))
    check f == xappend
    let xprepend = Field(x: -2, y: 0, lx: 7, ly: 1, lines: @[Line(x: -2, columns: @[int('l'), 32, int('@'), 32, 32, 32, int('r')])])
    f.Set(-2, 0, int('l'))
    check f == xprepend
    let yappend = Field(x: -2, y: 0, lx: 8, ly: 3, lines: @[
      Line(x: -2, columns: @[int('l'), 32, int('@'), 32, 32, 32, int('r')]),
      nil,
      Line(x: 5, columns: @[int('d')]),
    ])
    f.Set(5, 2, int('d'))
    check f == yappend
    let yprepend = Field(x: -2, y: -3, lx: 11, ly: 6, lines: @[
      Line(x: 8, columns: @[int('u')]),
      nil,
      nil,
      Line(x: -2, columns: @[int('l'), 32, int('@'), 32, 32, 32, int('r')]),
      nil,
      Line(x: 5, columns: @[int('d')]),
    ])
    f.Set(8, -3, int('u'))
    check f == yprepend
    let xappendEmptyline = Field(x: -2, y: -3, lx: 12, ly: 6, lines: @[
      Line(x: 8, columns: @[int('u')]),
      Line(x: 9, columns: @[int('e')]),
      nil,
      Line(x: -2, columns: @[int('l'), 32, int('@'), 32, 32, 32, int('r')]),
      nil,
      Line(x: 5, columns: @[int('d')]),
    ])
    f.Set(9, -2, int('e'))
    check f == xappendEmptyline
    let xprependEmptyline = Field(x: -3, y: -3, lx: 13, ly: 6, lines: @[
      Line(x: 8, columns: @[int('u')]),
      Line(x: 9, columns: @[int('e')]),
      nil,
      Line(x: -2, columns: @[int('l'), 32, int('@'), 32, 32, 32, int('r')]),
      Line(x: -3, columns: @[int('f')]),
      Line(x: 5, columns: @[int('d')]),
    ])
    f.Set(-3, 1, int('f'))
    check f == xprependEmptyline
    let xprependyprepend = Field(x: -5, y: -5, lx: 15, ly: 8, lines: @[
      Line(x: -5, columns: @[int('x')]),
      nil,
      Line(x: 8, columns: @[int('u')]),
      Line(x: 9, columns: @[int('e')]),
      nil,
      Line(x: -2, columns: @[int('l'), 32, int('@'), 32, 32, 32, int('r')]),
      Line(x: -3, columns: @[int('f')]),
      Line(x: 5, columns: @[int('d')]),
    ])
    f.Set(-5, -5, int('x'))
    check f == xprependyprepend
    let xprependyappend = Field(x: -7, y: -5, lx: 17, ly: 10, lines: @[
      Line(x: -5, columns: @[int('x')]),
      nil,
      Line(x: 8, columns: @[int('u')]),
      Line(x: 9, columns: @[int('e')]),
      nil,
      Line(x: -2, columns: @[int('l'), 32, int('@'), 32, 32, 32, int('r')]),
      Line(x: -3, columns: @[int('f')]),
      Line(x: 5, columns: @[int('d')]),
      nil,
      Line(x: -7, columns: @[int('y')]),
    ])
    f.Set(-7, 4, int('y'))
    check f == xprependyappend
  test "Step":
    var minimal = Load("examples/minimal.b98")
    var hello = Load("examples/hello.b98")
    var dna = Load("examples/dna.b98")
    check minimal[].Step((0, 0), (0, 0)) == (0, 0)
    check minimal[].Step((0, 0), (1, 0)) == (0, 0)
    check hello[].Step((3, 0), (0, 0)) == (3, 0)
    check hello[].Step((3, 0), (1, 0)) == (4, 0)
    check dna[].Step((1, 2), (3, 5)) == (4, 7)
    check dna[].Step((6, 1), (1, 1)) == (5, 0)
    check dna[].Step((1, 4), (-2, 2)) == (5, 0)
  test "GetSize":
    var minimal = Load("examples/minimal.b98")
    var hello = Load("examples/hello.b98")
    var hello2 = Load("examples/hello2.b98")
    var dna = Load("examples/dna.b98")
    check minimal[].GetSize() == (0, 0, 1, 1)
    check hello[].GetSize() == (0, 0, 24, 1)
    check hello2[].GetSize() == (1, 0, 33, 2)
    check dna[].GetSize() == (0, 0, 7, 8)
