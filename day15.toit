import .file as file
import reader show BufferedReader

grid := []

main:
  reader := BufferedReader
    file.Stream.for_read "15.txt"

  while line := reader.read_line:
    grid.add
      ByteArray line.size: line[it] - '0'

  H := grid.size
  W := grid[0].size

  HUGE := 1_000_000

  solve W H: | x y |
    if not 0 <= x < W:
      HUGE
    else if not 0 <= y < H:
      HUGE
    else:
      grid[y][x]

  solve (W * 5) (H * 5): | x y |
    if not 0 <= x < W * 5:
      HUGE
    else if not 0 <= y < H * 5:
      HUGE
    else:
      offset := x / W + y / H
      base := grid[y % H][x % W]
      raw := base + offset
      ((raw - 1) % 9) + 1

solve width/int height/int [get] -> none:
  END := Coordinate
      width - 1
      height - 1

  frontier := {(Coordinate 0 0): 0}

  finished_places := {:}

  DIRECTIONS := [
    [1, 0],
    [-1, 0],
    [0, 1],
    [0, -1],
  ]

  for limit := 0; true; limit++:
    new_frontier := {:}
    frontier.do: | coordinate score |
      x := coordinate.x
      y := coordinate.y
      still_in_play := false
      DIRECTIONS.do:
        nx := x + it[0]
        ny := y + it[1]
        neighbour := Coordinate nx ny
        if not frontier.contains neighbour:
          if not finished_places.contains neighbour:
            still_in_play = true
            danger := score + (get.call nx ny)
            if danger <= limit: improve new_frontier neighbour danger
      if limit - score < 10 and still_in_play:
        improve new_frontier coordinate score
      else:
        improve finished_places coordinate score
    if new_frontier.contains END:
      print new_frontier[END]
      return
    frontier = new_frontier

improve map/Map coordinate/Coordinate score/int -> none:
  if not map.contains coordinate:
    map[coordinate] = score
  else if map[coordinate] > score:
    map[coordinate] = score

class Coordinate:
  x /int
  y /int

  constructor .x .y:

  hash_code -> int:
    return x * 3991 + y * 5643

  operator == other -> bool:
    return x == other.x and y == other.y

  stringify -> string:
    return "[$x,$y]"
