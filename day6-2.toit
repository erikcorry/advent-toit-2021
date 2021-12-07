import .file as file
import reader show BufferedReader

main:
  // Construct a Stream object using the named constructor `for_read`:
  stream := file.Stream.for_read "6.txt"
  // Construct a BufferedReader (we don't use the 'new' keyword):
  reader := BufferedReader stream
  // The two-argument List constructor takes a size and an initial value:
  fish := List 9 0
  // The file has only one line.  The `split` method on strings takes a block
  // argument.
  reader.read_line.split ",":
    // These two lines are the block (lambda) argument to split.
    // Since we didn't name the parameter for the block it gets the default
    // name, `it``:
    age := int.parse it
    fish[age]++
  
  // Repeat is just a method on the `int` class that takes a block.
  256.repeat:
    // Two-argument List constructor again.
    new_fish := List 9 0
    // This time we name the parameter to the block so it's called `age`
    // instead of `ìt``.
    fish.size.repeat: | age |
      if age == 0:
        new_fish[8] += fish[age]
        new_fish[6] += fish[age]
      else:
        new_fish[age - 1] += fish[age]
    // Use the single-equals assignment `=` instead of the colon-equals
    // declaration `:=` of a new variable:
    fish = new_fish
  // There's a single argument to the print function.  We put it on its own
  // line, which is a prettier alternative to surrounding it with parentheses.
  // We use the functional `reduce` method on List in order to sum up the list
  // elements.  The `reduce` method takes a block argument.
  print
    fish.reduce --initial=0: | s x |  // The block takes two arguments, which we name s and x.
      s + x                           // The last expression in the block determines the value.
