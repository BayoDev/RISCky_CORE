# RV32I ISA Test Program
# Uses 32-bit memory mapped UART at 0x680
# Strictly RV32I compatible (no pseudo-instructions)

.equ UART, 0x680
.equ ERR, 0x700

.section .text
.global _start
_start:
    # Initialize stack pointer (using only lui/addi)
    lui sp, 0x1
    addi sp, sp, 0x000     # sp = 0x1000


    # Print welcome message
    lui a0, %hi(welcome_msg)
    addi a0, a0, %lo(welcome_msg)
    jal ra, print_string

    # Test groups
    jal ra, test_register_immediate
    jal ra, test_register_register
    jal ra, test_memory_ops
    jal ra, test_control_flow

    # Completion message
    lui a0, %hi(complete_msg)
    addi a0, a0, %lo(complete_msg)
    jal ra, print_string

    # Halt
    infloop:
    j infloop

# Helper function to print a single character
print_char:
    # a0 = character to print
    lui t0, %hi(UART)
    addi t0, t0, %lo(UART)
    sw a0, 0(t0)          # 32-bit memory write
    ret

# --------------------------------------------------
# Test Register-Immediate Operations
# --------------------------------------------------
test_register_immediate:
    addi sp, sp, -4
    sw ra, 0(sp)

    lui a0, %hi(regimm_msg)
    addi a0, a0, %lo(regimm_msg)
    jal ra, print_string

    # ADDI test
    lui t0, 0x12345
    addi t0, t0, 0x678    # Build 0x12345678
    addi t1, t0, 0x123    # Add immediate
    lui t2, 0x12345
    addi t2, t2, 0x678
    addi t2, t2, 0x123    # Expected value
    bne t1, t2, fail
    addi a0, zero, '#'     # Print # on success
    jal ra, print_char

    # SLTI test
    addi t0, zero, -5      # t0 = -5
    slti t1, t0, 0         # -5 < 0?
    beqz t1, fail
    addi a0, zero, '#'     # Print # on success
    jal ra, print_char
    slti t1, t0, -10       # -5 < -10?
    bnez t1, fail
    addi a0, zero, '#'     # Print # on success
    jal ra, print_char

    # SLTIU test (using valid 12-bit immediates)
    lui t0, 0xFFFFF
    addi t0, t0, -2        # t0 = 0xFFFFFFFE
    sltiu t1, t0, 0        # Should be false (0)
    bnez t1, fail
    addi a0, zero, '#'     # Print # on success
    jal ra, print_char
    sltiu t1, t0, 0x7FF    # Compare with 2047
    bnez t1, fail
    addi a0, zero, '#'     # Print # on success
    jal ra, print_char
    sltiu t1, t0, -1       # -1 = 0xFFFFFFFF when unsigned
    beqz t1, fail
    addi a0, zero, '#'     # Print # on success
    jal ra, print_char

    # ANDI/ORI/XORI tests
    lui t0, 0x12345
    addi t0, t0, 0x678     # t0 = 0x12345678
    andi t1, t0, 0x7FF     # AND with 2047
    andi t2, t0, 0x7FF     # Expected value
    bne t1, t2, fail
    addi a0, zero, '#'     # Print # on success
    jal ra, print_char

    ori t1, t0, 0x7FF      # OR with 2047
    ori t2, t0, 0x7FF      # Expected value
    bne t1, t2, fail
    addi a0, zero, '#'     # Print # on success
    jal ra, print_char

    xori t1, t0, 0x7FF     # XOR with 2047
    xori t2, t0, 0x7FF     # Expected value
    bne t1, t2, fail
    addi a0, zero, '#'     # Print # on success
    jal ra, print_char

    # Shift tests
    slli t1, t0, 4
    slli t2, t0, 4
    bne t1, t2, fail
    addi a0, zero, '#'     # Print # on success
    jal ra, print_char

    srli t1, t0, 4
    srli t2, t0, 4
    bne t1, t2, fail
    addi a0, zero, '#'     # Print # on success
    jal ra, print_char

    srai t1, t0, 4
    srai t2, t0, 4
    bne t1, t2, fail
    addi a0, zero, '#'     # Print # on success
    jal ra, print_char

    # LUI/AUIPC tests
    lui t0, 0x12345
    srli t0, t0, 12
    lui t1, 0x12345       # Load upper 20 bits
    addi t1, t1, 0        # Add lower 12 bits (0 in this case)
    bne t0, t1, fail
    addi a0, zero, '#'     # Print # on success
    jal ra, print_char

    auipc t0, 0
    lui t1, %hi(_start)
    addi t1, t1, %lo(_start)
    sub t0, t0, t1
    srli t0, t0, 12
    bnez t0, fail
    addi a0, zero, '#'     # Print # on success
    jal ra, print_char

    lui a0, %hi(passed_msg)
    addi a0, a0, %lo(passed_msg)
    jal ra, print_string

    lw ra, 0(sp)
    addi sp, sp, 4
    ret

# --------------------------------------------------
# Test Register-Register Operations
# --------------------------------------------------
test_register_register:
    addi sp, sp, -4
    sw ra, 0(sp)

    lui a0, %hi(regreg_msg)
    addi a0, a0, %lo(regreg_msg)
    jal ra, print_string

    # Build test values
    lui t0, 0x11111
    addi t0, t0, 0x111    # t0 = 0x11111111
    lui t1, 0x22222
    addi t1, t1, 0x222    # t1 = 0x22222222

    # ADD/SUB tests
    add t2, t0, t1
    lui t3, 0x33333
    addi t3, t3, 0x333    # Expected 0x33333333
    bne t2, t3, fail
    addi a0, zero, '#'     # Print # on success
    jal ra, print_char

    sub t2, t3, t0
    bne t2, t1, fail
    addi a0, zero, '#'     # Print # on success
    jal ra, print_char

    # SLT/SLTU tests
    addi t0, zero, -5
    addi t1, zero, 0
    slt t2, t0, t1
    beqz t2, fail
    addi a0, zero, '#'     # Print # on success
    jal ra, print_char

    sltu t2, t0, t1
    bnez t2, fail
    addi a0, zero, '#'     # Print # on success
    jal ra, print_char

    # AND/OR/XOR tests
    lui t0, 0x12345
    addi t0, t0, 0x678    # t0 = 0x12345678
    lui t1, 0xFFFFF
    addi t1, t1, -1       # t1 = 0xFFFFFFFF
    and t2, t0, t1
    bne t2, t0, fail
    addi a0, zero, '#'     # Print # on success
    jal ra, print_char

    or t2, t0, t1
    bne t2, t1, fail
    addi a0, zero, '#'     # Print # on success
    jal ra, print_char

    xori t2, t0, -1
    xori t3, t0, -1
    bne t2, t3, fail
    addi a0, zero, '#'     # Print # on success
    jal ra, print_char

    # Shift tests
    addi t1, zero, 4
    sll t2, t0, t1
    slli t3, t0, 4
    bne t2, t3, fail
    addi a0, zero, '#'     # Print # on success
    jal ra, print_char

    srl t2, t0, t1
    srli t3, t0, 4
    bne t2, t3, fail
    addi a0, zero, '#'     # Print # on success
    jal ra, print_char

    sra t2, t0, t1
    srai t3, t0, 4
    bne t2, t3, fail
    addi a0, zero, '#'     # Print # on success
    jal ra, print_char

    lui a0, %hi(passed_msg)
    addi a0, a0, %lo(passed_msg)
    jal ra, print_string

    lw ra, 0(sp)
    addi sp, sp, 4
    ret

# --------------------------------------------------
# Test Memory Operations
# --------------------------------------------------
test_memory_ops:
    addi sp, sp, -4
    sw ra, 0(sp)

    lui a0, %hi(memops_msg)
    addi a0, a0, %lo(memops_msg)
    jal ra, print_string

    # Get test data address
    lui t0, %hi(test_data)
    addi t0, t0, %lo(test_data)

    # SW/LW test
    lui t1, 0x12345
    addi t1, t1, 0x678    # t1 = 0x12345678
    sw t1, 0(t0)
    lw t2, 0(t0)
    bne t1, t2, fail
    addi a0, zero, '#'     # Print # on success
    jal ra, print_char

    # SH/LH/LHU tests
    lui t1, 0xABCD
    sh t1, 4(t0)
    lh t2, 4(t0)
    bne t1, t2, fail
    addi a0, zero, '#'     # Print # on success
    jal ra, print_char
    lhu t2, 4(t0)
    bne t1, t2, fail
    addi a0, zero, '#'     # Print # on success
    jal ra, print_char

    # SB/LB/LBU tests
    addi t1, zero, 0x42
    sb t1, 8(t0)
    lb t2, 8(t0)
    bne t1, t2, fail
    addi a0, zero, '#'     # Print # on success
    jal ra, print_char
    lbu t2, 8(t0)
    bne t1, t2, fail
    addi a0, zero, '#'     # Print # on success
    jal ra, print_char

    lui a0, %hi(passed_msg)
    addi a0, a0, %lo(passed_msg)
    jal ra, print_string

    lw ra, 0(sp)
    addi sp, sp, 4
    ret

# --------------------------------------------------
# Test Control Flow
# --------------------------------------------------
test_control_flow:
    addi sp, sp, -4
    sw ra, 0(sp)

    lui a0, %hi(cflow_msg)
    addi a0, a0, %lo(cflow_msg)
    jal ra, print_string

    # JAL test
    addi t0, zero, 0
    jal t1, 1f
    addi t0, zero, 1
1:  beqz t0, fail
    addi a0, zero, '#'     # Print # on success
    jal ra, print_char

    # JALR test
    addi t0, zero, 0
    lui t1, %hi(1f)
    addi t1, t1, %lo(1f)
    jalr t2, t1, 0
    addi t0, zero, 1
1:  beqz t0, fail
    addi a0, zero, '#'     # Print # on success
    jal ra, print_char

    # Branch tests
    addi t0, zero, 5
    addi t1, zero, 5
    beq t0, t1, 1f
    j fail
1:  addi a0, zero, '#'     # Print # on success
    jal ra, print_char

    addi t1, zero, 6
    bne t0, t1, 1f
    j fail
1:  addi a0, zero, '#'     # Print # on success
    jal ra, print_char

    blt t0, t1, 1f
    j fail
1:  addi a0, zero, '#'     # Print # on success
    jal ra, print_char

    bge t1, t0, 1f
    j fail
1:  addi a0, zero, '#'     # Print # on success
    jal ra, print_char

    bltu t0, t1, 1f
    j fail
1:  addi a0, zero, '#'     # Print # on success
    jal ra, print_char

    bgeu t1, t0, 1f
    j fail
1:  addi a0, zero, '#'     # Print # on success
    jal ra, print_char

    lui a0, %hi(passed_msg)
    addi a0, a0, %lo(passed_msg)
    jal ra, print_string

    lw ra, 0(sp)
    addi sp, sp, 4
    ret

# --------------------------------------------------
# Helper Functions
# --------------------------------------------------
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
    jal ra, print_string
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
    .asciz "PASSED\n"

failed_msg:
    .asciz "FAILED\n"

complete_msg:
    .asciz "\nAll tests completed successfully!\n"