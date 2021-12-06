import .file as file
import reader show BufferedReader

main:
  reader := BufferedReader
    file.Stream.for_read "6.txt"
  fish := List 9 0
  reader.read_line.split ",":
    age := int.parse it
    fish[age]++
  
  256.repeat:
    new_fish := List 9 0
    fish.size.repeat: | age |
      if age == 0:
        new_fish[8] += fish[age]
        new_fish[6] += fish[age]
      else:
        new_fish[age - 1] += fish[age]
    fish = new_fish
  print
    fish.reduce --initial=0: | s x | s + x
