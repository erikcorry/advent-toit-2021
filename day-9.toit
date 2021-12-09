import .file as file
import reader show BufferedReader

get grid/List x/int y/int -> int:
  if x < 0 or y < 0: return 10
  if x >= grid[0].size: return 10
  if y >= grid.size: return 10
  return grid[y][x]

main:
  reader := BufferedReader
    file.Stream.for_read "9.txt"

  grid := []
  while line := reader.read_line:
    grid.add
      (line.split "").map: int.parse it

  danger_level := 0

  h := grid.size
  w := grid[0].size

  basin_sizes := []

  for y := 0; y < h; y++:
    for x := 0; x < w; x++:
      up    := get grid x y - 1
      down  := get grid x y + 1
      left  := get grid x - 1 y
      right := get grid x + 1 y
      current := get grid x y
      if up > current and down > current and left > current and right > current:
        danger_level += 1 + current
        basin := {Coordinate x y}
        iterations := [basin]
        while true:
          new := {}
          iterations[iterations.size - 1].do: | coord |
            ex := coord.x
            ey := coord.y
            edge := get grid ex ey
            height := get grid ex - 1 ey
            if height > edge and height < 9: new.add (Coordinate ex - 1 ey)
            height = get grid ex + 1 ey
            if height > edge and height < 9: new.add (Coordinate ex + 1 ey)
            height = get grid ex ey - 1
            if height > edge and height < 9: new.add (Coordinate ex ey - 1)
            height = get grid ex ey + 1
            if height > edge and height < 9: new.add (Coordinate ex ey + 1)
          if new.size > 0:
            iterations.add new
          else:
            break
        all := {}
        iterations.do: all.add_all it
        basin_sizes.add
          all.size

  print danger_level
  basin_sizes.sort --in_place: | a b | b - a
  print basin_sizes[0] * basin_sizes[1] * basin_sizes[2]

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
