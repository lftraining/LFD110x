# Introduction to RISC-V
# Embedded Application, by Eduardo Corpeño 

###################################################
# Description
#
# This code uses the embedded microcontroller
# board to implement an up/down counter.
# It counts up when button 1 is pressed and 
# down when button 0 is pressed.
# The count is shown in the seven segment display. 
# Each LED changes state with every press of its 
# related button.
###################################################

# Code Section
.text

###################################################
# Main entry point.
# The program starts here, at address 0x00000000
###################################################

main:
    # Initializations
    li t0, 0 # t0 holds the count
    li t1, 0 # t1 holds 7 segment 1 pattern (tens)
    li t2, 0 # t2 holds 7 segment 0 pattern (ones)
    li t3, 0 # t3 holds the LED values
    li t4, 0 # t4 holds the state of button 0
    li t5, 0 # t5 holds the state of button 1

    # Registers used as constants
    la s0, digit # s0 points to the digits array 
    li s1, 100   # s1 holds the constant 100  
    li s2, -1    # s2 holds the constant -1 
    li s3, 10    # s3 holds the constant 10
    
    li a2, 0xFFFFFFFF # Mask used by ecall 0x120
    
loop:
    # Load tens pattern from count into t1
    div t1, t0, s3 
    add t1, s0, t1
    lb  t1, 0(t1)

    # Load ones pattern from count into t2
    rem t2, t0, s3
    add t2, s0, t2
    lb  t2, 0(t2)

    # Put {tens,ones} pattern into a1 
    slli a1, t1, 8
    or   a1, a1, t2 

    # drive_display(a1) - Environment call 0x120
    li a0, 0x120
    ecall
    
    
    # read_buttons() - Environment call 0x122
    li a0, 0x122
    ecall

    # Get button 0 into t4 and button 1 into t5
    andi t4, a0, 0x1
    andi t5, a0, 0x2

    # Toggle whichever LED whose button was pressed
    xor t3, t3, a0

    # drive_LEDs() - Environment call 0x121
    mv a1, t3
    li a0, 0x121
    ecall

    # If button 0 was pressed, count up
    beqz t4, not_b0
    addi t0, t0, -1
not_b0:

    # If button 1 was pressed, count down
    beqz t5, not_b1
    addi t0, t0, 1
not_b1:

    # If count is 100, reset to 0
    bne t0, s1, no_reset_0
    li  t0, 0
no_reset_0:

    # If count is -1, reset to 99
    bne t0, s2, no_reset_99
    li  t0, 99
    
no_reset_99:
    # Loop forever
    j loop


# Data Section
.data

# The following are the 7 segment
# patterns for digits 0 through 9
digit:
    .byte 0b00111111  # 0
    .byte 0b00000110  # 1
    .byte 0b01011011  # 2
    .byte 0b01001111  # 3
    .byte 0b01100110  # 4
    .byte 0b01101101  # 5
    .byte 0b01111101  # 6
    .byte 0b00000111  # 7
    .byte 0b01111111  # 8
    .byte 0b01101111  # 9