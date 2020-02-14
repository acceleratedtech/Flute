# Sized Poniter Verilator Simulation

This folder contains a Makefile to create a Verilator simulator for the sized pointer tag policy that does not depend on GDB.

Instead the Makefile produces a simulation executable called `exe_HW_sim`.
This executable expects a `Mem.hex` file in the local directory containing the data to load in memory from 0x80000000 to 0x90000000.
This file can be generated from an elf file using the `elf_to_hex` tool in `Tests/elf_to_hex`.

An example test program can be found in `purge_test`.
You can use `purge_test/build.sh` to compile the program and create `Mem.hex`.

The simulation executable takes some command line arguments.
- `+v1` sets the verbosity level to 1. This prints a trace of the instructions executed by the processor.
- `+v2` sets the verbosity level to 2. This prints the state of the pipeline in each clock cycle.
- `+tohost` sets the processor to watch the tohost variable defined in `symbol_table.txt` (this file is also produced by `elf_to_hex`).
- `+trace` enables dumping a VCD file from the simulation. This requires modifications to `builds/Resources/Include_verilator.mk`. The line containing --trace must be uncommented and the desired trace depth must be set in that line as well.

