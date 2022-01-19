#BY SUBMITTING THIS FILE TO CARMEN, I CERTIFY THAT I STRICTLY ADHERED TO THE
#TENURES OF THE OHIO STATE UNIVERSITY’S ACADEMIC INTEGRITY POLICY.


#function reads in values from a file and populates a structure with these values along with 
#the sum of each of the values on a line

.file "readlines.s"
.section .rodata


scanf_string:
.string "%d %d"

.globl readlines #required directive for every function
        .type readlines, @function #required directive 

.text
readlines:

	push %rbp               # save caller's %rbp
        movq %rsp, %rbp         # copy %rsp to %rbp so our stack frame is ready to use
	pushq %r12 # callee saved 
	pushq %r13
	#rdi - FILE *fptr
	#rsi - struct Record *rptr
	#rdx - int count

	movq $0,%r12 # set struct byte allignment offset to 0 to starts

        loop:

	# value 1 address
        leaq 16(%rsi),%r8 #16 bytes past the start of the struct for value 1
	addq %r12,%r8 #add this to offset address to go to the next struct

        #value 2 address
        leaq (%rsi),%r9 #p + 0 for value 2
	addq %r12,%r9

        #value 3 address
        leaq 8(%rsi),%r10#p + 8 for value 3
	addq %r12,%r10

	pushq %rdi #fptr
	pushq %rsi #rptr
	pushq %rdx #count
	
	movq $0,%rax # must set rax to 0 before print

	movq $scanf_string,%rsi #move scanf string to second param
	movq %r8,%rdx #move address of value 1 into 3rd param
	movq %r9,%rcx #move address of value 2 in 4th param
	pushq %r8 #value 1 address
	pushq %r9 #value 2 address
	pushq %r10 #value 3 address
	pushq %rdi # file pointer
	call fscanf
	popq %rdi
	popq %r10
	popq %r9
	popq %r8

	popq %rdx
        popq %rsi
        popq %rdi	


	# use 4 byte registers 
	#sign extend 
	movslq (%r8d),%r11 # puts value 1 in r11 and sign extends
	movslq (%r9d),%r13 # put value 2 in r13 and sign extend
	addq %r13,%r11 # adds r13 (which has value 2) to r11(which has value 1)
	
	movq %r11,(%r10) # put value of r11 into the correct spot in struct
	
	addq $24,%r12 # each struct is 24 bytes so add 24
	decq %rdx # decrement count 
	testq %rdx,%rdx	
	jne loop #loop if not 0
	popq %r13
	popq %r12
leave 
ret 
.size readlines,.-readlines
