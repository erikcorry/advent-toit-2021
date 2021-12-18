import expect show *
import .file as file
import reader show BufferedReader

// A mostly immutable solution for day 18 of Advent of Code.  The
// SnailfishPair and Snailfish objects are immutable, and the
// reduction functions generate new trees, reusing many of the
// immutable objects to build the new trees.
// Parsing and building up the list of inputs is not purely functional.
main:
  reader := BufferedReader
    file.Stream.for_read "18.txt"

  inputs := []
  while line := reader.read_line:
    inputs.add
      Snailfish line

  all_added := inputs.reduce: | sum b | sum + b

  print all_added
  print all_added.magnitude

  // Could do this with a nested loop, but a nested List.reduce is more
  // functional.
  best := inputs.reduce --initial=0: | best_left left |
    max best_left
      inputs.reduce --initial=0: | best_right right |
        max best_right (left + right).magnitude

  print best

// Produced when a Snailfish explodes.
class Shard:
  left /int?
  result /Snailfish
  right /int?

  constructor .left .result .right:

/// Either a number or a pair.
abstract class Snailfish:
  // Returns a Shard if an explosion happened, otherwise null.
  abstract reduce_explode --depth -> Shard?
  // Returns a Snailfish if a split happened, otherwise null.
  abstract reduce_split -> Snailfish?
  abstract add_to_leftmost shard/Shard -> Snailfish
  abstract add_to_rightmost shard/Shard -> Snailfish
  abstract magnitude

  constructor:

  /// A parsing factory constructor.
  constructor str/string:
    if str[0] == '[':
      comma := comma_position str
      return SnailfishPair
        Snailfish str[1..comma]
        Snailfish str[comma + 1..str.size - 1]
    else:
      return SnailfishNumber
        int.parse str

  operator + b:
    return reduce
      SnailfishPair this b

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

  static reduce fish/Snailfish -> Snailfish:
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

class SnailfishNumber extends Snailfish:
  value /int

  constructor .value:

  magnitude -> int: return value

  reduce_explode --depth -> Shard?:
    return null

  reduce_split -> SnailfishPair?:
    if value < 10: return null
    return SnailfishPair
        SnailfishNumber value / 2
        SnailfishNumber (value + 1) / 2

  add_to_leftmost shard/Shard -> SnailfishNumber:
    if shard.right:
      return SnailfishNumber this.value + shard.right
    return this

  add_to_rightmost shard/Shard -> SnailfishNumber:
    if shard.left:
      return SnailfishNumber this.value + shard.left
    return this

  stringify -> string: return value.stringify

class SnailfishPair extends Snailfish:
  a /Snailfish
  b /Snailfish

  constructor .a .b:

  magnitude -> int:
    return 3 * a.magnitude + 2 * b.magnitude

  reduce_explode --depth -> Shard?:
    if depth < 5:
      left := a.reduce_explode --depth=(depth + 1)
      if left:
        // An explosion happened on the left.
        new_right := b.add_to_leftmost left
        return Shard
            left.left
            SnailfishPair left.result new_right
            null
      right := b.reduce_explode --depth=(depth + 1)
      if right:
        // An explosion happened on the right.
        new_left := a.add_to_rightmost right
        return Shard
            null
            SnailfishPair new_left right.result
            right.right
      // No explosions in the subtrees.
      return null
    // Depth is 5 - an explosion happens here.
    assert: depth == 5
    l := a as SnailfishNumber
    r := b as SnailfishNumber
    return Shard
        l.value
        SnailfishNumber 0
        r.value

  reduce_split -> SnailfishPair?:
    left := a.reduce_split
    if left:
      // A split happened on the left.
      return SnailfishPair
          left
          b
    right := b.reduce_split
    if right:
      // A split happened on the right.
      return SnailfishPair
          a
          right
    // No splits happened.
    return null

  add_to_rightmost shard/Shard -> SnailfishPair:
    return SnailfishPair
        a
        b.add_to_rightmost shard

  add_to_leftmost shard/Shard -> SnailfishPair:
    return SnailfishPair
        a.add_to_leftmost shard
        b

  stringify -> string: return "[$a,$b]"
