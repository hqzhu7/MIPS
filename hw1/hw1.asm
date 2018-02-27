#Homework #1
#Name: Hengqi Zhu
#Net ID: henzhu
#SBU ID: 111212811

.data

#include the file with the test case info
.include "Header2.asm" #change this line to test other files

.align 2
	numargs: 		.word 		0
	AddressOfIPDest3: 	.word 		0
	AddressOfIPDest2: 	.word 		0
	AddressOfIPDest1: 	.word 		0
	AddressOfIPDest0: 	.word 		0
	AddressOfBytesSent: 	.word 		0
	AddressOfPayload: 	.word 		0
	AddressOfEnd:		.word		0
	
	Err_string: 		.asciiz 	"ERROR\n"
	newline: 		.asciiz 	"\n"
	ipv4: 			.asciiz 	"IPv4\n"
	notIpv4: 		.asciiz 	"Unsupported:IPv"
	comma: 			.asciiz 	","
	point: 			.asciiz 	"."
	null:			.asciiz 	"\0"
	
	valueOfIPDest3: 	.byte 		0
	valueOfIPDest2: 	.byte		0
	valueOfIPDest1: 	.byte 		0
	valueOfIPDest0: 	.byte 		0
	valueOfBytesSent: 	.word		0
	headerLength:		.byte		0
	
	
#helper macro for accessing command line argument via label
.macro load_args
	sw $a0, numargs
	lw $t0, 0($a1)
	sw $t0, AddressOfIPDest3
	lw $t0, 4($a1)
	sw $t0, AddressOfIPDest2
	lw $t0, 8($a1)
	sw $t0, AddressOfIPDest1
	lw $t0, 12($a1)
	sw $t0, AddressOfIPDest0
	lw $t0, 16($a1)
	sw $t0, AddressOfBytesSent
	lw $t0, 20($a1)
	sw $t0, AddressOfPayload
.end_macro

.macro print_comma
	la	$a0,	comma			
	li	$v0,	4
	syscall
.end_macro

.macro print_point
	la	$a0,	point			
	li	$v0,	4
	syscall
.end_macro

.macro print_newline
	la	$a0,	newline			
	li	$v0,	4
	syscall
.end_macro

.text
.globl main
main:
	load_args()
	
	lw 	$t0, 	numargs 		#get numargs
	bne 	$t0, 	6,	printError 	#if number of arguements != 6, jump to error 
	
###################################check first 4 arguments######################################	
	lw	$a0,	AddressOfIPDest3	
	li	$v0	84
	syscall					#convert 1st argument
	sb	$v0,	valueOfIPDest3
	bne	$v1,	0,	printError	#if v0(atoi services failed)!=0, jump to error
	blt	$v0,	0	printError	#if v1(value after convert)<0, jump to error
	bgt	$v0,	255	printError	#if v1(value after convert)>255, jump to error
	
	lw	$a0,	AddressOfIPDest2	
	li	$v0	84
	syscall					#convert 2nd argument
	sb	$v0,	valueOfIPDest2
	bne	$v1,	0,	printError	#if v0(atoi services failed)!=0, jump to error
	blt	$v0,	0	printError	#if v1(value after convert)<0, jump to error
	bgt	$v0,	255	printError	#if v1(value after convert)>255, jump to error
	
	lw	$a0,	AddressOfIPDest1	
	li	$v0	84
	syscall					#convert 4th argument
	sb	$v0,	valueOfIPDest1
	bne	$v1,	0,	printError	#if v0(atoi services failed)!=0, jump to error
	blt	$v0,	0	printError	#if v1(value after convert)<0, jump to error
	bgt	$v0,	255	printError	#if v1(value after convert)>255, jump to error
	
	lw	$a0,	AddressOfIPDest0	
	li	$v0	84
	syscall					#convert first argument
	sb	$v0,	valueOfIPDest0
	bne	$v1,	0,	printError	#if v0(atoi services failed)!=0, jump to error
	blt	$v0,	0	printError	#if v1(value after convert)<0, jump to error
	bgt	$v0,	255	printError	#if v1(value after convert)>255, jump to error
	
###################################check bytesSent######################################	
	lw	$a0,	AddressOfBytesSent
	li	$v0	84
	syscall
	sw	$v0,	valueOfBytesSent
	bne	$v1,	0,	printError	#if v0(atoi services failed)!=0, jump to error
	blt	$v0,	-1,	printError	#if v0 <-1
	beq	$v0,	-1,	notCheckEight
	bgt	$v0,	8191	printError	#if v0 >2^13-1
	li	$t0	8			#check reminder is 0 or not
	div	$v0,	$t0
	mfhi	$t0
	bne	$t0,	0,	printError
notCheckEight:
###################################The end of part1######################################

###################################Check packet Version##################################
	la	$t0,	Header			#load Header (address of Header1.asm) into t0
	lb 	$t1, 	3($t0)			#load address of 
	andi 	$t2, 	$t1, 	0xf0
	srl 	$t2, 	$t2, 	4

	beq	$t2,	4	printIPv4
printIPv4Back:		
	bne	$t2,	4	printNotIPv4
printNotIPv4Back:

###################################part2.2##################################
	la	$t0,	Header
	lbu	$a0,	2($t0)			#type of service	
	li	$v0,	1
	syscall
	print_comma()	
	
	lhu	$a0,	6($t0)			#identifier
	li	$v0,	1
	syscall
	print_comma()		
	
	lbu	$a0,	11($t0)			#time to live
	li	$v0,	1
	syscall
	print_comma()	
	
	lbu	$a0,	10($t0)			#protocol
	li	$v0,	1
	syscall
	
	print_newline()

###################################part2.3##################################
	la	$t0,	Header
	lbu	$a0,	15($t0)
	li	$v0,	1
	syscall	
	print_point()
	
	la	$t0,	Header
	lbu	$a0,	14($t0)
	li	$v0,	1
	syscall	
	print_point()

	la	$t0,	Header
	lbu	$a0,	13($t0)
	li	$v0,	1
	syscall	
	print_point()

	la	$t0,	Header
	lbu	$a0,	12($t0)
	li	$v0,	1
	syscall	
	print_newline()

###################################part2.4##################################
	la	$t0,	Header
	lbu	$t1,	valueOfIPDest3		#store value of 1st argurement into $t1
	sb	$t1,	19($t0)
	
	lbu	$t1,	valueOfIPDest2		#store value of 2nd argurement into $t1
	sb	$t1,	18($t0)

	lbu	$t1,	valueOfIPDest1		#store value of 3rd argurement into $t1
	sb	$t1,	17($t0)
	
	lbu	$t1,	valueOfIPDest0		#store value of 4th argurement into $t1
	sb	$t1,	16($t0)
	
	lw	$a0,	16($t0)
	li	$v0,	34
	syscall
	
	print_newline()

###################################part2.5##################################
	li	$t3	0
	lw	$t0,	AddressOfPayload
while:						#while loop to get length of payload
	lb	$t1,	0($t0)
	beq	$t1,	$zero,	done
	addi	$t3,	$t3,	1
	addi	$t0,	$t0,	1
	j	while

done:
	la	$t0,	Header			#add length on header length
	lbu	$t1,	3($t0)
	andi	$t1,	$t1,	0xf
	sb	$t1,	headerLength
	li	$t7,	4
	mul	$t1,	$t1,	$t7
	add	$t2,	$t1,	$t3
	sh	$t2,	0($t0)
	
###################################part2.6##################################
	la	$t0,	Header
	lhu	$t1,	4($t0)		#extract flag			
	srl	$t1,	$t1,	13
	
	lhu	$t2,	4($t0)		#extract offset
	sll	$t2,	$t2,	19
	srl	$t2,	$t2,	19
	
	move	$a0,	$t1		#print them out
	li	$v0,	35
	syscall
	print_comma()
	move	$a0,	$t2
	li	$v0,	35
	syscall
	print_newline()

	lw	$t1,	valueOfBytesSent		
	beq	$t1,	0,	byteSentZero		#if bytesent=0
	beq	$t1,	-1,	byteSentNegOne		#if bytesent=-1
	bgt	$t1,	0,	byteSentGreZero		#if bytesent>0
		
byteSentZero:
	sh	$zero,	4($t0)
	j	endOfbyteSent
byteSentNegOne:
	li	$t2,	2
	sll	$t2,	$t2,	13		
	sh	$t2,	4($t0)
	j	endOfbyteSent
byteSentGreZero:
	li	$t2,	4
	sll	$t2,	$t2,	13
	add	$t2,	$t2,	$t1
	sh	$t2,	4($t0)		
	j	endOfbyteSent
					
endOfbyteSent:

###################################part2.7##################################
	la	$t0,	Header
	lw	$t1,	AddressOfPayload
	lbu	$t2,	headerLength
	li	$t7	4
	mul	$t2,	$t2,	$t7	# length*4
	add	$t0,	$t0,	$t2	# header = header + length
	
	
while1:						
	lb	$t3,	0($t1)		#load byte from payload
	beq	$t3,	$zero,	done1
	sb	$t3,	0($t0)		#put it into destination
	addi	$t0,	$t0,	1
	addi	$t1,	$t1,	1
	j	while1	
	
done1:	
	sw	$t0,	AddressOfEnd
###################################part2.8##################################
	la	$t0,	Header
	lw	$t1,	AddressOfEnd
	li	$v0,	34
	move	$a0,	$t0
	syscall
	print_comma()
	li	$v0,	34
	move	$a0,	$t1
	syscall
	
###################################part2.9##################################
	la	$t0,	Header
	lb	$t1,	headerLength	#headerLength
	li	$t2,	2
	mul	$t1,	$t1,	$t2	#t1 = 12
	li	$t2,	0		#int i = 0
	li	$t3,	0		#sum = 0
for:
	beq	$t2,	$t1,	forDone  #if i == 2xlength
	beq	$t2,	4,	skipFor	 #skip header checksum
	lhu	$t4	0($t0)		 #value of half
	add	$t3,	$t3,	$t4	 #sum += value
skipFor:
	addi	$t0,	$t0,	2	#pointer move forward
	addi	$t2,	$t2,	1	#i++
	j	for	
forDone:	
	andi	$t2,	$t3,	0xffff0000	#extract carry to t2	
	sub	$t3,	$t3,	$t2
	srl	$t2,	$t2,	16
	add	$t3,	$t3,	$t2
	xori	$t3,	$t3,	0xffff		#1's complement
	la	$t0,	Header
	sh	$t3,	8($t0)
	
	#lw	$t1,	0($t0)
	#lw	$t2,	4($t0)
	#lw	$t3,	8($t0)
	#lw	$t4,	12($t0)
	#lw	$t5,	16($t0)
	#lw	$t6,	20($t0)
	j	exit
	
printError:
	li	$v0, 	4
	la	$a0,	Err_string
	syscall	
	j 	exit
	
printNotIPv4:				#print if not ipv4
	li	$v0,	4
	la	$a0,	notIpv4
	syscall
	li	$v0,	1
	move	$a0,	$t2	
	syscall	
	print_newline()
	
	andi 	$t3, 	$t1, 	0xf
	addi	$t3,	$t3,	0x40	#make veriosn to 4
	sb	$t3,	3($t0)		#put it back to memory
	lw	$t3,	0($t0)		#this statement is to check it's same as original in header1.asm
	
	j	printNotIPv4Back

printIPv4:				#print if ipv4
	li	$v0,	4
	la	$a0,	ipv4
	syscall
	j	printIPv4Back
	
exit:
	li $v0, 10
	syscall


	
