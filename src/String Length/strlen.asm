# Introduction to RISC-V
# strlen, by Eduardo Corpeño 

###################################################
# Description
#
# This assembly code roughly implements the 
# following C algorithm to calculate the length of 
# a string.
#
#   int count = 0;
#   char *str = “RISC-V is the bomb!!!”;
#
#   int main(){
#       while(*str){
#           count++;
#           str++;
#       }
#       print(count);
#   }
###################################################

# Data Section
.data
count: .word   0
str:   .string "RISC-V is the bomb!!!"


# Code Section
.text 

###################################################
# Main entry point.
# The program starts here, at address 0x00000000
###################################################

main:
    # Initializations
    la   t0, count   # t0 points to count
    lw   t1, 0(t0)   # t1 implements count
    la   t2, str     # t2 points to *str

while:
    lb   t3, 0(t2)   # Load *str into t3
    beqz t3, finish  # If *str==0, go to finish
    addi t1, t1, 1   # count++;
    addi t2, t2, 1   # str++;
    j    while

finish:
    sw t1, 0(t0)     # Store t1 into count

    # print_int(count) - Environment call 1
    mv a1, t1
    li a0, 1  
    ecall           
    
    # print_char('\n') - Environment call 11
    li a1, '\n'
    li a0, 11
    ecall
    ecall

    # Exit - Environment call 10
    li a0, 10
    ecall
    