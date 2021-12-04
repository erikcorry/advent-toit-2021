import .file as file
import reader show BufferedReader

/// Play bingo against the giant squid.

ROWS_PER_BOARD ::= 5
COLS_PER_BOARD ::= 5
CHARS_PER_NUMBER ::= 3

main:
  reader := BufferedReader
    file.Stream.for_read "4.txt"

  draw_numbers := (reader.read_line.split ",").map: int.parse it

  boards := []

  while blank_line := reader.read_line:
    assert: blank_line == ""

    rows := List ROWS_PER_BOARD:
      line := reader.read_line
      row := List COLS_PER_BOARD: | x |
        start := x * CHARS_PER_NUMBER
        end := start + CHARS_PER_NUMBER - 1
        while line[start] == ' ': start++
        int.parse line[start..end]  // Last expression in block gives list entry.
      row  // Last expression in block gives list entry.

    boards.add
      Board rows  // Construct a board.

  winning_score := null

  draw_numbers.do: | drawn |
    boards = boards.filter: | board |
      board.cross_out drawn
      has_won := board.has_won
      if has_won:
        if not winning_score:
          winning_score = board.score
          print winning_score * drawn  // Winning board score.
        else if boards.size == 1:
          print board.score * drawn    // Losing board score.
          return
      not has_won  // Last expression in block gives filter criterion.

class Board:
  // A list of lists.  Each sublist has numbers and nulls (crossed out numnbers).
  rows_ /List

  constructor .rows_:

  cross_out drawn/int -> none:
    rows_.do: | row |
      row.size.repeat:
        if row[it] == drawn: row[it] = null

  has_won -> bool:
    rows_.do: | row |
      all_crossed := row.every: it == null
      if all_crossed: return true
    rows_[0].size.repeat: | column_index |
      all_crossed := rows_.every: it[column_index] == null
      if all_crossed: return true
    return false

  score -> int:
    return rows_.reduce --initial=0: | sum row |
      row_sum := row.reduce --initial=0: | column_sum value |
        value == null ? column_sum : (column_sum + value)
      sum + row_sum  // Last expression in block is result.
