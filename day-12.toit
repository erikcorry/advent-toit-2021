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
        if path.end == tunnel.from and not path.visited.contains tunnel.to:
          new_path := Path.previous path --to=tunnel.to
          if tunnel.to == "end":
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
          new_path := null
          to := tunnel.to
          if not path.visited.contains to:
            new_path = Path.previous path --to=to
          else if not path.visited_twice and to != "start" and to != "end":
            new_path = Path.previous path --to=to --visited_twice=true
          if new_path:
            if tunnel.to == "end":
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

  constructor.previous .previous --to/string --.visited_twice/bool=previous.visited_twice:
    end = to
    if 'a' <= to[0] <= 'z':
      visited = {}
      visited.add_all previous.visited
      visited.add to
    else:
      visited = previous.visited

  stringify -> string:
    if not previous: return "$(%5s visited_twice) $end"
    return "$previous.stringify-$end"
