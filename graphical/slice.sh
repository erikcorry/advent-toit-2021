#!/bin/sh

rm sub.toit

for y in 0 16 32 48 64 80 96 112 128 144 160 176
do
  for x in 0 64 128 192 256
  do
    convert sub2.png -crop 64x16+$x+$y sub$x-$y.png
    qoiconv-main sub$x-$y.png sub$x-$y.qoi
    echo "SUB_${x}_$y ::= #[" >> sub.toit
    od -Ax -t x1 sub$x-$y.qoi | sed 's/^[^ ]\+//' | sed '/^$/d' | sed 's/ / 0x/g' | sed 's/ //' | sed 's/$/,/' | sed 's/ /, /g' | sed 's/^/    /' >> sub.toit
    echo "]" >> sub.toit
  done
done
y=192
for x in 0 64 128 192 256
do
  convert sub2.png -crop 64x3+$x+$y sub$x-$y.png
  qoiconv-main sub$x-$y.png sub$x-$y.qoi
  echo "SUB_${x}_$y ::= #[" >> sub.toit
  od -Ax -t x1 sub$x-$y.qoi | sed 's/^[^ ]\+//' | sed '/^$/d' | sed 's/ / 0x/g' | sed 's/ //' | sed 's/$/,/' | sed 's/ /, /g' | sed 's/^/    /' >> sub.toit
  echo "]" >> sub.toit
done
echo "SUB ::= [" >> sub.toit
for y in 0 16 32 48 64 80 96 112 128 144 160 176 192
do
  echo "    [SUB_0_$y, SUB_64_$y, SUB_128_$y, SUB_192_$y, SUB_256_$y,]," >> sub.toit
done
echo "]" >> sub.toit
