import .file as file
import reader show BufferedReader

/// Play bingo against the giant squid.

/// Somewhat terse version that doesn't rely on knowing the size of the boards.

CHARS_PER_NUMBER ::= 3

main:
  reader := BufferedReader
    file.Stream.for_read "4.txt"

  draw_numbers := (reader.read_line.split ",").map: int.parse it
  reader.read_line

  boards := []

  while true:
    rows := []
    line := null
    while true:
      line = reader.read_line
      if not line or line == "": break  // End of board or input.
      rows.add
        List (line.size + 1) / CHARS_PER_NUMBER:
          start := it * CHARS_PER_NUMBER
          end := start + CHARS_PER_NUMBER - 1
          while line[start] == ' ': start++
          int.parse line[start..end]  // Last expression in block gives list entry.
    boards.add
      Board rows
    if not line: break  // End of input.

  winning_score := null

  draw_numbers.do: | drawn |
    boards = boards.filter: | board |
      board.cross_out drawn
      has_won := board.has_won
      if has_won:
        if not winning_score:
          winning_score = board.score
          print winning_score * drawn
        else if boards.size == 1:
          print board.score * drawn
          return
      not has_won  // Last expression in block gives filter criterion.

class Board:
  // A list of lists.  Each sublist has numbers and nulls (crossed out numnbers).
  rows_ /List := []

  constructor .rows_:

  cross_out drawn/int -> none:
    rows_ = rows_.map: it.map: it == drawn ? null : it

  has_won -> bool:
    rows_.do: | row |
      if (row.every: it == null): return true
    rows_[0].size.repeat: | column_index |
      if (rows_.every: it[column_index] == null): return true
    return false

  score -> int:
    return rows_.reduce --initial=0: | sum row |
      sum + (row.reduce --initial=0: | column_sum value | column_sum + (value == null ? 0 : value))
