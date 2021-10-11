type
  Line = ref object
    x: int
    columns: seq[int]

  Field* = object
    x, y: int
    lx, ly: int
    lines: seq[Line]

func Blank*(f: var Field, x, y: int) =
  if y < f.y or y >= f.y+f.ly: # outside the field
    return
  var l = f.lines[y-f.y]
  if x < l.x or x >= l.x+l.columns.len: # outside the field
    return
  if x > l.x and x < l.x+l.columns.len-1: # just set the value
    l.columns[x-l.x] = int(' ')
    return
  if l.columns.len == 1: # this was the last character on the line
    if y == f.y: # we need to trim the leading lines
      var i = 1
      while f.lines[i] == nil or f.lines[i].columns.len == 0:
        inc i
      f.y += i
      f.lines = f.lines[i..<f.ly]
      f.ly -= i
    elif y == f.y+f.ly-1: # we need to trim the trailing lines
      var i = f.ly-2
      while f.lines[i] == nil or f.lines[i].columns.len == 0:
        dec i
      f.ly = i+1
      f.lines = f.lines[0..<f.ly]
    else: # it was a line in the middle
      l.columns = @[]
  elif x == l.x: # we need to remove leading spaces
    var i = 1
    while l.columns[i] == int(' '):
      inc i
    l.x += i
    l.columns = l.columns[i..<l.columns.len]
  elif x == l.columns.len+l.x-1: # we need to remove trailing spaces
    var i = l.columns.len-2
    while l.columns[i] == int(' '):
      dec i
    l.columns = l.columns[0..i]
  # we now need to calculate the new field limits
  f.x = f.lines[0].x
  var x2 = f.lines[0].columns.len + f.lines[0].x
  for i in 1..<f.ly:
    if f.lines[i] == nil or f.lines[i].columns.len == 0:
      continue
    if f.x > f.lines[i].x:
      f.x = f.lines[i].x
    if x2 < f.lines[i].x + f.lines[i].columns.len:
      x2 = f.lines[i].x + f.lines[i].columns.len
  f.lx = x2-f.x

func Get*(f: Field, x, y: int): int =
  if y >= f.y and y < f.y+f.ly:
    let l = f.lines[y-f.y]
    if x >= l.x and x < l.x+l.columns.len:
      return l.columns[x-l.x]
  return int(' ')

func IsIn*(f: Field, x, y: int): bool =
  return x >= f.x and y >= f.y and x < f.x+f.lx and y < f.y+f.ly

proc Load*(filename: string): ref Field =
  var file: File
  if not open(file, filename):
    return nil
  defer: file.close()
  var f = new(Field)
  var l = new(Line)
  var trailingSpaces = 0
  var data: array[4096, char]
  var lastReadIsCR = false
  while true:
    let n = file.readChars(data, 0, 4096)
    if n <= 0:
      if f.ly == 0:
        if l.columns.len == 0: # we got en empty file!
          return nil
        f.x = l.x
      if l.columns.len > 0:
        if f.lx < l.columns.len+l.x-f.x:
          f.lx = l.columns.len+l.x-f.x
        f.lines.add(l)
        inc f.ly
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
          if l.columns.len == 0:
            return nil
          f.x = l.x
        if l.columns.len > 0:
          if f.x > l.x:
            f.x = l.x
          if f.lx < l.columns.len+l.x-f.x:
            f.lx = l.columns.len+l.x-f.x
        inc f.ly
        f.lines.add(l)
        l = new(Line)
        trailingSpaces = 0
        if data[i] == '\r':
          if i+1 < n and data[i+1] == '\n':
            inc i
          else:
            lastReadIsCR = true
      else:
        if data[i] == ' ':
          if l.columns.len == 0: # trim leading spaces
            inc l.x
          else:
            inc trailingSpaces
        else:
          if trailingSpaces > 0:
            let oldL = l.columns.len
            l.columns.setlen(oldL+trailingSpaces+1)
            for j in oldL..<l.columns.len-1:
              l.columns[j] = int(' ')
            l.columns[^1] = int(data[i])
            trailingSpaces = 0
          else:
            l.columns.add(int(data[i]))
      inc i
  return f

func Set*(f: var Field, x, y, v: int) =
  if v == int(' '):
    f.Blank(x, y)
  elif y >= f.y:
    if y < f.y+f.ly: # the line exists
      var l = f.lines[y-f.y]
      if l == nil or l.columns.len == 0: # An empty line is a special case
        if l == nil:
          new(l)
        l.x = x
        l.columns = @[v]
        f.lines[y-f.y] = l
        if f.x > x:
          f.lx = f.lx+f.x-x
          f.x = x
        if f.lx < x-f.x+1:
          f.lx = x-f.x+1
      elif x >= l.x:
        if x < l.x+l.columns.len: # just set the value
          l.columns[x-l.x] = v
        else: # append columns
          let oldL = l.columns.len
          l.columns.setlen(x-l.x+1)
          for i in oldL..<l.columns.len-1:
            l.columns[i] = int(' ')
          l.columns[^1] = v
          if f.lx < l.columns.len+l.x-f.x:
            f.lx = l.columns.len+l.x-f.x
      else: # preprend columns
        let oldL = l.columns.len
        var newline = newSeqUninitialized[int](oldL+l.x-x)
        newline[0] = v
        for i in 1..<l.x-x:
          newline[i] = int(' ')
        for i in l.x-x..<newline.len:
          newline[i] = l.columns[i-l.x+x]
        l.columns = newline
        l.x = x
        if f.x > x:
          f.lx = f.lx + f.x - x
          f.x = x
    else: # append lines
      f.ly = y-f.y+1
      f.lines.setlen(f.ly)
      f.lines[f.ly-1] = Line(x: x, columns: @[v])
      if f.x > x:
        f.lx = f.lx + f.x - x
        f.x = x
      if f.lx < x-f.x+1:
        f.lx = x-f.x+1
  else: # prepend lines
    let newLy = f.ly+f.y-y
    var newlines = newSeq[Line](newLy)
    newlines[0] = Line(x: x, columns: @[v])
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
