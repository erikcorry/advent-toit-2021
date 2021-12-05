import .file as file

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
  lines := (file.read_content "3.txt").to_string.split "\n"
  lines.remove_last

  oxygen := find lines: | zeros ones value position |
    (ones >= zeros) == (value[position] == '1')

  co2 := find lines: | zeros ones value position |
    (ones < zeros) == (value[position] == '1')

  print oxygen * co2

find lines/List [criterion]:
  lines[0].size.repeat: | position |
    ones := lines.reduce --initial=0: | sum line | sum + (line[position] & 1)
    lines = lines.filter: criterion.call lines.size - ones ones it position
    if lines.size == 1:
      return (List lines[0].size: lines[0][it]).reduce --initial=0: | acc char |
        (acc << 1) | char & 1
  throw "Bad input"
