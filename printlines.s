#BY SUBMITTING THIS FILE TO CARMEN, I CERTIFY THAT I STRICTLY ADHERED TO THE
#TENURES OF THE OHIO STATE UNIVERSITY’S ACADEMIC INTEGRITY POLICY.

#function prints the values in a given structure in a neat formatted way

.file "printlines.s"
.section .rodata

printf_message:
.string "%d + %d = %d \n"


.globl printlines #required directive for every function
        .type printlines, @function #required directive 

.text
printlines:

	push %rbp               # save caller's %rbp
        movq %rsp, %rbp         # copy %rsp to %rbp so our stack frame is ready to use

	#rdi has struct Record *rptr
	#rsi has int count 
	movq $0,%rdx #set struct byte allignment offset to 0

	loop:

	# value 1
	leaq 16(%rdi),%r8 #16 bytes past the start of the struct for value 1
	addq %rdx,%r8 # add this to offset address to go to the next struct

	#value 2
	leaq (%rdi),%r9 # p+0 for value 2 
	addq %rdx,%r9 

	#value 3
	leaq 8(%rdi),%r10 # p + 8 for value 3
	addq %rdx,%r10


	#print
	pushq %rdx #struct byte allignment amount
	pushq %rsi #count
	pushq %rdi #struct ptr
	
	movq $printf_message,%rdi # move printf message to first param
	movq (%r8),%rsi  # dereference and move all struct values to param
	movq (%r9),%rdx  # spots before calling printf
	movq (%r10),%rcx 

	movq $0,%rax # must set rax to 0 before printf
	call printf

	popq %rdi
	popq %rsi
	popq %rdx


	addq $24,%rdx # for struct byte allignment
	decq %rsi # decrement count
	testq %rsi,%rsi 
	jne loop # loop if not 0




leave
ret
.size printlines,.-printlines

