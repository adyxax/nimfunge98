type
  Line = object
    x, l: int
    columns: seq[int]

  Field* = object
    x, y: int
    lx, ly: int
    lines: seq[Line]

func Blank*(f: var Field, x, y: int) =
  if y < f.y or y >= f.y+f.ly: # outside the field
    return
  var l = addr f.lines[y-f.y]
  if x < l.x or x >= l.x+l.l: # outside the field
    return
  if x > l.x and x < l.x+l.l-1: # just set the value
    l.columns[x-l.x] = int(' ')
    return
  if l.l == 1: # this was the last character on the line
    if y == f.y: # we need to trim the leading lines
      var i = 1
      while f.lines[i].l == 0:
        inc i
      f.y += i
      f.lines = f.lines[i..<f.ly]
      f.ly -= i
    elif y == f.y+f.ly-1: # we need to trim the trailing lines
      var i = f.ly-2
      while f.lines[i].l == 0:
        dec i
      f.ly = i+1
      f.lines = f.lines[0..<f.ly]
    else: # it was a line in the middle
      l.l = 0
      l.columns = @[]
  elif x == l.x: # we need to remove leading spaces
    var i = 1
    while l.columns[i] == int(' '):
      inc i
    l.x += i
    l.columns = l.columns[i..<l.l]
    l.l -= i
  elif x == l.l+l.x-1: # we need to remove trailing spaces
    var i = l.l-2
    while l.columns[i] == int(' '):
      dec i
    l.l = i+1
    l.columns = l.columns[0..<l.l]
  # we now need to calculate the new field limits
  f.x = f.lines[0].x
  var x2 = f.lines[0].l + f.lines[0].x
  for i in 1..<f.ly:
    if f.lines[i].l == 0:
      continue
    if f.x > f.lines[i].x:
      f.x = f.lines[i].x
    if x2 < f.lines[i].x + f.lines[i].l:
      x2 = f.lines[i].x + f.lines[i].l
  f.lx = x2-f.x

func Get*(f: Field, x, y: int): int =
  if y >= f.y and y < f.y+f.ly:
    let l = f.lines[y-f.y]
    if x >= l.x and x < l.x+l.l:
      return l.columns[x-l.x]
  return int(' ')

func IsIn*(f: Field, x, y: int): bool =
  return x >= f.x and y >= f.y and x < f.x+f.lx and y < f.y+f.ly

proc Load*(filename: string): ref Field =
  var file: File
  if not open(file, filename):
    return nil
  defer: file.close()
  var f: ref Field
  new(f)
  f.lines.add(Line())
  var l = addr f.lines[0]
  var trailingSpaces = 0
  var data: array[4096, char]
  var lastReadIsCR = false
  while true:
    let n = file.readChars(data, 0, 4096)
    if n <= 0:
      if f.ly == 0:
        if l.l == 0: # we got en empty file!
          return nil
        f.x = l.x
      if l.l > 0:
        inc f.ly
        if f.lx < l.l+l.x-f.x:
          f.lx = l.l+l.x-f.x
      break
    var i = 0
    while i < n:
      if data[i] == char(12):
        inc i
        continue
      if lastReadIsCR and data[i] == '\n':
        inc i
        lastReadIsCR = false
        continue
      if data[i] == '\n' or data[i] == '\r':
        if f.ly == 0:
          if l.l == 0:
            return nil
          f.x = l.x
        inc f.ly
        if l.l > 0:
          if f.x > l.x:
            f.x = l.x
          if f.lx < l.l+l.x-f.x:
            f.lx = l.l+l.x-f.x
        f.lines.add(Line())
        l = addr f.lines[^1]
        trailingSpaces = 0
        if i+1 < n:
          if data[i] == '\r' and data[i+1] == '\n':
            inc i
        else:
          lastReadIsCR = true
      else:
        if data[i] == ' ':
          if l.l == 0: # trim leading spaces
            inc l.x
          else:
            inc trailingSpaces
        else:
          if trailingSpaces > 0:
            let newL = l.l + trailingSpaces + 1
            l.columns.setlen(newL)
            for j in l.l..<newL-1:
              l.columns[j] = int(' ')
            l.columns[newL-1] = int(data[i])
            l.l = newL
            trailingSpaces = 0
          else:
            l.columns.add(int(data[i]))
            inc l.l
      inc i
  f.lines = f.lines[0..<f.ly]
  return f

func Set*(f: var Field, x, y, v: int) =
  if v == int(' '):
    f.Blank(x, y)
  elif y >= f.y:
    if y < f.y+f.ly: # the line exists
      var l = addr f.lines[y-f.y]
      if l.l == 0: # An empty line is a special case
        l.x = x
        l.l = 1
        l.columns = @[v]
        if f.x > x:
          f.lx = f.lx+f.x-x
          f.x = x
        if f.lx < x-f.x+1:
          f.lx = x-f.x+1
      elif x >= l.x:
        if x < l.x+l.l: # just set the value
          l.columns[x-l.x] = v
        else: # append columns
          let newL = x-l.x+1
          l.columns.setlen(newL)
          for i in l.l..<newL-1:
            l.columns[i] = int(' ')
          l.columns[newL-1] = v
          l.l = newL
          if f.lx < l.l+l.x-f.x:
            f.lx = l.l+l.x-f.x
      else: # preprend columns
        let newL = l.l + l.x - x
        var newline = newSeqUninitialized[int](newL)
        newline[0] = v
        for i in 1..<l.x-x:
          newline[i] = int(' ')
        for i in l.x-x..<newL:
          newline[i] = l.columns[i-l.x+x]
        l.columns = newline
        l.x = x
        l.l = newL
        if f.x > x:
          f.lx = f.lx + f.x - x
          f.x = x
    else: # append lines
      f.ly = y-f.y+1
      f.lines.setlen(f.ly)
      f.lines[f.ly-1] = Line(x: x, l: 1, columns: @[v])
      if f.x > x:
        f.lx = f.lx + f.x - x
        f.x = x
      if f.lx < x-f.x+1:
        f.lx = x-f.x+1
  else: # prepend lines
    let newLy = f.ly+f.y-y
    var newlines = newSeq[Line](newLy)
    newlines[0] = Line(x: x, l: 1, columns: @[v])
    for i in f.y-y..<newLy:
      newlines[i] = f.lines[i-f.y+y]
    f.lines = newlines
    f.y = y
    f.ly = newLy
    if f.x > x:
      f.lx = f.lx+f.x-x
      f.x = x
    if f.lx < x-f.x+1:
      f.lx = x-f.x+1

func Step*(f: Field, v: tuple[x, y: int], d: tuple[x, y: int]): (int, int) =
  var x = v.x + d.x
  var y = v.y + d.y
  if f.IsIn(x, y):
    return (x, y)
  # We are stepping outside, we need to wrap the Lahey-space
  x = v.x
  y = v.y
  while true:
    let x2 = x - d.x
    let y2 = y - d.y
    if not f.IsIn(x2, y2):
      return (x, y)
    x = x2; y = y2

func GetSize*(f: Field): (int, int, int, int) =
  return (f.x, f.y, f.lx, f.ly)
