import .file as file
import reader show BufferedReader

/// Find the number of times the sample is greater than the previous sample.
main:
  reader := BufferedReader
    file.Stream.for_read "1.txt"

  previous := null
  count := 0

  while line := reader.read_line:
    current := int.parse line
    if previous and current > previous: count++
    previous = current
  print count

