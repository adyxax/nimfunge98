type
  Stack* = object
    size, height: int
    data: seq[int]
    next: ref Stack

func NewStack*(size: int = 32, next: ref Stack = nil): ref Stack =
  new(result)
  result.size = size
  result.data.setlen(size)
  result.next = next

func Pop*(s: var Stack): int =
  if s.height > 0:
    dec s.height
    return s.data[s.height]
  return 0

func Push*(s: var Stack, v: int) =
  if s.height >= s.size:
    s.size += 32
    s.data.setlen(s.size)
  s.data[s.height] = v
  inc s.height

func PopVector*(s: var Stack): (int, int) =
  if s.height >= 2:
    s.height -= 2
    return (s.data[s.height], s.data[s.height+1])
  elif s.height == 1:
    s.height = 0
    return (0, s.data[0])
  else:
    return (0, 0)

func PushVector*(s: var Stack, v: tuple[x, y: int]) =
  if s.height+1 >= s.size:
    s.size += 32
    s.data.setlen(s.size)
  s.data[s.height] = v.x
  inc s.height
  s.data[s.height] = v.y
  inc s.height

func Clear*(s: var Stack) =
  s.height = 0

func Duplicate*(s: var Stack) =
  let v = s.Pop()
  s.PushVector((v, v));

func Swap*(s: var Stack) =
  let a = s.Pop
  let b = s.Pop
  s.Push(a)
  s.Push(b)

func Transfert*(toss: var Stack, soss: var Stack, n: int) =
  ## Implements a value transfert between two stacks, intended for use with the '{'
  ## (aka begin) and '}' (aka end) stackstack commands
  toss.height += n
  if toss.height > toss.size:
    toss.size = toss.height
    toss.data.setlen(toss.size)
  for i in 1..min(soss.height, n):
    toss.data[toss.height-i] = soss.data[soss.height-i]
  for i in min(soss.height, n)+1..n:
    toss.data[toss.height-i] = 0
  soss.height -= n
  if soss.height < 0:
    soss.height = 0

func Discard*(s: var Stack, n: int) =
  ## Implements a discard mechanism intended for use with the '}'(aka end) stackstack command
  s.height -= n
  if s.height < 0:
    s.height = 0

func Next*(s: Stack): ref Stack =
  return s.next

func GetHeights*(s: Stack): seq[int] =
  if s.next != nil:
    result = s.next[].GetHeights()
    result.add(s.height)
  else:
    return @[s.height]

func YCommandPick*(s: var Stack, n, h: int) =
  if n > s.height:
    s.height = 1
    s.data[0] = 0
  else:
    let v = s.data[s.height-n]
    s.height = h
    s.Push(v)
