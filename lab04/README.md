# CAs Lab 04
Laboratory 04 of the course Computer Architectures at Politecnico di Torino, academic year 2019/2020.<br/>

Considering a MIPS architecture with the following characteristics:
- Integer ALU: 1 clock cycle
- Data memory: 1 clock cycle
- FP arithmetic unit: pipelined, 2 clock cycles
- FP multiplier unit: pipelined, 6 clock cycles
- FP divider unit: not pipelined, 10 clock cycles

Assume also:
- branch delay slot corresponding to 1 clock cycle,  branch delay slot not enabled
- data forwarding enabled
- EXE stage could be completed also in out-of-order fashion.

Given the codes provided, esteem the number of clock cycles needed for completion.<br/>
Also, fill up the tables with the pipeline stages at each clock cycle (this is needed only for one iteration of the loop).
