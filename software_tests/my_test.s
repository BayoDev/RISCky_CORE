
.equ UART, 0x680

.global _start

__start:

    li sp,0x1000

    lui a0, %hi(welcome_msg)
    addi a0, a0, %lo(welcome_msg)
    call print_string

    call test_reg_to_reg
    lui a0, %hi(passed_msg)
    addi a0, a0, %lo(passed_msg)
    call print_string

    inf_loop:
    j inf_loop
    

test_reg_to_reg:
    addi sp, sp, -4
    sw ra, 0(sp)

    lui a0, %hi(regreg_msg)
    addi a0, a0, %lo(regreg_msg)
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
    # 0b11110000 >> 2 = 0b11111100 (arithmetic shift)
    li t0,0b01
    li t1,2
    sll t0,t0,31 
    li t3,0b111
    sll t3,t3,29
    sra t0, t0, t1
    bne t0, t3, fail
    call print_hash

    lw ra, 0(sp)
    addi sp, sp, 4

    ret


# --------------------------------------------------
# Helper Functions
# --------------------------------------------------

print_hash:
    lui t0, %hi(UART)
    addi t0, t0, %lo(UART)
    li a0, '#'
    sw a0, 0(t0)          # 32-bit memory write
    ret

print_string:
    # a0 = string address
    lui t0, %hi(UART)
    addi t0, t0, %lo(UART)
    lbu t1, 0(a0)
1:  beqz t1, 2f
    sw t1, 0(t0)          # 32-bit memory write
    addi a0, a0, 1
    lbu t1, 0(a0)
    j 1b
2:  ret

fail:
    lui a0, %hi(failed_msg)
    addi a0, a0, %lo(failed_msg)
    call print_string
    infloop2:
    j infloop2

# --------------------------------------------------
# Data Section
# --------------------------------------------------
test_data:
    .word 0
    .word 0
    .word 0

welcome_msg:
    .asciz "\nRV32I ISA Test Program\n"

regimm_msg:
    .asciz "\nTesting Register-Immediate Ops... "

regreg_msg:
    .asciz "\nTesting Register-Register Ops... "

memops_msg:
    .asciz "\nTesting Memory Operations... "

cflow_msg:
    .asciz "\nTesting Control Flow... "

passed_msg:
    .asciz " PASSED\n"

failed_msg:
    .asciz " FAILED\n"

complete_msg:
    .asciz "\nAll tests completed successfully!\n"

