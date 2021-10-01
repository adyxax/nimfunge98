import unittest

include field

proc `==`(a, b: Line): bool = a.x == b.x and a.l == b.l and a.columns == b.columns
proc `==`(a, b: Field): bool = a.x == b.x and a.lx == b.lx and a.y == b.y and a.ly == b.ly and a.lines == b.lines

const minimal = Field(x: 0, y: 0, lx: 1, ly: 1, lines: @[Line(x: 0, l: 1, columns: @[int('@')])])

suite "Field":
  test "Field.blank":
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
    f.blank(1, 0)
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
    f.blank(-7, 4)
    check f == moinsy
    const moinsx = Field(x: -3, y: -3, lx: 13, ly: 6, lines: @[
      Line(x: 8, l: 1, columns: @[int('u')]),
      Line(x: 9, l: 1, columns: @[int('e')]),
      Line(x: 0, l: 0, columns: @[]),
      Line(x: -2, l: 7, columns: @[int('l'), 32, int('@'), 32, 32, 32, int('r')]),
      Line(x: -3, l: 1, columns: @[int('f')]),
      Line(x: 5, l: 1, columns: @[int('d')]),
    ])
    f.blank(-5, -5)
    check f == moinsx
    const moinsf = Field(x: -2, y: -3, lx: 12, ly: 6, lines: @[
      Line(x: 8, l: 1, columns: @[int('u')]),
      Line(x: 9, l: 1, columns: @[int('e')]),
      Line(x: 0, l: 0, columns: @[]),
      Line(x: -2, l: 7, columns: @[int('l'), 32, int('@'), 32, 32, 32, int('r')]),
      Line(x: -3, l: 0, columns: @[]),
      Line(x: 5, l: 1, columns: @[int('d')]),
    ])
    f.blank(-3, 1)
    check f == moinsf
    const moinse = Field(x: -2, y: -3, lx: 11, ly: 6, lines: @[
      Line(x: 8, l: 1, columns: @[int('u')]),
      Line(x: 9, l: 0, columns: @[]),
      Line(x: 0, l: 0, columns: @[]),
      Line(x: -2, l: 7, columns: @[int('l'), 32, int('@'), 32, 32, 32, int('r')]),
      Line(x: -3, l: 0, columns: @[]),
      Line(x: 5, l: 1, columns: @[int('d')]),
    ])
    f.blank(9, -2)
    check f == moinse
    const moinsu = Field(x: -2, y: 0, lx: 8, ly: 3, lines: @[
      Line(x: -2, l: 7, columns: @[int('l'), 32, int('@'), 32, 32, 32, int('r')]),
      Line(x: -3, l: 0, columns: @[]),
      Line(x: 5, l: 1, columns: @[int('d')]),
    ])
    f.blank(8, -3)
    check f == moinsu
    const moinsd = Field(x: -2, y: 0, lx: 7, ly: 1, lines: @[Line(x: -2, l: 7, columns: @[int('l'), 32, int('@'), 32, 32, 32, int('r')])])
    f.blank(5, 2)
    check f == moinsd
    const moinsl = Field(x: 0, y: 0, lx: 5, ly: 1, lines: @[Line(x: 0, l: 5, columns: @[int('@'), 32, 32, 32, int('r')])])
    f.blank(-2,0)
    check f == moinsl
    const moinsr = Field(x: 0, y: 0, lx: 1, ly: 1, lines: @[Line(x: 0, l: 1, columns: @[int('@')])])
    f.blank(4,0)
    check f == moinsr
  test "Field.get":
    check minimal.get(0,0) == int('@')
    check minimal.get(1,0) == int(' ')
  test "Field.isIn":
    check minimal.isIn(0, 0) == true
    check minimal.isIn(1, 0) == false
  test "Field.set":
    var f = Field(x: 0, y: 0, lx: 1, ly: 1, lines: @[Line(x: 0, l: 1, columns: @[int('>')])])
    f.set(0,0,int('@'))
    check f == minimal
    f.set(1,0,int(' '))
    check f == minimal
    const xappend = Field(x: 0, y: 0, lx: 5, ly: 1, lines: @[Line(x: 0, l: 5, columns: @[int('@'), 32, 32, 32, int('r')])])
    f.set(4, 0, int('r'))
    check f == xappend
    const xprepend = Field(x: -2, y: 0, lx: 7, ly: 1, lines: @[Line(x: -2, l: 7, columns: @[int('l'), 32, int('@'), 32, 32, 32, int('r')])])
    f.set(-2, 0, int('l'))
    check f == xprepend
    const yappend = Field(x: -2, y: 0, lx: 8, ly: 3, lines: @[
      Line(x: -2, l: 7, columns: @[int('l'), 32, int('@'), 32, 32, 32, int('r')]),
      Line(x: 0, l: 0, columns: @[]),
      Line(x: 5, l: 1, columns: @[int('d')]),
    ])
    f.set(5, 2, int('d'))
    check f == yappend
    const yprepend = Field(x: -2, y: -3, lx: 11, ly: 6, lines: @[
      Line(x: 8, l: 1, columns: @[int('u')]),
      Line(x: 0, l: 0, columns: @[]),
      Line(x: 0, l: 0, columns: @[]),
      Line(x: -2, l: 7, columns: @[int('l'), 32, int('@'), 32, 32, 32, int('r')]),
      Line(x: 0, l: 0, columns: @[]),
      Line(x: 5, l: 1, columns: @[int('d')]),
    ])
    f.set(8, -3, int('u'))
    check f == yprepend
    const xappendEmptyline = Field(x: -2, y: -3, lx: 12, ly: 6, lines: @[
      Line(x: 8, l: 1, columns: @[int('u')]),
      Line(x: 9, l: 1, columns: @[int('e')]),
      Line(x: 0, l: 0, columns: @[]),
      Line(x: -2, l: 7, columns: @[int('l'), 32, int('@'), 32, 32, 32, int('r')]),
      Line(x: 0, l: 0, columns: @[]),
      Line(x: 5, l: 1, columns: @[int('d')]),
    ])
    f.set(9, -2, int('e'))
    check f == xappendEmptyline
    const xprependEmptyline = Field(x: -3, y: -3, lx: 13, ly: 6, lines: @[
      Line(x: 8, l: 1, columns: @[int('u')]),
      Line(x: 9, l: 1, columns: @[int('e')]),
      Line(x: 0, l: 0, columns: @[]),
      Line(x: -2, l: 7, columns: @[int('l'), 32, int('@'), 32, 32, 32, int('r')]),
      Line(x: -3, l: 1, columns: @[int('f')]),
      Line(x: 5, l: 1, columns: @[int('d')]),
    ])
    f.set(-3, 1, int('f'))
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
    f.set(-5, -5, int('x'))
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
    f.set(-7, 4, int('y'))
    check f == xprependyappend
