import .file as file
import reader show BufferedReader

main:
  reader := BufferedReader
    file.Stream.for_read "6.txt"
  fish := (reader.read_line.split ",").map: int.parse it

  80.repeat:
    new_fish := []
    fish = fish.map:
      if it == 0:
        new_fish.add 8
        6
      else:
        it - 1
    fish = fish + new_fish
  print fish.size
