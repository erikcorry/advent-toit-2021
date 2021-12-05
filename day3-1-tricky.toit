import .file as file
import reader show BufferedReader

/**
Each line has a binary number of the same length.
Binary number 'gamma' has a '1' in a given column iff most bits of the input
  have a '1' in the corresponding column.
Binary number 'epsilon' has a '1' in a given column iff most bits of the input
  have a '0' in the corresponding column.
The result is gamma * epsilon.

This implementation is deliberately written in an obscure style.
Can you see how it works?
*/
main:
  reader := BufferedReader
    file.Stream.for_read "3.txt"

  first_line := reader.read_line
  line_count := 1
  
  width := first_line.size
  one_counts := List width: first_line[it] & 1

  while line := reader.read_line:
    line.size.repeat:
      one_counts[it] += line[it] & 1
    line_count++

  line_count >>= 1
  gamma := one_counts.reduce --initial=0: | accumulator count |
    accumulator << 1 | line_count - count >> 63 & 1
    
  epsilon := gamma ^ (1 << width) - 1
  print gamma * epsilon
