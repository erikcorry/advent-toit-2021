import .file as file
import reader show BufferedReader

NEIGHBOURS ::= [
  [-1, -1],
  [ 0, -1],
  [ 1, -1],
  [ 1,  0],
  [ 1,  1],
  [ 0,  1],
  [-1,  1],
  [-1,  0],
]

increment octopusses/List x/int y/int neighbour/List --even_at_zero=false -> none:
  x += neighbour[0]
  y += neighbour[1]
  if 0 <= y < octopusses.size:
    if 0 <= x < octopusses[y].size:
      if even_at_zero or octopusses[y][x] != 0:
        octopusses[y][x]++

main:
  reader := BufferedReader
    file.Stream.for_read "11.txt"

  octopusses := []
  while line := reader.read_line:
    octopusses.add
      (line.split "").map: int.parse it
  flashes := 0
  first_printed := false
  gen := 0
  while gen < 100 or not first_printed:
    octopusses.size.repeat: | y |
      octopusses[y].size.repeat: | x |
        octopusses[y][x]++
    gen_flashes := 0
    while true:
      stage_flashes := 0
      octopusses.size.repeat: | y |
        octopusses[0].size.repeat: | x |
          energy := octopusses[y][x]
          if energy > 9:
            stage_flashes++
            NEIGHBOURS.do:
              increment octopusses x y it
            octopusses[y][x] = 0
      if stage_flashes == 0: break
      gen_flashes += stage_flashes
    gen++
    if not first_printed and gen_flashes == octopusses.size * octopusses[0].size:
      first_printed = true
      print "All flashed at $gen"
    flashes += gen_flashes
    if gen == 100: print "$flashes flashes after gen 100"
