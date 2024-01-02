# Introduction to RISC-V
# Terminal Interface, by Eduardo Corpeño 

###################################################
# Description
#
# This code asks the user's name in the console 
# and responds with a message using that name.
###################################################

# Data Section
.data
prompt:   .string   "Hey, what's your name?\n" 
response: .string   "\nIt's good to meet you, " 
name:     .string   "                       "

# Code Section
.text 

###################################################
# Main entry point.
# The program starts here, at address 0x00000000
###################################################

main:
    # Initializations
    la t0, name  # t0 points to the name string

    # print_string(prompt) - Environment call 4
    la a1, prompt
    li a0, 4
    ecall

    # Call read_str subroutine
    jal read_str

    # print_string(response) - Environment call 4
    la a1, response
    li a0, 4
    ecall
    
    # print_string(name) - Environment call 4
    la a1, name
    li a0, 4
    ecall
    
    # print_char(a0) - Environment call 11
    li a1, '!'
    li a0, 11
    ecall
    
    li a1, '\n'
    ecall
    ecall

    # Exit - Environment call 10
    li a0, 10
    ecall
    

###################################################
# read_str subroutine
# Read input string from the console.
# This input is a line of text terminated with
# the enter keystroke.
###################################################

read_str:
    # Initializations
    li a5, 1  # a5 holds comparison value for branching

    # Enable console input - Environment call 0x130
    li a0, 0x130 
    ecall

read_char:
    # Read a character from console input - Environment call 0x131
    li  a0, 0x131 
    ecall

    # Read the result of the environment call in a0
    beq a0, a5, read_char   # If still waiting for input, keep polling
    beq a0, zero, finish    # If buffer is empty, go to finish
    
    # Handle incoming character
    sb   a1, 0(t0)        # Append input character to name string 
    addi t0, t0, 1        # Increment the name string pointer

    # Iterate to get the next character
    j read_char

finish:
    # Subroutine epilogue
    sb zero, 0(t0)  # Append null-terminator to name string
    jr ra           # Return to caller
