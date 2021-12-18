import expect show *
import .file as file
import reader show BufferedReader

main:
  reader := BufferedReader
    file.Stream.for_read "18.txt"

  inputs := []
  while line := reader.read_line:
    inputs.add
        Snailfish line

  all_added := inputs.reduce: | sum b |
    reduce
      SnailfishPair sum b

  print all_added.magnitude

  best := 0
  inputs.do: | left |
    inputs.do: | right |
      best = max best
          (reduce (SnailfishPair left right)).magnitude
  print best

class Shard:
  left /int?
  result /Snailfish
  right /int?

  constructor .left .result .right:

interface Snailfish:

  // Returns a Shard if an explosion happened, otherwise null.
  reduce_explode --depth -> Shard?
  // Returns a Snailfish if a split happened, otherwise null.
  reduce_split -> Snailfish?
  add_to_leftmost shard/Shard
  add_to_rightmost shard/Shard
  magnitude
  stringify --depth

  constructor str/string:
    if str[0] == '[':
      comma := comma_position str
      return SnailfishPair
        Snailfish str[1..comma]
        Snailfish str[comma + 1..str.size - 1]
    else:
      return SnailfishNumber
        int.parse str

  static comma_position str/string -> int:
    depth := 1
    pos := 1
    while true:
      if str[pos] == ',' and depth == 1: return pos
      if str[pos] == '[':
        depth++
      if str[pos] == ']':
        depth--
      pos++

reduce fish/Snailfish -> Snailfish:
  current := fish
  while true:
    shard := current.reduce_explode --depth=1
    if shard:
      current = shard.result
    else:
      split_fish := current.reduce_split
      if not split_fish:
        return current
      current = split_fish

class SnailfishNumber implements Snailfish:
  value /int

  constructor .value:

  magnitude: return value

  operator == other:
    if other is not SnailfishNumber: return false
    o := other as SnailfishNumber
    return o.value == value

  reduce_explode --depth -> Shard?:
    return null

  reduce_split:
    if value < 10: return null
    return SnailfishPair
        SnailfishNumber value / 2
        SnailfishNumber (value + 1) / 2

  add_to_leftmost shard/Shard ->SnailfishNumber:
    if shard.right:
      return SnailfishNumber this.value + shard.right
    return this

  add_to_rightmost shard/Shard ->SnailfishNumber:
    if shard.left:
      return SnailfishNumber this.value + shard.left
    return this

  stringify --depth=0 -> string: return value.stringify

class SnailfishPair implements Snailfish:
  a /Snailfish
  b /Snailfish

  constructor .a .b:

  magnitude:
    return 3 * a.magnitude + 2 * b.magnitude

  operator == other:
    if other is not SnailfishPair: return false
    o := other as SnailfishPair
    return o.a == a and o.b == b

  operator + b: return SnailfishPair this b

  reduce_explode --depth:
    if depth < 5:
      left := a.reduce_explode --depth=(depth + 1)
      // If something happened on the left then we don't need to change the
      // right except perhaps to add to the left-most value.
      if left:
        new_right := b.add_to_leftmost left
        return Shard
            left.left
            SnailfishPair left.result new_right
            null
      right := b.reduce_explode --depth=(depth + 1)
      if right:
        new_left := a.add_to_rightmost right
        return Shard
            null
            SnailfishPair new_left right.result
            right.right
      return null
    assert: depth == 5
    l := a as SnailfishNumber
    r := b as SnailfishNumber
    return Shard
        l.value
        SnailfishNumber 0
        r.value

  reduce_split:
    left := a.reduce_split
    if left:
      return SnailfishPair
          left
          b
    right := b.reduce_split
    if right:
      return SnailfishPair
          a
          right
    return null

  add_to_rightmost shard/Shard:
    return SnailfishPair
        a
        b.add_to_rightmost shard

  add_to_leftmost shard/Shard:
    return SnailfishPair
        a.add_to_leftmost shard
        b

  stringify -> string: return stringify --depth=1

  stringify --depth -> string:
    return "[$a,$b]"
