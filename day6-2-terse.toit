import .file as file
import reader

main:
  reader := reader.BufferedReader
    file.Stream.for_read "6.txt"
  fish := List 9 0
  reader.read_line.split ",": fish[int.parse it]++
  
  256.repeat:
    fish = List 9:
      it == 6
          ? fish[7] + fish[0]
          : fish[(it + 1) % 9]
  print
    fish.reduce: | s x | s + x
