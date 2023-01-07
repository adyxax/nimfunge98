type
  Line = object
    x: int
    columns: seq[int]

  Field* = object
    x, y: int
    lx: int
    lines: seq[Line]

func Blank*(f: var Field, x, y: int) =
  let ly = f.lines.len
  if y < f.y or y >= f.y+ly: # outside the field
    return
  var l = addr f.lines[y-f.y]
  let ll = l.columns.len
  if x < l.x or x >= l.x+ll: # outside the field
    return
  if x > l.x and x < l.x+ll-1: # just set the value
    l.columns[x-l.x] = int(' ')
    return
  if ll == 1: # this was the last character on the line
    if y == f.y: # we need to trim the leading lines
      var i = 1
      while f.lines[i].columns.len == 0:
        inc i
      f.y += i
      f.lines = f.lines[i..<ly]
    elif y == f.y+ly-1: # we need to trim the trailing lines
      var i = ly-2
      while f.lines[i].columns.len == 0:
        dec i
      f.lines = f.lines[0..i]
    else: # it was a line in the middle
      l.columns = @[]
  elif x == l.x: # we need to remove leading spaces
    var i = 1
    while l.columns[i] == int(' '):
      inc i
    l.x += i
    l.columns = l.columns[i..<ll]
  elif x == ll+l.x-1: # we need to remove trailing spaces
    var i = ll-2
    while l.columns[i] == int(' '):
      dec i
    l.columns = l.columns[0..i]
  # we now need to calculate the new field limits
  f.x = f.lines[0].x
  var x2 = f.lines[0].columns.len + f.lines[0].x
  for i in 1..<f.lines.len:
    if f.lines[i].columns.len == 0:
      continue
    if f.x > f.lines[i].x:
      f.x = f.lines[i].x
    if x2 < f.lines[i].x + f.lines[i].columns.len:
      x2 = f.lines[i].x + f.lines[i].columns.len
  f.lx = x2-f.x

func Get*(f: Field, x, y: int): int =
  if y >= f.y and y < f.y+f.lines.len:
    let l = f.lines[y-f.y]
    if x >= l.x and x < l.x+l.columns.len:
      return l.columns[x-l.x]
  return int(' ')

func IsIn*(f: Field, x, y: int): bool =
  return x >= f.x and y >= f.y and x < f.x+f.lx and y < f.y+f.lines.len

func Set*(f: var Field, x, y, v: int) =
  if v == int(' '):
    f.Blank(x, y)
    return
  elif y >= f.y:
    if y < f.y+f.lines.len: # the line exists
      var l = addr f.lines[y-f.y]
      if l.columns.len == 0: # An empty line is a special case
        l.x = x
        l.columns = @[v]
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
        var newline = newSeqUninitialized[int](l.columns.len+l.x-x)
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
      if f.lines.len == 0: # is it the first line of the field
        f.lines.setlen(1)
        f.x = x
        f.y = y
        f.lx = 1
      else:
        f.lines.setlen(y-f.y+1)
        if f.x > x:
          f.lx = f.lx + f.x - x
          f.x = x
        if f.lx < x-f.x+1:
          f.lx = x-f.x+1
      f.lines[y-f.y] = Line(x: x, columns: @[v])
  else: # prepend lines
    var newlines = newSeq[Line](f.lines.len+f.y-y)
    newlines[0] = Line(x: x, columns: @[v])
    for i in f.y-y..<newlines.len:
      newlines[i] = f.lines[i-f.y+y]
    f.lines = newlines
    f.y = y
    if f.x > x:
      f.lx = f.lx+f.x-x
      f.x = x
    if f.lx < x-f.x+1:
      f.lx = x-f.x+1

proc Load*(filename: string): ref Field =
  var file: File
  if not open(file, filename):
    return nil
  defer: file.close()
  var f: ref Field
  new(f)
  var lastReadIsCR = false
  var x = 0
  var y = 0
  while true:
    var data: array[4096, char]
    let n = file.readChars(data)
    if n <= 0:
      break
    var i = 0
    while i < n:
      if lastReadIsCR:
        lastReadIsCR = false
        if data[i] == '\n':
          inc i
          continue
      if data[i] == char(12):
        discard
      elif data[i] == '\r':
        x = 0
        inc y
        lastReadIsCR = true
      elif data[i] == '\n':
        x = 0
        inc y
      #elif data[i] == ' ':
      #  inc x
      else:
        f[].Set(x, y, int(data[i]))
        inc x
      inc i
  return f

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
  return (f.x, f.y, f.lx, f.lines.len)
