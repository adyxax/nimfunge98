import unittest

include ../src/stackStack

suite "StackStack":
  test "Pop":
    var empty = NewStackStack()
    check empty[].Pop() == 0
  test "Push":
    var empty = NewStackStack()
    empty[].Push(5)
    check empty[].Pop() == 5
  test "PopVector":
    var empty = NewStackStack()
    check empty[].PopVector() == (0, 0)
  test "PushVector":
    var empty = NewStackStack()
    empty[].PushVector((3, 2))
    check empty[].PopVector() == (3, 2)
  test "Clear":
    var empty = NewStackStack()
    empty[].Push(3)
    empty[].Clear()
    check empty[].Pop() == 0
  test "Duplicate":
    var empty = NewStackStack()
    empty[].Clear()
    check empty[].Pop() == 0
  test "Swap":
    var empty = NewStackStack()
    empty[].Swap()
    check empty[].Pop() == 0
  test "Begin":
    var empty = NewStackStack()
    empty[].Begin((1, 2))
    check empty.height == 2
    check empty[].Pop() == 0
    empty[].Push(5)
    empty[].Push(6)
    empty[].Push(4)
    empty[].Begin((3, 4))
    check empty.height == 3
    check empty[].Pop() == 6
    check empty[].Pop() == 5
    check empty[].Pop() == 0
    check empty[].Pop() == 0
    empty[].Push(7)
    empty[].Push(8)
    empty[].Push(9)
    empty[].Push(2)
    empty[].Begin((10, 11))
    check empty.height == 4
    check empty[].Pop() == 9
    check empty[].Pop() == 8
    check empty[].Pop() == 0
    empty[].Push(13)
    empty[].Push(14)
    empty[].Push(-2)
    empty[].Begin((15, 16))
    check empty[].Pop() == 0
  test "End":
    var empty = NewStackStack()
    var v: tuple[x,y: int] = (0, 0)
    empty[].Push(1)
    check empty[].End(v) == true
    check empty.height == 1
    check empty[].Pop() == 1
    empty[].Push(1)
    empty[].Push(2)
    empty[].Push(3)
    empty[].Push(4)
    empty[].Push(2)
    v = (5, 6)
    empty[].Begin(v)
    v = (0, 0)
    empty[].Push(2)
    check empty[].End(v) == false
    check v == (5, 6)
    check empty.height == 1
    check empty[].End(v) == true
    check empty[].Pop() == 4
    check empty[].Pop() == 3
    check empty[].Pop() == 2
    check empty[].Pop() == 1
    empty[].Push(1)
    empty[].Push(2)
    empty[].Push(3)
    empty[].Push(4)
    empty[].Push(2)
    empty[].Begin(v)
    empty[].Push(4)
    check empty[].End(v) == false
    check v == (5, 6)
    check empty.height == 1
    check empty[].Pop() == 4
    check empty[].Pop() == 3
    check empty[].Pop() == 0
    check empty[].Pop() == 0
    check empty[].Pop() == 2
    check empty[].Pop() == 1
    empty[].Push(1)
    empty[].Push(2)
    empty[].Push(3)
    empty[].Push(4)
    empty[].Push(1)
    empty[].Begin(v)
    empty[].Push(-2)
    check empty[].End(v) == false
    check v == (5, 6)
    check empty.height == 1
    check empty[].Pop() == 1
    check empty[].Pop() == 0
