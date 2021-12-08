import .file as file
import reader show BufferedReader

// https://adventofcode.com/2021/day/8
main:
  reader := BufferedReader
    file.Stream.for_read "8.txt"

  displays := {:}
  while line := reader.read_line:
    i := line.index_of " | "
    displays[line[..i]] = line[i + 3..]

  UNIQUE_SIZES ::= {2: 1, 3: 7, 4: 4, 7: 8}

  count := 0
  displays.do: | all_seen current |
    four_digits := current.split " "
    all_seen.split " ": | seen |
      if UNIQUE_SIZES.contains seen.size:
        four_digits.do: if it.size == seen.size: count++
  print count

  key := List 10

  sum := 0
  displays.do: | all_seen current |
    // Populate the key with the easy ones.
    all_seen.split " ": | seen |
      bits := str_to_bits seen
      if UNIQUE_SIZES.contains seen.size:
        key[UNIQUE_SIZES[seen.size]] = bits

    // The segments 4 has, that 1 doesn't have:
    four_minus_one := key[4] & ~key[1]

    all_seen.split " ": | seen |
      bits := str_to_bits seen
      if seen.size == 5:
        if bits & key[1] == key[1]:
          key[3] = bits  // 3 has both the segments from 1
        else if bits & four_minus_one == four_minus_one:
          key[5] = bits  // 5 has both the segments that 4 has that 1 doesn't have.
        else:
          key[2] = bits  // 2 is the last of the 5-segment digits.
      else if seen.size == 6:
        inverted := bits ^ 0b111_1111  // Find the segment that is missing.
        if inverted & key[1] != 0:
          key[6] = bits  // 6 is missing one of the digits from 1.
        else if inverted & four_minus_one != 0:
          key[0] = bits  // 0 is missing one of the digits that 4 has, but 1 doesn't have.
        else:
          key[9] = bits  // 9 is the last of the 6-segment digits.

    number := 0
    four_digits := current.split " ": | digit |
      number *= 10
      bits := str_to_bits digit
      number += key.index_of bits
    sum += number
  print sum

LETTERS ::= ["a", "b", "c", "d", "e", "f", "g"]

str_to_bits str/string -> int:
  segments := List str.size: str[it] - 'a'
  return segments.reduce --initial=0: | bits segment |
    bits | (1 << segment)
