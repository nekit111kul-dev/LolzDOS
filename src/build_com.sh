#!/bin/sh
# Assembles src/*.s into ../disk_c/*.COM using GNU binutils (no nasm needed)
cd "$(dirname "$0")"
for f in snake view now; do
  as --32 -o $f.o $f.s || exit 1
  ld -m elf_i386 -Ttext=0x100 --oformat binary -o ../disk_c/$(echo $f | tr a-z A-Z).COM $f.o || exit 1
  rm -f $f.o
done
ls -l ../disk_c/*.COM
