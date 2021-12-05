import .file as file
main:
  lines := (file.read_content "3.txt").to_string.split "\n"
  lines.remove_last
  oxygen := find lines: | zeros ones value position | (ones >= zeros) == (value[position] == '1')
  co2 := find lines: | zeros ones value position | (ones < zeros) == (value[position] == '1')
  print oxygen * co2
find lines/List [criterion]:
  lines[0].size.repeat: | position |
    ones := lines.reduce --initial=0: | sum line | sum + (line[position] & 1)
    lines = lines.filter: criterion.call lines.size - ones ones it position
    if lines.size == 1:
      return (List lines[0].size: lines[0][it]).reduce --initial=0: | acc char |
        (acc << 1) | char & 1
  throw "Bad input"
