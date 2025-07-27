# <div align="center"> RISCky_CORE </div>

## Overview

Verilog implementation of a RISC-V core for FPGA. At the current state the core implements all of the basic RV32I instructions in a non-pipelined fashion.

The current core is already divided into the five major execution phases:

- (**IF**)  Instruction Fetch
- (**ID**)  Instruction Decoding
- (**EX**)  Execute
- (**MEM**) Memory
- (**WB**)  Write BACK

Each phase's implementation can be found inside the respective folder.
This structure aims to for an easier switch to a pipelined core later down the line.



### Result of simulation on test program
```bash
RV32I ISA Test Program

Testing Register-Register Ops... ############## PASSED

Testing Register-Immediate Ops... ########### PASSED

Testing load/store Operations... ##### PASSED

Testing Control Flow... ######## PASSED

Testing LUI/AUIPC Operations... ## PASSED
```

## Roadmap

0. - [x] RV32I
2. - [ ] Zicsr
3. - [ ] Zifencei
4. - [ ] RV32IM
5. - [ ] RV32IMA
6. - [ ] RV32IMAF/D (RV64G)
8. - [ ] RV32IMADC (RV64GC)

## Hardware

The hardware target is an FPGA TangPrimer 20k, but developement is mainly focused towards working simulation at the moment. 

## Toolchain

- For FPGA building toolchain is based on the [OSS-CAD-SUITE](https://github.com/YosysHQ/oss-cad-suite-build)
- For simulation [iverilog](https://github.com/steveicarus/iverilog) is used

## Sources

- https://github.com/sipeed/sipeed_wiki/tree/main/docs/hardware/en/tang/tang-primer-20k
- https://github.com/sipeed/TangPrimer-20K-example
- https://github.com/YosysHQ/apicula/wiki
- https://chipmunklogic.com/digital-logic-design/designing-pequeno-risc-v-cpu-from-scratch-part-4-fetch-unit/
- https://pyjamabrah.com/posts/writing-a-risc-v-cpu/
- https://vhdlwhiz.com/how-the-axi-style-ready-valid-handshake-works/
- https://zipcpu.com/blog/2021/08/28/axi-rules.html
- https://github.com/BrunoLevy/learn-fpga/blob/master/FemtoRV/TUTORIALS/FROM_BLINKER_TO_RISCV/README.md
- https://fpgacpu.ca/fpga/handshake.html
- https://www.asic-world.com/verilog/index.html
- https://hdlbits.01xz.net/wiki/Main_Page
- https://gitea.auro.re/higepi/Projet_SETI_RISC-V/raw/branch/main/Doc/Design_and_Implementation_of_a_RISC_V_Processor_on_FPGA.pdf
- https://v2kparse.sourceforge.net/includes.pdf
- https://www.01signal.com/verilog-design/arithmetic/signed-wire-reg/
- https://cva6.readthedocs.io/en/latest/01_cva6_user/RISCV_Instructions_RV32I.html
- https://www.ustcpetergu.com/MyBlog/experience/2021/07/09/about-riscv-testing.html
- https://riscv.github.io/riscv-isa-manual/snapshot/unprivileged/
- https://riscv.github.io/riscv-isa-manual/snapshot/privileged/
- https://www.fpga4fun.com/SD1.html
- https://electrobinary.blogspot.com/2020/06/control-and-status-registers-csr.html
- https://electrobinary.blogspot.com/p/verilog.html


- https://github.com/nand2mario/nestang/issues/2
- https://github.com/trabucayre/openFPGALoader/issues/300