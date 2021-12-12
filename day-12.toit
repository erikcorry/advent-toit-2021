import .file as file
import reader show BufferedReader

main:
  reader := BufferedReader
    file.Stream.for_read "12.txt"

  tunnels := []
  while line := reader.read_line:
    ends := line.split "-"
    tunnels.add
      Tunnel ends[0] ends[1]
    // Tunnels are bidirectional.
    tunnels.add
      Tunnel ends[1] ends[0]

  // Part 1, you can only visit small caves once.
  paths := [Path "start"]
  go_to_end := []
  while true:
    added := []
    paths.do: | path |
      tunnels.do: | tunnel |
        to := tunnel.to
        if path.end == tunnel.from and not path.visited.contains to:
          new_path := Path.previous path --end=to
          if to == "end":
            go_to_end.add new_path
          else:
            added.add new_path
    if added.size == 0:
      break
    else:
      paths = added

  print go_to_end.size

  // Part 2, only one of the small caves can be visited twice (and it can't be
  // start or end).
  paths = [Path "start"]
  go_to_end = []
  while true:
    added := []
    paths.do: | path |
      tunnels.do: | tunnel |
        if path.end == tunnel.from:
          to := tunnel.to
          if not path.visited.contains to
              or not path.visited_twice and to != "start" and to != "end":
            new_path := Path.previous path --end=to
            if to == "end":
              go_to_end.add new_path
            else:
              added.add new_path
    if added.size == 0:
      break
    else:
      paths = added

  print go_to_end.size


class Tunnel:
  from /string
  to /string

  constructor .from .to:

class Path:
  previous /Path?
  visited /Set
  end /string
  visited_twice /bool ::= false

  constructor .end:
    visited = { end }
    previous = null

  constructor.previous .previous --.end/string:
    visited_twice = previous.visited_twice or previous.visited.contains end
    if 'a' <= end[0] <= 'z':
      visited = {}
      visited.add_all previous.visited
      visited.add end
    else:
      visited = previous.visited

  stringify -> string:
    if not previous: return "$(%5s visited_twice) $end"
    return "$previous.stringify-$end"
