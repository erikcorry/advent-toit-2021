import .file as file
import reader show BufferedReader

main:
  source := BitSource
    NibbleSource
      file.read_content "16.txt"

  score_keeper := ScoreKeeper

  print
    read_packet source score_keeper

  print score_keeper.version_sum

class ScoreKeeper:
  version_sum := 0

OPERATORS ::= [
  (:: | a b | a + b),
  (:: | a b | a * b),
  (:: | a b | min a b),
  (:: | a b | max a b),
  (:: throw "packet 4"),
  (:: | a b | a > b ? 1 : 0),
  (:: | a b | a < b ? 1 : 0),
  (:: | a b | a == b ? 1 : 0),
]

read_packet source/BitSource score_keeper/ScoreKeeper -> int:
  packet_version := source.get_bits 3
  score_keeper.version_sum += packet_version
  type := source.get_bits 3
  if type == 4:
    return get_literal source
  else:
    length_type := source.get_bits 1
    if length_type == 0:
      subpacket_length := source.get_bits 15
      end := source.bits_read + subpacket_length
      first := read_packet source score_keeper
      while source.bits_read < end:
        next := read_packet source score_keeper
        first = OPERATORS[type].call first next
      return first
    else:
      number_of_subpackets := source.get_bits 11
      first := read_packet source score_keeper
      (number_of_subpackets - 1).repeat:
        next := read_packet source score_keeper
        first = OPERATORS[type].call first next
      return first

get_literal source/BitSource -> int:
  literal := 0
  while true:
    quint := source.get_bits 5
    literal <<= 4
    literal |= quint & 0b1111
    if quint & 0b1_0000 == 0:
      return literal
  
class BitSource:
  nibbles_ /NibbleSource
  accumulator_ := 0
  bits_in_accumulator_ := 0
  bits_read := 0

  constructor .nibbles_:

  get_bits amount/int -> int:
    while bits_in_accumulator_ < amount:
      accumulator_ <<= 4
      bits_in_accumulator_ += 4
      accumulator_ |= nibbles_.get

    result := accumulator_ >> (bits_in_accumulator_ - amount)
    bits_in_accumulator_ -= amount
    bits_read += amount
    accumulator_ &= (1 << bits_in_accumulator_) - 1

    return result

class NibbleSource:
  hex_ /any
  pos_ /int := 0

  constructor .hex_:

  get -> int?:
    byte := hex_[pos_++]
    if '0' <= byte <= '9': return byte - '0'
    if 'A' <= byte <= 'F': return byte + 10 - 'A'
    return null
