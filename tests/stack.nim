import unittest

include ../src/stack

suite "Stack":
  test "Pop":
    var empty = NewStack()
    check empty[].Pop() == 0
    var simple = NewStack()
    simple.data[0] = 1
    simple.data[1] = 5
    simple.height = 2
    check simple[].Pop() == 5
    check simple[].Pop() == 1
    check simple[].Pop() == 0
  test "Push":
    var s = NewStack()
    check s.height == 0
    check s.data[0] == 0
    check s.data[1] == 0
    check s.data[2] == 0
    s[].Push(5)
    check s.height == 1
    check s.data[0] == 5
    check s.data[1] == 0
    check s.data[2] == 0
    s[].Push(-2)
    check s.height == 2
    check s.data[0] == 5
    check s.data[1] == -2
    check s.data[2] == 0
    for i in 0..30:
      s[].Push(i)
    check s.size == 64
  test "PopVector":
    var empty = NewStack()
    check empty[].PopVector() == (0, 0)
    check empty.height == 0
    var some = NewStack()
    some[].Push(2)
    check some[].PopVector() == (0, 2)
    check some.height == 0
    var full = NewStack()
    full[].Push(1)
    full[].Push(2)
    full[].Push(3)
    check full[].PopVector() == (2, 3)
    check full.height == 1
  test "PushVector":
    var s = NewStack()
    check s.height == 0
    check s.data[0] == 0
    check s.data[1] == 0
    check s.data[2] == 0
    s[].PushVector((5, -3))
    check s.height == 2
    check s.data[0] == 5
    check s.data[1] == -3
    check s.data[2] == 0
    for i in 0..15:
      s[].PushVector((i, i+1))
    check s.size == 64
  test "Clear":
    var empty: Stack
    empty.Clear()
    check empty.height == 0
    var some = NewStack()
    some[].Push(1)
    some[].Push(2)
    some[].Clear()
    check some.height == 0
  test "Duplicate":
    var empty = NewStack()
    empty[].Duplicate()
    check empty.height == 2
    check empty.data[0] == 0
    check empty.data[1] == 0
    var some = NewStack()
    some[].Push(2)
    some[].Push(-4)
    some[].Duplicate()
    check some.height == 3
    check some.data[0] == 2
    check some.data[1] == -4
    check some.data[2] == -4
    check some.data[3] == 0
  test "Swap":
    var empty = NewStack()
    empty[].Swap()
    check empty.height == 2
    check empty.data[0] == 0
    check empty.data[1] == 0
    var some = NewStack()
    some[].Push(2)
    some[].Push(-4)
    some[].Push(7)
    some[].Swap()
    check some.height == 3
    check some.data[0] == 2
    check some.data[1] == 7
    check some.data[2] == -4
    check some.data[3] == 0
  test "Transfert":
    var empty = NewStack()
    var empty2 = NewStack()
    empty[].Transfert(empty2[], 4)
    check empty.height == 4
    check empty2.height == 0
    check empty.data[0] == 0
    check empty.data[1] == 0
    check empty.data[2] == 0
    check empty.data[3] == 0
    empty[].Transfert(empty2[], 32)
    check empty.size == 64
    empty = NewStack()
    var some = NewStack()
    some[].Push(2)
    empty[].Transfert(some[], 3)
    check empty.height == 3
    check some.height == 0
    check empty.data[0] == 0
    check empty.data[1] == 0
    check empty.data[2] == 2
    empty = NewStack()
    var full = NewStack()
    full[].Push(1)
    full[].Push(2)
    full[].Push(3)
    empty[].Transfert(full[], 2)
    check empty.height == 2
    check full.height == 1
    check full.data[0] == 1
    check empty.data[0] == 2
    check empty.data[1] == 3
  test "Discard":
    var empty = NewStack()
    empty[].Discard(1)
    check empty.height == 0
    empty[].Push(2)
    empty[].Discard(3)
    check empty.height == 0
  test "Next":
    var empty = NewStack()
    check empty[].Next() == nil
    var some = NewStack(next = empty)
    check some[].Next() == empty
  test "GetHeights":
    var empty = NewStack()
    check empty[].GetHeights == @[0]
