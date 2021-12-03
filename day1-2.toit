import .file as file
import reader show BufferedReader

/// Find the number of times a sliding window of 3 samples is greater than the
/// previous sliding window of 3 samples.
main:
  reader := BufferedReader
    file.Stream.for_read "1.txt"

  sliding_window := Deque

  sum /int? := 0
  count := 0

  while line := reader.read_line:
    current := int.parse line
    if sliding_window.size == 3:
      removed := sliding_window.remove_first
      if removed < current:
        count++
    sum += current
    sliding_window.add current

  print count
