import .file as file
import reader show BufferedReader

/**
Each line has a binary number of the same length.
Finding the oxygen generator rating and the CO2 scrubber rating is an interative process.
Start with the full list and consider the bits one at a time from the left.
For each bit position discard values according to the criteria until only one is left.
Criterion for the oxygen generator rating is having only the most common bit in a given
position.  For the CO2 scrubber rating it is having only the least common bit.
The result is oxygen * CO2.
*/
main:
  lines := []
  reader := BufferedReader
    file.Stream.for_read "3.txt"
  while line := reader.read_line:
    lines.add line

  oxygen := find lines: | zeros ones value position |
    (ones >= zeros) == (value[position] == '1')

  co2 := find lines: | zeros ones value position |
    (ones < zeros) == (value[position] == '1')

  print oxygen * co2

find l/List [criterion]:
  lines := l
  lines[0].size.repeat: | position |
    ones := lines.reduce --initial=0: | s l | s + (l[position] & 1)
    lines = lines.filter: criterion.call lines.size - ones ones it position
    if lines.size == 1:
      return (List lines[0].size: lines[0][it]).reduce --initial=0: | s c | (s << 1) | c & 1
  throw "Bad input"
