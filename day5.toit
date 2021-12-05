import .file as file
import math
import reader show BufferedReader

/**
Each line has a binary number of the same length.
Finding the oxygen generator rating and the CO2 scrubber rating is an interative process.
tart with the full list and consider the bits one at a time from the left.
For each bit position discard values according to the criteria until only one is left.
Criterion for the oxygen generator rating is having only the most common bit in a given
position.  For the CO2 scrubber rating it is having only the least common bit.
The result is oxygen * CO2.
*/
main:
  lines := []
  reader := BufferedReader
    file.Stream.for_read "5.txt"

  grid1 := {:}
  grid2 := {:}
  while line := reader.read_line:
    from_to := line.split " -> "
    from := from_to[0].split ","
    to   := from_to[1].split ","
    x1 := int.parse from[0]
    y1 := int.parse from[1]
    x2 := int.parse to[0]
    y2 := int.parse to[1]
    if x1 == x2:
      for y := (min y1 y2); y <= (max y1 y2); y++:
        grid1.update (Coordinate x1 y) --init=0: it + 1
        grid2.update (Coordinate x1 y) --init=0: it + 1
    else if y1 == y2:
      for x := (min x1 x2); x <= (max x1 x2); x++:
        grid1.update (Coordinate x y1) --init=0: it + 1
        grid2.update (Coordinate x y1) --init=0: it + 1
    else if (x1 - x2).abs == (y1 - y2).abs:
      y := y1
      if x1 <= x2:
        for x := x1; x <= x2; x++:
          grid2.update (Coordinate x y) --init=0: it + 1
          y += (y2 - y1).sign
      else:
        for x := x1; x >= x2; x--:
          grid2.update (Coordinate x y) --init=0: it + 1
          y += (y2 - y1).sign

  result1 := 0
  result2 := 0
  grid1.do: | coordinate value |
    if value > 1: result1++
  grid2.do: | coordinate value |
    if value > 1: result2++
  print result1
  print result2

class Coordinate:
  x /int
  y /int

  constructor .x .y:

  hash_code -> int:
    return x * 5 + y * 7

  operator == other -> bool:
    return x == other.x and y == other.y
