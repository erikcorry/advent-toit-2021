import .file as file
import reader show BufferedReader

// Transparent paper-folding task.
main:
  reader := BufferedReader
    file.Stream.for_read "13.txt"

  // We use a Set for the sheet of dots so that we don't have to know the size
  // ahead of time, and dots that coincide will not cause duplicates.
  sheet := Set

  while line := reader.read_line:
    if line == "": break
    // Read line in format "12,34".
    coords := (line.split ",").map: int.parse it
    sheet.add
      Coordinate coords[0] coords[1]

  printed := false

  while line := reader.read_line:
    // Read line in format "fold along x=123".
    at := int.parse line[13..]
    if line[11] == 'x':
      sheet = fold_x sheet at
    else:
      sheet = fold_y sheet at
    if not printed:
      print sheet.size
      printed = true

  // Find largest coordinates.
  height := sheet.reduce --initial=0: | a b | max a (b.y + 1)
  width := sheet.reduce --initial=0: | a b | max a (b.x + 1)

  // Make a list of ByteArrays filled with space characters.
  grid := List height:
    ByteArray width: ' '

  // Replace spaces with hashes at the points.
  sheet.do: grid[it.y][it.x] = '#'

  // Print the grid.
  grid.do: print it.to_string

fold_y sheet/Set at/int -> Set:
  result := {}
  sheet.do:
    if it.y == at:
      throw "Fold on dot"
    else if it.y < at:
      result.add it
    else:
      result.add
          Coordinate it.x (2 * at - it.y)
  return result

fold_x sheet/Set at/int -> Set:
  result := {}
  sheet.do:
    if it.x == at:
      throw "Fold on dot"
    else if it.x < at:
      result.add it
    else:
      result.add
          Coordinate (2 * at - it.x) it.y
  return result

class Coordinate:
  x /int
  y /int

  constructor .x .y:

  hash_code -> int:
    return x + y * 1000

  operator == other -> bool:
    return x == other.x and y == other.y

  stringify -> string:
    return "[$x,$y]"
