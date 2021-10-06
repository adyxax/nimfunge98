import unittest

include ../src/field

func `==`(a, b: Line): bool = a.x == b.x and a.l == b.l and a.columns == b.columns
func `==`(a, b: Field): bool = a.x == b.x and a.lx == b.lx and a.y == b.y and a.ly == b.ly and a.lines == b.lines
func cols(a: openarray[char]): seq[int] =
  result.setlen(a.len)
  for i in 0..<a.len:
    result[i] = a[i].int()

const minimal = Field(x: 0, y: 0, lx: 1, ly: 1, lines: @[Line(x: 0, l: 1, columns: @[int('@')])])

suite "Field":
  test "Blank":
    var f = Field(x: -7, y: -5, lx: 17, ly: 10, lines: @[
      Line(x: -5, l: 1, columns: @[int('x')]),
      Line(x: 0, l: 0, columns: @[]),
      Line(x: 8, l: 1, columns: @[int('u')]),
      Line(x: 9, l: 1, columns: @[int('e')]),
      Line(x: 0, l: 0, columns: @[]),
      Line(x: -2, l: 7, columns: @[int('l'), 32, int('@'), int('z'), 32, 32, int('r')]),
      Line(x: -3, l: 1, columns: @[int('f')]),
      Line(x: 5, l: 1, columns: @[int('d')]),
      Line(x: 0, l: 0, columns: @[]),
      Line(x: -7, l: 1, columns: @[int('y')]),
    ])
    const moinsz = Field(x: -7, y: -5, lx: 17, ly: 10, lines: @[
      Line(x: -5, l: 1, columns: @[int('x')]),
      Line(x: 0, l: 0, columns: @[]),
      Line(x: 8, l: 1, columns: @[int('u')]),
      Line(x: 9, l: 1, columns: @[int('e')]),
      Line(x: 0, l: 0, columns: @[]),
      Line(x: -2, l: 7, columns: @[int('l'), 32, int('@'), 32, 32, 32, int('r')]),
      Line(x: -3, l: 1, columns: @[int('f')]),
      Line(x: 5, l: 1, columns: @[int('d')]),
      Line(x: 0, l: 0, columns: @[]),
      Line(x: -7, l: 1, columns: @[int('y')]),
    ])
    f.Blank(1, 0)
    check f == moinsz
    const moinsy = Field(x: -5, y: -5, lx: 15, ly: 8, lines: @[
      Line(x: -5, l: 1, columns: @[int('x')]),
      Line(x: 0, l: 0, columns: @[]),
      Line(x: 8, l: 1, columns: @[int('u')]),
      Line(x: 9, l: 1, columns: @[int('e')]),
      Line(x: 0, l: 0, columns: @[]),
      Line(x: -2, l: 7, columns: @[int('l'), 32, int('@'), 32, 32, 32, int('r')]),
      Line(x: -3, l: 1, columns: @[int('f')]),
      Line(x: 5, l: 1, columns: @[int('d')]),
    ])
    f.Blank(-7, 4)
    check f == moinsy
    const moinsx = Field(x: -3, y: -3, lx: 13, ly: 6, lines: @[
      Line(x: 8, l: 1, columns: @[int('u')]),
      Line(x: 9, l: 1, columns: @[int('e')]),
      Line(x: 0, l: 0, columns: @[]),
      Line(x: -2, l: 7, columns: @[int('l'), 32, int('@'), 32, 32, 32, int('r')]),
      Line(x: -3, l: 1, columns: @[int('f')]),
      Line(x: 5, l: 1, columns: @[int('d')]),
    ])
    f.Blank(-5, -5)
    check f == moinsx
    const moinsf = Field(x: -2, y: -3, lx: 12, ly: 6, lines: @[
      Line(x: 8, l: 1, columns: @[int('u')]),
      Line(x: 9, l: 1, columns: @[int('e')]),
      Line(x: 0, l: 0, columns: @[]),
      Line(x: -2, l: 7, columns: @[int('l'), 32, int('@'), 32, 32, 32, int('r')]),
      Line(x: -3, l: 0, columns: @[]),
      Line(x: 5, l: 1, columns: @[int('d')]),
    ])
    f.Blank(-3, 1)
    check f == moinsf
    const moinse = Field(x: -2, y: -3, lx: 11, ly: 6, lines: @[
      Line(x: 8, l: 1, columns: @[int('u')]),
      Line(x: 9, l: 0, columns: @[]),
      Line(x: 0, l: 0, columns: @[]),
      Line(x: -2, l: 7, columns: @[int('l'), 32, int('@'), 32, 32, 32, int('r')]),
      Line(x: -3, l: 0, columns: @[]),
      Line(x: 5, l: 1, columns: @[int('d')]),
    ])
    f.Blank(9, -2)
    check f == moinse
    const moinsu = Field(x: -2, y: 0, lx: 8, ly: 3, lines: @[
      Line(x: -2, l: 7, columns: @[int('l'), 32, int('@'), 32, 32, 32, int('r')]),
      Line(x: -3, l: 0, columns: @[]),
      Line(x: 5, l: 1, columns: @[int('d')]),
    ])
    f.Blank(8, -3)
    check f == moinsu
    const moinsd = Field(x: -2, y: 0, lx: 7, ly: 1, lines: @[Line(x: -2, l: 7, columns: @[int('l'), 32, int('@'), 32, 32, 32, int('r')])])
    f.Blank(5, 2)
    check f == moinsd
    const moinsl = Field(x: 0, y: 0, lx: 5, ly: 1, lines: @[Line(x: 0, l: 5, columns: @[int('@'), 32, 32, 32, int('r')])])
    f.Blank(-2, 0)
    check f == moinsl
    const moinsr = Field(x: 0, y: 0, lx: 1, ly: 1, lines: @[Line(x: 0, l: 1, columns: @[int('@')])])
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
    check Load("examples/minimal.b98")[] == Field(lx: 1, ly: 1, lines: @[Line(l: 1, columns: @['@'].cols)])
    let hello = Field(lx: 24, ly: 1, lines: @[Line(l: 24, columns: @['6', '4', '+', '"', '!', 'd', 'l', 'r', 'o', 'W', ' ', ',', 'o', 'l', 'l', 'e', 'H', '"', '>', ':', '#', ',', '_', '@'].cols)])
    check Load("examples/hello.b98")[] == hello
    check Load("examples/rn.b98")[] == hello
    check Load("examples/hello2.b98")[] == Field(x: 1, lx: 33, ly: 2, lines: @[
      Line(x: 33, l: 1, columns: @['v'].cols),
      Line(x: 1, l: 33, columns: @['@', ' ', '>', ' ', '#', ';', '>', ':', '#', ',', '_', 'e', '-', 'j', ';', ' ', '"', 'H', 'e', 'l', 'l', 'o', ' ', 'w', 'o', 'r', 'l', 'd', '!',
          '"', 'd', 'a', '<'].cols)
    ])
    check Load("examples/factorial.b98")[] == Field(x: 0, lx: 15, ly: 2, lines: @[
      Line(x: 0, l: 15, columns: @['&', '>', ':', '1', '-', ':', 'v', ' ', 'v', ' ', '*', '_', '$', '.', '@'].cols),
      Line(x: 1, l: 11, columns: @['^', ' ', ' ', ' ', ' ', '_', '$', '>', '\\', ':', '^'].cols)
    ])
    check Load("examples/dna.b98")[] == Field(x: 0, lx: 7, ly: 8, lines: @[
      Line(x: 0, l: 7, columns: @['7', '^', 'D', 'N', '>', 'v', 'A'].cols),
      Line(x: 0, l: 7, columns: @['v', '_', '#', 'v', '?', ' ', 'v'].cols),
      Line(x: 0, l: 7, columns: @['7', '^', '<', '"', '"', '"', '"'].cols),
      Line(x: 0, l: 7, columns: @['3', ' ', ' ', 'A', 'C', 'G', 'T'].cols),
      Line(x: 0, l: 7, columns: @['9', '0', '!', '"', '"', '"', '"'].cols),
      Line(x: 0, l: 7, columns: @['4', '*', ':', '>', '>', '>', 'v'].cols),
      Line(x: 0, l: 7, columns: @['+', '8', '^', '-', '1', ',', '<'].cols),
      Line(x: 0, l: 7, columns: @['>', ' ', ',', '+', ',', '@', ')'].cols),
    ])
  test "Set":
    var f = Field(x: 0, y: 0, lx: 1, ly: 1, lines: @[Line(x: 0, l: 1, columns: @['>'].cols)])
    f.Set(0, 0, int('@'))
    check f == minimal
    f.Set(1, 0, int(' '))
    check f == minimal
    const xappend = Field(x: 0, y: 0, lx: 5, ly: 1, lines: @[Line(x: 0, l: 5, columns: @[int('@'), 32, 32, 32, int('r')])])
    f.Set(4, 0, int('r'))
    check f == xappend
    const xprepend = Field(x: -2, y: 0, lx: 7, ly: 1, lines: @[Line(x: -2, l: 7, columns: @[int('l'), 32, int('@'), 32, 32, 32, int('r')])])
    f.Set(-2, 0, int('l'))
    check f == xprepend
    const yappend = Field(x: -2, y: 0, lx: 8, ly: 3, lines: @[
      Line(x: -2, l: 7, columns: @[int('l'), 32, int('@'), 32, 32, 32, int('r')]),
      Line(x: 0, l: 0, columns: @[]),
      Line(x: 5, l: 1, columns: @[int('d')]),
    ])
    f.Set(5, 2, int('d'))
    check f == yappend
    const yprepend = Field(x: -2, y: -3, lx: 11, ly: 6, lines: @[
      Line(x: 8, l: 1, columns: @[int('u')]),
      Line(x: 0, l: 0, columns: @[]),
      Line(x: 0, l: 0, columns: @[]),
      Line(x: -2, l: 7, columns: @[int('l'), 32, int('@'), 32, 32, 32, int('r')]),
      Line(x: 0, l: 0, columns: @[]),
      Line(x: 5, l: 1, columns: @[int('d')]),
    ])
    f.Set(8, -3, int('u'))
    check f == yprepend
    const xappendEmptyline = Field(x: -2, y: -3, lx: 12, ly: 6, lines: @[
      Line(x: 8, l: 1, columns: @[int('u')]),
      Line(x: 9, l: 1, columns: @[int('e')]),
      Line(x: 0, l: 0, columns: @[]),
      Line(x: -2, l: 7, columns: @[int('l'), 32, int('@'), 32, 32, 32, int('r')]),
      Line(x: 0, l: 0, columns: @[]),
      Line(x: 5, l: 1, columns: @[int('d')]),
    ])
    f.Set(9, -2, int('e'))
    check f == xappendEmptyline
    const xprependEmptyline = Field(x: -3, y: -3, lx: 13, ly: 6, lines: @[
      Line(x: 8, l: 1, columns: @[int('u')]),
      Line(x: 9, l: 1, columns: @[int('e')]),
      Line(x: 0, l: 0, columns: @[]),
      Line(x: -2, l: 7, columns: @[int('l'), 32, int('@'), 32, 32, 32, int('r')]),
      Line(x: -3, l: 1, columns: @[int('f')]),
      Line(x: 5, l: 1, columns: @[int('d')]),
    ])
    f.Set(-3, 1, int('f'))
    check f == xprependEmptyline
    const xprependyprepend = Field(x: -5, y: -5, lx: 15, ly: 8, lines: @[
      Line(x: -5, l: 1, columns: @[int('x')]),
      Line(x: 0, l: 0, columns: @[]),
      Line(x: 8, l: 1, columns: @[int('u')]),
      Line(x: 9, l: 1, columns: @[int('e')]),
      Line(x: 0, l: 0, columns: @[]),
      Line(x: -2, l: 7, columns: @[int('l'), 32, int('@'), 32, 32, 32, int('r')]),
      Line(x: -3, l: 1, columns: @[int('f')]),
      Line(x: 5, l: 1, columns: @[int('d')]),
    ])
    f.Set(-5, -5, int('x'))
    check f == xprependyprepend
    const xprependyappend = Field(x: -7, y: -5, lx: 17, ly: 10, lines: @[
      Line(x: -5, l: 1, columns: @[int('x')]),
      Line(x: 0, l: 0, columns: @[]),
      Line(x: 8, l: 1, columns: @[int('u')]),
      Line(x: 9, l: 1, columns: @[int('e')]),
      Line(x: 0, l: 0, columns: @[]),
      Line(x: -2, l: 7, columns: @[int('l'), 32, int('@'), 32, 32, 32, int('r')]),
      Line(x: -3, l: 1, columns: @[int('f')]),
      Line(x: 5, l: 1, columns: @[int('d')]),
      Line(x: 0, l: 0, columns: @[]),
      Line(x: -7, l: 1, columns: @[int('y')]),
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
