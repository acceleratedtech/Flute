# Purge Test

This is a test for testing the purge instruction.

The purge instruction is encoded as any CSRRX instruction using `0x7c9` as the CSR number.

The test is not self-checking, so you have to run the program in simulation and check debug messages generated from verbosity level-2.
If you are running the `sized_pointer_verilator` simulator, you can get verbosity level-2 debug messages by adding the command line argument `+v2` to the simulator.

For the first phase of the test, we are making sure the purge instruction flushes the caches.
This is checked using self modifying code.
If the purge instruction does not correctly flush the caches, the processor will get stuck in an infinite loop at either fail1 or fail2.

The second phase of the test makes sure the purge instruction correctly removes predictions from the branch predictor.
The processor runs a loop of taken branches, and after a few iterations, a purge instruction is executed.
In the first loop iteration, all the branches are incorrectly predicted to be not-taken.
After the first iteration, all the branches are correctly predicted until the purge instruction is executed.
In the iteration after the purge instruction, all the branches are incorrectly predicted to be not-taken again, and then all later branches are correctly predicted again.
