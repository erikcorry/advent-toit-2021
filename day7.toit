import .file as file
import reader show BufferedReader

main:
  reader := BufferedReader
    file.Stream.for_read "7.txt"
  crabs := (reader.read_line.split ",").map: int.parse it

  left := crabs.reduce: | a b | min a b
  right := crabs.reduce: | a b | max a b

  best_cost := crabs.reduce --initial=0: | sum x | sum + (x - right).abs
  for i := left; i < right; i++:
    cost := crabs.reduce --initial=0: | sum x | sum + (x - i).abs
    best_cost = min cost best_cost
  print best_cost

  // This is a block constant.  It implements the fact that 1 + 2 + ... + n ==
  // n * (n + 1) / 2.
  cost_block := : | sum x i |
    a := (x - i).abs
    cost := (a * (a + 1)) / 2
    sum + cost

  best_cost2 := crabs.reduce --initial=0: | sum x | cost_block.call sum x right
  for i := left; i < right; i++:
    cost := crabs.reduce --initial=0: | sum x | cost_block.call sum x i
    best_cost2 = min cost best_cost2
  print best_cost2
