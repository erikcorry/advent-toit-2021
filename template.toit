import .file as file
import reader show BufferedReader

/// A template that shows how to read a text file and process one line
/// at a time.
main:
  reader := BufferedReader
    file.Stream.for_read "1.txt"

  while line := reader.read_line:
    current := int.parse line

    /// Do the magic here!
