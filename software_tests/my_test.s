
.equ UART, 0x680
.align 4 
.global __start

__start:

    li sp,0x1100

    la a0,welcome_msg
    call print_string

    call test_reg_to_reg
    call test_reg_to_imm
    call test_store_load
    call test_execution_flow
    call test_lui_auipc

    inf_loop:
    j inf_loop
    

test_reg_to_reg:
    addi sp, sp, -4
    sw ra, 0(sp)

    la a0,regreg_msg
    call print_string

    # -----------------------------------------------------------
    # ADD
    # 12 + 10 = 22
    li t0, 12
    li t1, 10
    li t3, 22
    add t0, t0, t1
    bne t0, t3, fail
    call print_hash

    # 10 + (-12) = -2
    li t0, 10
    li t1, -12
    li t3, -2
    add t0, t0, t1
    bne t0, t3, fail
    call print_hash

    # -----------------------------------------------------------
    # SUB
    # 12 - 10 = 2
    li t0, 12
    li t1, 10
    li t3, 2
    sub t0, t0, t1
    bne t0, t3, fail
    call print_hash

    # 12 - (-10) = 22
    li t0, 12
    li t1, -10
    li t3, 22
    sub t0, t0, t1
    bne t0, t3, fail
    call print_hash

    # -----------------------------------------------------------
    # AND
    # 0b1100 & 0b1010 = 0b1000
    li t0, 0b1100
    li t1, 0b1010
    li t3, 0b1000
    and t0, t0, t1
    bne t0, t3, fail
    call print_hash

    # -----------------------------------------------------------
    # OR
    # 0b1100 | 0b1010 = 0b1110
    li t0, 0b1100
    li t1, 0b1010
    li t3, 0b1110
    or t0, t0, t1
    bne t0, t3, fail
    call print_hash

    # -----------------------------------------------------------
    # XOR
    # 0b1100 ^ 0b1010 = 0b0110
    li t0, 0b1100
    li t1, 0b1010
    li t3, 0b0110
    xor t0, t0, t1
    bne t0, t3, fail
    call print_hash

    # -----------------------------------------------------------
    # SLT
    # 5 < 7 → 1
    li t0, 5
    li t1, 7
    li t3, 1
    slt t0, t0, t1
    bne t0, t3, fail
    call print_hash

    # SLT (negative case)
    # 7 < 5 → 0
    li t0, 7
    li t1, 5
    li t3, 0
    slt t0, t0, t1
    bne t0, t3, fail
    call print_hash

    # -----------------------------------------------------------
    # SLTU (Set Less Than Unsigned)
    # 5 < 7 → 1
    li t0, 5
    li t1, 7
    li t3, 1
    sltu t0, t0, t1
    bne t0, t3, fail
    call print_hash

    # SLTU (Unsigned comparison)
    # 7 < 5 → 0
    li t0, 7
    li t1, 5
    li t3, 0
    sltu t0, t0, t1
    bne t0, t3, fail
    call print_hash

    # -----------------------------------------------------------
    # SLL (Shift Left Logical)
    # 0b0001 << 2 = 0b0100
    li t0, 0b0001
    li t1, 2
    li t3, 0b0100
    sll t0, t0, t1
    bne t0, t3, fail
    call print_hash

    # -----------------------------------------------------------
    # SRL (Shift Right Logical)
    # 0b1000 >> 2 = 0b0010
    li t0, 0b1000
    li t1, 2
    li t3, 0b0010
    srl t0, t0, t1
    bne t0, t3, fail
    call print_hash

    # -----------------------------------------------------------
    # SRA (Shift Right Arithmetic)
    li t0,0b01
    li t1,2
    sll t0,t0,31 
    li t3,0b111
    sll t3,t3,29
    sra t0, t0, t1
    bne t0, t3, fail
    call print_hash

    la a0,passed_msg
    call print_string

    lw ra, 0(sp)
    addi sp, sp, 4

    ret


test_reg_to_imm:
    addi sp, sp, -4
    sw ra, 0(sp)

    la a0,regimm_msg
    call print_string

    # -----------------------------------------------------------
    # ADDI
    li t0, 15
    addi t0,t0,12
    li t3, 27
    bne t0,t3,fail
    call print_hash

    # -----------------------------------------------------------
    # XORI
    li t0, 0b1100
    li t3, 0b0110
    xori t0, t0, 0b1010
    bne t0, t3, fail
    call print_hash

    # -----------------------------------------------------------
    # ORI
    li t0, 0b1100
    li t3, 0b1110
    ori t0, t0, 0b1010
    bne t0, t3, fail
    call print_hash

    # -----------------------------------------------------------
    # ANDI
    li t0, 0b1100
    li t3, 0b1000
    andi t0, t0, 0b1010
    bne t0, t3, fail
    call print_hash

    # -----------------------------------------------------------
    # SLLI (Shift Left Logical Immediate)
    li t0, 0b0001
    li t3, 0b0100
    slli t0, t0, 2
    bne t0, t3, fail
    call print_hash

    # -----------------------------------------------------------
    # SRLI (Shift Right Logical Immediate)
    li t0, 0b1000
    li t3, 0b0010
    srli t0, t0, 2
    bne t0, t3, fail
    call print_hash

    # -----------------------------------------------------------
    # SRAI (Shift Right Arithmetic Immeditae)
    li t0,0b01
    sll t0,t0,31 
    li t3,0b111
    sll t3,t3,29
    srai t0, t0, 2
    bne t0, t3, fail
    call print_hash

    # -----------------------------------------------------------
    # SLTI
    # 5 < 7 → 1
    li t0, 5
    li t3, 1
    slti t0, t0, 7
    bne t0, t3, fail
    call print_hash

    # SLTI (negative case)
    # 7 < 5 → 0
    li t0, 7
    li t3, 0
    slti t0, t0, 5
    bne t0, t3, fail
    call print_hash

    # -----------------------------------------------------------
    # SLTIU (Set Less Than Immediate unsigned)
    # 5 < 7 → 1
    li t0, 5
    li t3, 1
    sltiu t0, t0, 7
    bne t0, t3, fail
    call print_hash

    # SLTIU (Unsigned comparison)
    # 7 < 5 → 0
    li t0, 7
    li t3, 0
    sltiu t0, t0, 5 
    bne t0, t3, fail
    call print_hash
    
    la a0,passed_msg
    call print_string

    lw ra, 0(sp)
    addi sp, sp, 4

    ret

test_store_load:

    addi sp, sp, -4
    sw ra, 0(sp)

    la a0,memops_msg
    call print_string

    # -----------------------------------------------------------
    # SB/LB
    li a0,0x1000
    li t0,0xFFF
    li t3,-1
    sb t0,0(a0)
    lb t1,0(a0)
    bne t1,t3,fail
    call print_hash

    # -----------------------------------------------------------
    # LBU
    li a0,0x1000
    li t0,0xFFF
    li t3,0xFF
    sb t0,0(a0)
    lbu t1,0(a0)
    bne t1,t3,fail
    call print_hash

    # -----------------------------------------------------------
    # SH/LH
    li a0,0x1000
    li t0,0xF555
    li t3,0xFFFFF555
    sh t0,0(a0)
    lh t1,0(a0)
    bne t1,t3,fail
    call print_hash

    # -----------------------------------------------------------
    # LHU
    li a0,0x1000
    li t0,0xF555
    li t3,0x0000F555
    sh t0,0(a0)
    lhu t1,0(a0)
    bne t1,t3,fail
    call print_hash

    # -----------------------------------------------------------
    # SW/LD
    li a0,0x1000
    li t0,0xF3F3F3F3
    mv t3,t0
    sw t0,0(a0)
    lw t1,0(a0)
    bne t1,t3,fail
    call print_hash

    la a0,passed_msg
    call print_string

    lw ra, 0(sp)
    addi sp, sp, 4

    ret

test_execution_flow:

    addi sp, sp, -4
    sw ra, 0(sp)

    la a0,cflow_msg
    call print_string

    # -----------------------------------------------------------
    # beq
    li t0,10
    li t1,15
    beq t0,t1,fail
    li t1,10
    beq t0,t1,1f
    j fail
    1:
    call print_hash

    # -----------------------------------------------------------
    # bne
    li t0,10
    li t1,10
    bne t0,t1,fail
    li t1,15
    bne t0,t1,1f
    j fail
    1:
    call print_hash

    # -----------------------------------------------------------
    # blt
    li t0,15
    li t1,-2
    blt t0,t1,fail
    li t0,-20
    blt t0,t1,1f
    j fail
    1:
    call print_hash
    
    # -----------------------------------------------------------
    # bge
    li t0,-2
    li t1,15
    bge t0,t1,fail
    li t1,-20
    bge t0,t1,1f
    j fail
    1:
    li t1,-20
    bge t0,t1,2f
    j fail
    2:
    call print_hash

    # -----------------------------------------------------------
    # bltu
    li t0,-5
    li t1,15
    bltu t0,t1,fail
    li t1,-1
    bltu t0,t1,1f
    j fail
    1:
    call print_hash

    # -----------------------------------------------------------
    # bgeu
    li t0,15
    li t1,-20
    bgeu t0,t1,fail
    li t0,-2
    bgeu t0,t1,1f
    j fail
    1:
    li t1,-2
    bgeu t0,t1,2f
    j fail
    2:
    call print_hash

    # -----------------------------------------------------------
    # jal
    jal a0,jal_test
    jal_fallback:
    j fail
    jal_test:
    # rd = PC+4
    la t0,jal_fallback 
    bne a0,t0,fail
    call print_hash

    # -----------------------------------------------------------
    # jalr
    la a1, jalr_test
    jalr a0,4(a1)
    jalr_fallback:
    j fail
    jalr_test:
    j fail
    # rd = PC+4
    la t0,jalr_fallback 
    bne a0,t0,fail
    call print_hash

    la a0,passed_msg
    call print_string

    lw ra, 0(sp)
    addi sp, sp, 4

    ret

test_lui_auipc:
    addi sp, sp, -4
    sw ra, 0(sp)

    la a0,lui_auipc_msg
    call print_string

    # -----------------------------------------------------------
    # LUI (Load Upper Immediate)
    lui t0, 0x12345
    li t3, 0x12345000
    bne t0, t3, fail
    call print_hash

    # -----------------------------------------------------------
    # AUIPC (Add Upper Immediate to PC)
    auipc_pc:
    auipc t2, 0x1     # should result in PC + 0x1000
    lui t0,0x1
    la t1, auipc_pc
    add t0,t0,t1
    bne t0, t2, fail
    call print_hash

    la a0,passed_msg
    call print_string

    lw ra, 0(sp)
    addi sp, sp, 4

    ret


# --------------------------------------------------
# Helper Functions
# --------------------------------------------------

print_hash:
    la t0,UART
    li a0, '#'
    sw a0, 0(t0)          # 32-bit memory write
    ret

print_string:
    # a0 = string address
    la t0,UART
    lbu t1, 0(a0)
1:  beqz t1, 2f
    sw t1, 0(t0)          # 32-bit memory write
    addi a0, a0, 1
    lbu t1, 0(a0)
    j 1b
2:  ret

fail:
    la a0,failed_msg
    call print_string
    infloop2:
    j infloop2

# --------------------------------------------------
# Data Section
# --------------------------------------------------

welcome_msg:
    .asciz "\nRV32I ISA Test Program\n"

regimm_msg:
    .asciz "\nTesting Register-Immediate Ops... "

regreg_msg:
    .asciz "\nTesting Register-Register Ops... "

memops_msg:
    .asciz "\nTesting load/store Operations... "

cflow_msg:
    .asciz "\nTesting Control Flow... "

lui_auipc_msg:
    .asciz "\nTesting LUI/AUIPC Operations... "

passed_msg:
    .asciz " PASSED\n"

failed_msg:
    .asciz " FAILED\n"

complete_msg:
    .asciz "\nAll tests completed successfully!\n"

