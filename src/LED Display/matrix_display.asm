# Introduction to RISC-V
# LED Matrix Display, by Eduardo Corpeño 

###################################################
# Description
#
# This assembly code uses the 10x10 LED Matrix
# to print a logo you may recognize.
#
###################################################

# Code Section
.text 

###################################################
# Main entry point.
# The program starts here, at address 0x00000000
###################################################

main:
    # Initializations
    li a0, 0x100  # Environment call for LED Matrix
    la s0, logo   # Pointer to pixels array
    li s2, 0      # x coordinate
    li s3, 10     # Matrix x and y dimension

outer:
    li s1, 0      # y coordinate

inner:
    lw a2, 0(s0)     # a2 holds the current pixel
    slli a1, s2, 16  # Shift x coordinate in a1
    or a1, a1, s1    # Join y coordinate in a1
    ecall            # Drive LED at {x,y} 

    addi s0, s0, 4    # Next pixel
    addi s1, s1, 1    # Next y
    bne s1, s3, inner # Iterate until y == 10
    
    addi s2, s2, 1    # Next x
    bne s2, s3, outer # Iterate until x == 10

    # Exit - Environment call 10
    li a0, 10
    ecall


# Constant Definitions
# These are the colors used by the logo in 
# RGB format: color =  0x00RRGGBB 

.equ black  0x00000000
.equ yellow 0x00F6B21A
.equ blue   0x002A3172


# Data Section
.data

# The following are the logo pixels,
# specified column by column
logo:

# Column 0
.word black
.word blue
.word blue
.word blue
.word blue
.word blue
.word blue
.word blue
.word blue
.word blue

# Column 1
.word black
.word blue
.word blue
.word blue
.word blue
.word black
.word black
.word blue
.word blue
.word blue

# Column 2
.word black
.word blue
.word blue
.word blue
.word blue
.word black
.word black
.word black
.word blue
.word blue

# Column 3
.word black
.word black
.word blue
.word blue
.word black
.word black
.word yellow
.word black
.word black
.word blue

# Column 4
.word yellow
.word black
.word black
.word black
.word black
.word yellow
.word yellow
.word yellow
.word black
.word black

# Column 5
.word yellow
.word yellow
.word yellow
.word yellow
.word yellow
.word yellow
.word yellow
.word yellow
.word yellow
.word black

# Column 6
.word yellow
.word yellow
.word yellow
.word yellow
.word yellow
.word yellow
.word yellow
.word yellow
.word black
.word black

# Column 7
.word yellow
.word yellow
.word yellow
.word yellow
.word yellow
.word yellow
.word yellow
.word black
.word black
.word blue

# Column 8
.word yellow
.word yellow
.word yellow
.word yellow
.word yellow
.word yellow
.word black
.word black
.word blue
.word blue

# Column 9
.word yellow
.word yellow
.word yellow
.word yellow
.word yellow
.word black
.word black
.word blue
.word blue
.word blue
