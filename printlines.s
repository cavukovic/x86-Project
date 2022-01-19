#BY SUBMITTING THIS FILE TO CARMEN, I CERTIFY THAT I STRICTLY ADHERED TO THE
#TENURES OF THE OHIO STATE UNIVERSITY’S ACADEMIC INTEGRITY POLICY.


#function reads in command line arguments, allocates memory for structures
#opens file, then calls the necessary functions and frees and closes file

.file "readrec.s"
.globl main
        .type main, @function

printf_error:
.string "Incorrect number of command line arguments \n"

read: #for fopen call
.string "r"


.text
main:
        pushq %rbp   #stack housekeeping
        movq %rsp, %rbp

        #rdi has number of command line arguments 
        #rsi has char **argc

        # check if rdi is 3
        cmpq $3,%rdi
        jne printError # if incorrect number, jump to error stuff

	#getting corret value of rsi
	#rsi + 8 gives address
	#call atoi, put address in first param spot 
	movq 8(%rsi),%rdi # rsi + 8, this is the address to give to atoi
	pushq %rsi
	pushq %rdi #number of command line args
	
	call atoi #rdi contains the first paramenter which is the address, so just call
	
	popq %rdi
	popq %rsi	

	movq %rax,%rdi #rax now contains value to pass to malloc, move to rdi to work with
	movq %rdi,%rdx #copy that number to rdx because we will need to pass it later
	
	
	#allocate memory
	#number of structures * size of structure is amount of mem  
	# call malloc with 24*number of structures
	shlq $3,%rdi #8*num
	leaq (%rdi,%rdi,2),%rdi # 3*num, so now 24*num	

	pushq %rdx # rdx (number of records)
	pushq %rsi
	call malloc #rax now contains struct Record *rptr to pass to functions
	popq %rsi
	popq %rdx

	#open the file
	pushq %rax # save the Record *rptr
	pushq %rdx # save the number of records 
	
	movq 16(%rsi),%rdi # putting file name in 1 param
	movq $read,%rsi # putting "r" in second param

	call fopen #rax now contains the file ptr
	movq %rax,%rdi # put file ptr in the 1st param 
	
	popq %rdx #num of records
	popq %rax #record ptr

	movq %rax,%rsi # put record ptr in the 2nd param
	#num of records is already in 3rd param

	#call functions
	pushq %rdi # save fptr
	pushq %rsi # save record ptr
	pushq %rdx # save count

	call readlines

	popq %rdx
	popq %rsi
	popq %rdi

	movq %rdi,%rcx # put the fptr in rcx for closing later
	movq %rsi,%rdi # put record ptr in 1st param 
	movq %rdx,%rsi # put count in 2nd param

	pushq %rdi # save record ptr
	pushq %rsi # save count
	pushq %rcx # save file pointer
		
	call printlines

	popq %rcx 
	popq %rsi
	popq %rdi

	pushq %rcx

	#free memory 
	call free #rdi contains record ptr
	popq %rcx #file pointer

	#close file
	movq %rcx,%rdi # move file pointer to first param 
	call fclose

	jmp end #if we're here we don't want to print error stuff so jmp over it

        printError: # to deal with error
        movq $printf_error,%rdi
        movq $0,%rax
        call printf # don't care about registers getting messed up becasue we leave right after 
        #if we're here we will go straigt to leave anyway

	end:

leave 
ret
.size main,.-main

