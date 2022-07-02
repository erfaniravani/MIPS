# MIPS
MIPS processor implementation using verilog
## Description

Three different versions of MIPS are designed. single cycle, multi cycle, and pipelined

The mulicycle processor supports the following instructions:
add, addi, sub, slt, slti, and, or, lw, sw, j, jal, jr, beq

Forwarding and hazard units guarantee the best performance

For testing the processor a program checks 20 data strating from address 1000 to 1019, and write the minimum in adress 2000 and its index in adress 2004

### Dependencies

* modelsim altera
