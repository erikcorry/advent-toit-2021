import .file as file
import reader show BufferedReader
import bytes show Buffer

inc map/Map key --by/int=1 -> none:
  map[key] = (map.get key --if_absent=(: 0)) + by

main:
  reader := BufferedReader
    file.Stream.for_read "14.txt"

  polymer := reader.read_line

  pair_counts := {:}

  for x := 0; x < polymer.size - 1; x++:
    inc pair_counts polymer[x..x + 2]
  last_char := polymer[polymer.size - 1]

  reader.read_line

  insertion_rules := {:}

  while line := reader.read_line:
    parts := line.split " -> "
    lhs /string := parts[0]
    rhs /string := parts[1]
    insertion_rules[lhs] = [
        lhs[0..1] + rhs,
        rhs + lhs[1..2],
    ]

  step_function := : | previous_pair_counts |
    new_pair_counts := {:}
    previous_pair_counts.do: | pair count |
      if insertion_rules.contains pair:
        insertion_rules[pair].do:
          inc new_pair_counts it --by=count
      else:
        inc new_pair_counts pair --by=count
    new_pair_counts  // Last expression is return value of block.

  10.repeat:
    pair_counts = step_function.call pair_counts

  print_most_minus_least_frequent pair_counts last_char

  30.repeat:
    pair_counts = step_function.call pair_counts

  print_most_minus_least_frequent pair_counts last_char

print_most_minus_least_frequent pair_counts/Map last_char/int -> none:
  element_counts := {:}

  pair_counts.do: | pair count |
    first := pair[0]
    inc element_counts first --by=count
  inc element_counts last_char
  biggest := element_counts.values.reduce: | a b | max a b
  smallest := element_counts.values.reduce: | a b | min a b
  print biggest - smallest
