import .file as file
import reader show BufferedReader

/// A template that shows how to read a text file and process one line
/// at a time.
main:
  reader := BufferedReader
    file.Stream.for_read "8.txt"

  displays := {:}
  while line := reader.read_line:
    i := line.index_of " | "
    displays[line[..i]] = line[i + 3..]

  count := 0
  displays.do: | all_seen current |
    four_digits := current.split " "
    all_seen.split " ": | seen |
      if seen.size == 2 or seen.size == 4 or seen.size == 3 or seen.size == 7:
        four_digits.do: if it.size == seen.size: count++
  print count

  // 2 segments
  //    1: cf
  // 3 segments
  //    7: acf
  // 4 segments
  //    4: bcdf  minus 1'< bd
  // 5 segments:
  //    2: acdeg
  //    3: acdfg  // Has both of 1's
  //    5: abdfg  // Has 4's minus 1's
  // 6 segments:
  //    6: not c  // Missing one of 1's
  //    9: not e
  //    0: not d  // Missing one of 4's minus 1's

  key := List 10

  sum := 0
  displays.do: | all_seen current |
    all_seen.split " ": | seen |
      bits := str_to_bits seen
      if seen.size == 2: key[1] = bits
      if seen.size == 3: key[7] = bits
      if seen.size == 4: key[4] = bits
      if seen.size == 7: key[8] = bits
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
      key.size.repeat:
        if key[it] == bits: number += it
    sum += number
  print sum

LETTERS ::= ["a", "b", "c", "d", "e", "f", "g"]

str_to_bits str/string -> int:
  bits := 0
  LETTERS.do:
    bits <<= 1
    if str.contains it: bits |= 1
  return bits
