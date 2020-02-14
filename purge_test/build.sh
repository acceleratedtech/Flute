#!/bin/bash
set -e
riscv64-linux-gnu-as purge_test.S -o purge_test.o
riscv64-linux-gnu-ld -T flute.ld -o purge_test purge_test.o
riscv64-linux-gnu-objdump -d purge_test > purge_test.dump
make -C ../Tests/elf_to_hex
../Tests/elf_to_hex/elf_to_hex purge_test Mem.hex
