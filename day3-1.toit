import .file as file
import reader show BufferedReader

/**
Each line has a binary number of the same length.
Binary number 'gamma' has a '1' in a given column iff most bits of the input
  have a '1' in the corresponding column.
Binary number 'epsilon' has a '1' in a given column iff most bits of the input
  have a '0' in the corresponding column.
The result is gamma * epsilon.
*/
main:
  reader := BufferedReader
    file.Stream.for_read "3.txt"

  first_line := reader.read_line
  
  width := first_line.size
  one_counts := List width: 0

  accumulate one_counts first_line

  line_count := 1
  while line := reader.read_line:
    accumulate one_counts line
    line_count++

  gamma := 0
  epsilon := 0
  one_counts.do:
    gamma <<= 1
    epsilon <<= 1
    if it > line_count - it:
      gamma |= 1
    else:
      epsilon |= 1
  print gamma * epsilon

accumulate one_counts/List line/string -> none:
  line.size.repeat: 
    if line[it] == '1': one_counts[it]++
