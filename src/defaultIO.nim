import strformat

## We keep the last input char to handle a pain point in the funge-98 spec :
## when reading from the decimal input you need to read until you encounter a
## non numeric char, but not drop it
var defaultInputLastChar: ref int

var stdIoUnbuffered = false

proc defaultCharacterInput*(): int =
  if defaultInputLastChar != nil:
    result = defaultInputLastChar[]
    defaultInputLastChar = nil
    return result
  if not stdIoUnbuffered:
    setStdIoUnbuffered()
    stdIoUnbuffered = true
  return stdin.readChar().int()

proc defaultDecimalInput*(): int =
  while true: # First we need to find the next numeric char
    let c = defaultCharacterInput()
    if c >= int('0') and c <= int('9'):
      result = c - int('0')
      break
  while true: # then we read until we encounter a non numeric char
    let c = defaultCharacterInput()
    if c >= int('0') and c <= int('9'):
      result = result * 10 + c - int('0')
    else:
      new(defaultInputLastChar)
      defaultInputLastChar[] = c
      break
  return result

proc defaultCharacterOutput*(v: int) =
  try:
    discard stdout.writeChars(@[v.char()], 0, 1)
  except RangeDefect:
    discard stdout.writeBuffer(unsafeAddr v, 4)

proc defaultDecimalOutput*(v: int) =
  stdout.write(&"{v} ")
