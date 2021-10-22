import stack

type
  StackStack* = object
    height: int
    head: ref Stack

func NewStackStack*(): ref StackStack =
  new(result)
  result.head = NewStack()
  result.height = 1

func Pop*(ss: StackStack): int =
  return ss.head[].Pop()

func Push*(ss: StackStack, v: int) =
  ss.head[].Push(v)

func PopVector*(ss: StackStack): (int, int) =
  return ss.head[].PopVector()

func PushVector*(ss: var StackStack, v: tuple[x, y: int]) =
  ss.head[].PushVector(v)

func Clear*(ss: var StackStack) =
  ss.head[].Clear()

func Duplicate*(ss: var StackStack) =
  ss.head[].Duplicate()

func Swap*(ss: var StackStack) =
  ss.head[].Swap()

func Begin*(ss: var StackStack, v: tuple[x, y: int]) =
  inc ss.height
  let soss = ss.head
  let n = soss[].Pop()
  ss.head = NewStack(size = abs(n), next = soss)
  let toss = ss.head
  if n > 0:
    toss[].Transfert(soss[], n)
  elif n < 0:
    for i in 0 ..< -n:
      soss[].Push(0)
  soss[].PushVector(v)

func End*(ss: var StackStack, v: var tuple[x, y: int]): bool =
  ## Implements the '}' command behaviour which pops a stack from the stack stack
  ## returns true if a reflect should happen
  if ss.height == 1:
    return true
  let toss = ss.head
  let soss = toss[].Next()
  let n = toss[].Pop()
  (v.x, v.y) = soss[].PopVector()
  if n > 0:
    soss[].Transfert(toss[], n)
  else:
    soss[].Discard(-n)
  dec ss.height
  ss.head = soss
  return false

func Under*(ss: var StackStack): bool =
  if ss.height == 1:
    return true
  let soss = ss.head[].Next()
  let n = ss.Pop()
  if n > 0:
    for i in 0..<n:
      ss.Push(soss[].Pop())
  else:
    for i in 0 ..< -n:
      soss[].Push(ss.Pop())
  return false

func GetHeights*(ss: StackStack): seq[int] =
  return ss.head[].GetHeights

func YCommandPick*(ss: var StackStack, n, h: int) =
  ss.head[].YCommandPick(n, h)
