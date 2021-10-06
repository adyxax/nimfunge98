import field
import pointer

type
  Interpreter = object
    f: ref Field
    p: ref Pointer
    argv: seq[string]

func NewInterpreter*(f: ref Field, p: ref Pointer): ref Interpreter =
  new(result)
  result.f = f
  result.p = p

proc Step*(i: var Interpreter): ref int =
  var prev: ref Pointer
  var p = i.p
  while p != nil:
    let (d, v) = p[].Exec(i.f[])
    if v != nil:
      return v
    if d:
      if prev == nil:
        i.p = p.next
      else:
        prev.next = p.next
    p = p.next

proc Run*(i: var Interpreter): int =
  while i.p != nil:
    let v = i.Step()
    if v != nil:
      return v[]
