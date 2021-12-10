import .file as file
import reader show BufferedReader

SCORES ::= {
    ')': 3,
    ']': 57,
    '}': 1197,
    '>': 25137,
}

CLOSERS ::= {
    '(': ')',
    '[': ']',
    '{': '}',
    '<': '>',
}

main:
  reader := BufferedReader
    file.Stream.for_read "10.txt"

  score := 0
  completer_scores := []
  while line := reader.read_line:
    completer_scorer := CompleterScorer
    result := recurse line 0 null completer_scorer
    if result is Score:
      score += (result as Score).score
    else:
      completer_scores.add completer_scorer.score

  completer_scores.sort --in_place: | a b | a - b
      
  print score
  print completer_scores[completer_scores.size / 2]

// Returning score: Line had wrong closer
// Returning position at end: Count up completer
// Returning position elsewhere: Keep going.
recurse line/string pos/int expect/int? completer/CompleterScorer -> Result:
  if pos == line.size:
    if expect != null: completer.add expect
    return Position pos
  char := line[pos]
  if char == expect: return Position pos + 1
  if CLOSERS.contains char: 
    result := recurse line pos + 1 CLOSERS[char] completer
    if result is Score:
      return result
    else:
      return recurse line ((result as Position).position) expect completer
  return Score
    SCORES[char]

interface Result:

class Score implements Result:
  score /int
  constructor .score:

class Position implements Result:
  position /int
  constructor .position:

COMPLETE ::= {
    ')': 1,
    ']': 2,
    '}': 3,
    '>': 4,
}

class CompleterScorer:
  score /int := 0

  add char/int -> none:
    score *= 5
    score += COMPLETE[char]
