import .file as file
import reader show BufferedReader

/// Find the position and depth after a series of commands.
main:
  reader := BufferedReader
    file.Stream.for_read "2.txt"

  position := 0
  depth := 0

  while line := reader.read_line:
    command := null
    distance := 0
    line.split " ":
      if command:
        distance = int.parse it
      else:
        command = it
    if command == "forward":
      position += distance
    else if command == "down":
      depth += distance
    else:
      depth -= distance
  print depth * position
