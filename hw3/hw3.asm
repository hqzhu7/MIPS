
##############################################################
# Homework #3
# name: Hengqi Zhu
# sbuid: 111212811
##############################################################
.text

##############################
# PART 1 FUNCTIONS
##############################

replace1st:
    #Define your code here
	############################################
	# DELETE THIS CODE. Only here to allow main program to run without fully implementing the function
	move	$t0,	$a0	#put address of array into t0
	move	$t1,	$a1	#toreplace
	move	$t2,	$a2	#replacewith

	blt	$t1,	0x00,	invalidChar	#if toReplace and replacewith is not a character
	bgt	$t1,	0x7f,	invalidChar
	blt	$t2,	0x00,	invalidChar
	bgt	$t2,	0x7f,	invalidChar

	lbu	$t3,	0($t0)

while:						#while loop to replace 			#extract chara
	beq	$t3,	$zero,	done
	lbu	$t3,	0($t0)
	beq	$t1,	$t3,	replace
	addi	$t0,	$t0,	1
	j	while
replace:
	sb	$t2,	0($t0)
	addi	$t0,	$t0,	1
	move	$v0,	$t0
	j	return
done:
	li	$v0,	0
	j	return

invalidChar:
	li	$v0,	-1
return:
	jr $ra

printStringArray:
    #Define your code here
	############################################
	blt	$a3,	1,	errorReturn		#length<1
	blt	$a1,	0,	errorReturn		#start<0
	blt	$a2,	0,	errorReturn		#end<0
	bge	$a1,	$a3,	errorReturn		#start>=length
	bge	$a2,	$a3,	errorReturn		#end>=length
	blt	$a2,	$a1,	errorReturn		#end<start

	move	$t1,	$a1			#start
	move	$t2,	$a2			#end
	move	$t0,	$a0			#address of the array
	sub	$t3,	$t2,	$t1		#difference
	sll	$t1,	$t1,	2
	sll	$t2,	$t2,	2
	add	$t0,	$t0,	$t1		#start address

Loop1:
	bgt	$t1,	$t2,	done1
	lw	$a0,	0($t0)
	li	$v0,	4
	syscall
	la	$a0,	newlinee
	li	$v0,	4
	syscall
	addi	$t1,	$t1,	4
	addi	$t0,	$t0,	4
	j	Loop1

errorReturn:
	li	$v0,	-1
	j	return

done1:
	addi	$v0,	$t3,	1
    	jr $ra

verifyIPv4Checksum:
    #Define your code here
	############################################
	# DELETE THIS CODE. Only here to allow main program to run without fully implementing the function
	move	$t0,	$a0
	lbu	$t1,	3($t0)	#headerLength


	andi	$t1,	$t1,	0x0000000f
	blt	$t1,	5,	outRange
	bgt	$t1,	15,	outRange
	move	$t7,	$t1
	li	$t2,	2
	mul	$t1,	$t1,	$t2	#t1 = 12
	li	$t2,	0		#int i = 0
	li	$t3,	0		#sum = 0
	li	$t5,	0xffff
for:
	beq	$t2,	$t1,	forDone  #if i == 2xlength
	lhu	$t4	0($t0)		 #value of half
	add	$t3,	$t3,	$t4	 #sum += value
	bgt	$t3,	$t5,	carry
carryBack:
	addi	$t0,	$t0,	2	#pointer move forward
	addi	$t2,	$t2,	1	#i++
	j	for
carry:
	andi	$t4,	$t3,	0xffff0000	#extract carry to t2
	sub	$t3,	$t3,	$t4
	srl	$t4,	$t4,	16
	add	$t3,	$t3,	$t4
	j carryBack
forDone:
	xori	$t3,	$t3,	0xffff		#1's complement

	move	$v0,	$t3

    jr $ra

outRange:
	li	$v0,	-1
	jr	$ra
##############################
# PART 2 FUNCTIONS
##############################

extractData:
    #Define your code here
	move	$t0,	$a0	#address of parray
	#move	$t1,	$a2	#address of msg
	li	$t2,	0	#int i=1
	li	$t7,	0	#a counter to see how many bytes written


forExtract:
	beq	$t2,	$a1,	forExtractDone


	#use stack to store argument
	addi 	$sp,	$sp,	-16
	sw	$t0,	12($sp)
	sw	$t2,	8($sp)
	sw	$t7,	4($sp)
	sw	$ra,	0($sp)
	move	$a0,	$t0
	jal	verifyIPv4Checksum
	lw	$t0,	12($sp)
	lw	$t2,	8($sp)
	lw	$t7,	4($sp)
	lw	$ra,	0($sp)
	addi	$sp,	$sp,	16
	#############stack over##########


	bnez	$v0,		invalidHead
	lbu	$t4,	0($t0)		#get total length
	addi	$t3,	$t0,	20	#to find location of the payload address
	li	$t6,	20
	sub	$t6,	$t4,	$t6	#get length of payload
	li	$t5,	1	#int j=1
	forWriteMsg:
		bgt	$t5,	$t6,	WriteMsgDone
		lb	$t1,	0($t3)	#read byte from address of payload
		sb	$t1,	0($a2)	#store byte to msg

		addi	$a2,	$a2,	1	#msg addres++
		addi	$t5,	$t5,	1	#j++
		addi	$t3,	$t3,	1	#address of payload++
		addi	$t7,	$t7,	1	#counter++
		j	forWriteMsg
	WriteMsgDone:
		addi	$t0,	$t0,	60	#update headeraddress to next header


	addi	$t2,	$t2,	1
	j	forExtract

forExtractDone:
	li	$v0,	0
	move	$v1,	$t7
	j	extractBack

invalidHead:
	li	$v0,	-1
	move	$v1,	$t2
	jr	$ra


extractBack:
    	jr $ra


################################################################################
extractUnorderedData:
	move	$t0,	$a0	#address of array
	move	$t1,	$a1	#number of array
	move	$t2,	$a2	#address of msg
	move	$t3,	$a3	#size of each packet
	move	$s2,	$a2

	addi	$sp,	$sp,	-28
        sw	$ra,	0($sp)
       	sw	$t0,	4($sp)
       	sw	$t1,	8($sp)
       	sw	$t2,	12($sp)
       	sw	$t3,	16($sp)
       	sw	$s0,	20($sp)
       	sw	$s1,	24($sp)
       	move	$s1,	$t0			#use s1 as pointer
	#check sum first
	li	$s0,	0	#int i=0

	forCheck:
		lw	$t1,	8($sp)			#number
		bge	$s0,	$t1,	checkdone       #i<number
        	move	$a0,	$s1			#address of packet
        	jal	verifyIPv4Checksum
        	bnez	$v0,	checkFail
        	lw	$t0	4($sp)
        	lhu	$t2,	0($t0)
        	lw	$t3,	16($sp)
		bgt	$t2,	$t3,	numberTwoWriteError  #if total length > entrysize, quit

        	addi	$s0,	$s0,	1
        	lw	$t3,	16($sp)
        	add	$s1,	$s1,	$t3
        	j	forCheck

checkdone:
        	lw	$ra,	0($sp)
        	lw	$t0,	4($sp)
        	lw	$t1,	8($sp)
        	lw	$t2,	12($sp)
        	lw	$t3,	16($sp)
        	lw	$s0,	20($sp)
        	lw	$s1,	24($sp)
        	addi	$sp,	$sp,	28   #restore original arguements and s1 s0

		blt	$t1,	1,	quitError
		beq	$t1,	1,	numberOne
		bgt	$t1,	1,	numberTwo
##################################################for n>1#############################################
numberTwo:
	addi	$sp,	$sp,	-36
        sw	$s0,	0($sp)
        sw	$s2,	4($sp)
        sw	$s3,	8($sp)
        sw	$s4,	12($sp)
        sw	$s5,	16($sp)
        sw	$t0,	20($sp)
        sw	$t1,	24($sp)
        sw	$t2,	28($sp)
        sw	$t3,	32($sp)

        li	$s0,	0	#int i=0
        li	$s1,	0	# number of begining
        li	$s2,	0	# number of ending
        li	$v1,	0	#count
        forNumberTwo:
        	lw	$t1,	24($sp)
        	bge	$s0,	$t1,	numberTwoDone

		lhu	$t1,	4($t0)		#extract flag
		srl	$t4,	$t1,	13
		lhu	$t2,	4($t0)		#extract offset
		sll	$t2,	$t2,	19
		srl	$t5,	$t2,	19
        	beq	$t4,	2,	twoQuitError
        	beq	$t4,	4,	judgeTwo1
        	beq	$t4,	0,	judgeTwo2
        	j	endJudge

        judgeTwo1:
        	beqz 	$t5,	addBegining
        	bnez 	$t5,	median
        	j	endJudge
        judgeTwo2:
        	bnez	$t5,		addEnding
        	beqz	$t5,		twoQuitError
        	j	endJudge
        endJudge:
        	lw	$t3,	32($sp)
        	add	$t0,	$t0,	$t3	#go to next
        	addi	$s0,	$s0,	1
        	j	forNumberTwo

	numberTwoDone:
		bne	$s1,	1,	twoQuitError
		bne	$s2,	1,	twoQuitError

	#li	$t1,	'\0'
	#sb	$t1,	($t2)
	lw	$t3,	28($sp)
	#move	$a0,	$t3
	#li	$v0,	4
	#syscall
	sub     $v1,	$s5,	$t3
	li	$v0,	0

        lw	$s0,	0($sp)
        lw	$s2,	4($sp)
        lw	$s3,	8($sp)
        lw	$s4,	12($sp)
        lw	$s5,	16($sp)
	addi	$sp,	$sp,	36
	jr	$ra

	addBegining:
		addi	$s1,	$s1,	1
		lb	$t6,	3($t0)		#get header length
		andi	$t6,	$t6,	0xf
		sll	$t6,	$t6,	2	#length*4
		lw	$t2,	32($sp)		#entrysize
		add	$t7,	$t0,	$t6	#to find  the payload address
		lhu	$t3,	0($t0)
		#bgt	$t3,	$t2,	numberTwoWriteError
		sub	$t8,	$t3,	$t6	#get length of payload
		li	$s3,	0
		lw	$t2,	28($sp)
		forWriteBegining:
		bge	$s3,	$t8	WriteBeginingDone
		lbu	$t9,	0($t7)	#read byte from address of payload
		sb	$t9,	0($t2)	#store byte to msg

		addi	$t2,	$t2,	1	#msg addres++
		addi	$s3,	$s3,	1	#j++
		addi	$t7,	$t7,	1	#address of payload++
		addi	$v1,	$v1,	1	#counter++
		j	forWriteBegining

	addEnding:
		addi	$s2,	$s2,	1
		lb	$t6,	3($t0)		#get header length
		andi	$t6,	$t6,	0xf
		sll	$t6,	$t6,	2	#length*4
		lw	$t2,	32($sp)		#entrysize
		add	$t7,	$t0,	$t6	#to find  the payload address
		lhu	$t3,	0($t0)
		#bgt	$t3,	$t2,	numberTwoWriteError
		sub	$t8,	$t3,	$t6	#get length of payload
		li	$s3,	0
		lw	$t2,	28($sp)
		add	$t2,	$t2,	$t5
		forWriteEnding:
		bge	$s3,	$t8	WriteBeginingDone
		lbu	$t9,	0($t7)	#read byte from address of payload
		sb	$t9,	0($t2)	#store byte to msg

		addi	$t2,	$t2,	1	#msg addres++
		addi	$s3,	$s3,	1	#j++
		addi	$t7,	$t7,	1	#address of payload++
		addi	$v1,	$v1,	1	#counter++
		move	$s5,	$t2
		j	forWriteEnding

	median:
		lb	$t6,	3($t0)		#get header length
		andi	$t6,	$t6,	0xf
		sll	$t6,	$t6,	2	#length*4
		lw	$t2,	32($sp)		#entrysize
		add	$t7,	$t0,	$t6	#to find  the payload address
		lhu	$t3,	0($t0)
		#bgt	$t3,	$t2,	numberTwoWriteError
		sub	$t8,	$t3,	$t6	#get length of payload
		li	$s3,	0
		lw	$t2,	28($sp)
		add	$t2,	$t2,	$t5
		forWriteMedian:
		bge	$s3,	$t8	WriteBeginingDone
		lbu	$t9,	0($t7)	#read byte from address of payload
		sb	$t9,	0($t2)	#store byte to msg

		addi	$t2,	$t2,	1	#msg addres++
		addi	$s3,	$s3,	1	#j++
		addi	$t7,	$t7,	1	#address of payload++
		addi	$v1,	$v1,	1	#counter++
		j	forWriteMedian


	WriteBeginingDone:
		j endJudge
##################################################for n>1 end#############################################


##################################################n=1, no stack used#############################################
numberOne:
	#get flag and fragment
	move	$t0,	$a0
	lhu	$t1,	4($t0)		#extract flag
	srl	$t4,	$t1,	13

	lhu	$t2,	4($t0)		#extract offset
	sll	$t2,	$t2,	19
	srl	$t5,	$t2,	19

	beq	$t4,	4,	quitError
	beq	$t4,	2,	writePayloadOne
	beq	$t4,	0, 	continueJudge
continueJudge:
	beq    	$t5,	0,	writePayloadOne
	li	$v0,	-1
	li	$v1,	-1
	jr	$ra
writePayloadOne:
	lb	$t6,	3($t0)		#get total length
	andi	$t6,	$t6,	0xf
	sll	$t6,	$t6,	2	#length*4
	bgt	$t6,	$t3,	numberOneWriteError
	add	$t7,	$t0,	$t6	#to find  the payload address


	lhu	$t3,	0($t0)
	sub	$t8,	$t3,	$t6	#get length of payload
	li	$t2,	0
	li	$v1,	0	#count
	forWriteMsgOne:
		bge	$t2,	$t8	WriteMsgDoneOne
		lbu	$t9,	0($t7)	#read byte from address of payload
		sb	$t9,	0($a2)	#store byte to msg

		addi	$a2,	$a2,	1	#msg addres++
		addi	$t2,	$t2,	1	#j++
		addi	$t7,	$t7,	1	#address of payload++
		addi	$v1,	$v1,	1	#counter++
		j	forWriteMsgOne
WriteMsgDoneOne:
	li	$v0,	0
	jr	$ra
quitError:
	li	$v0,	-1
	li	$v1,	-1
	jr	$ra
checkFail:
	li	$v0,	-1
	move	$v1,	$s0
	lw	$ra,	0($sp)
        lw	$s0,	20($sp)		#restore s0 and s1
       	lw	$s1,	24($sp)
        addi	$sp,	$sp,	28  	#close stack
        jr	$ra
numberOneWriteError:
	li	$v0,	-1
	li	$v1,	0
	jr	$ra
numberTwoWriteError:
	li	$v0,	-1
	move	$v1,	$s0
	lw	$ra,	0($sp)
        lw	$s0,	20($sp)		#restore s0 and s1
       	lw	$s1,	24($sp)
        addi	$sp,	$sp,	28  	#close stack
        jr	$ra
twoQuitError:	#if there is not one beginning or ending, branch goes to here, close stack
	lw	$s0,	0($sp)
        lw	$s2,	4($sp)
        lw	$s3,	8($sp)
        lw	$s4,	12($sp)
        lw	$s5,	16($sp)
	addi	$sp,	$sp,	36
	li	$v0,	-1
	li	$v1,	-1
	jr	$ra

###############################################

processDatagram:
    #Define your code here
    move	$t0,	$a0	#address of string
    move	$t1,	$a1	#max number
    move	$t2,	$a2
    li		$t7,	0	#counter

    ble		$t1,	0,	datagramError	#t1 can be released
    #sw		$t0,	0($t2)
    #addi 	$t7,	$t7,	1
    #addi	$t2,	$t2,	4

    li		$t5,	'\0'
    add		$t3,	$t0,	$t1	#string[m]	$t3 is the last byte
    sb		$t5	0($t3)		#add\0 at the end of stirng
    addi	$t3,	$t3,	-1
    lb		$t4,	0($t3)		#backup the last 2nd byte



    #######################
    forDatagram:
    addi 	$sp,	$sp,	-24
    sw		$t4,	20($sp)
    sw		$t3,	16($sp)
    sw		$t7,	12($sp)
    sw		$t2,	8($sp)
    sw		$ra,	4($sp)
    sw		$t0,	0($sp)

    move	$a0,	$t0
    li		$a1,	'\n'
    li		$a2,	'\0'
    jal		replace1st

    lw		$t4,	20($sp)
    lw		$t3,	16($sp)
    lw		$t7,	12($sp)
    lw		$t2,	8($sp)
    lw		$ra,	4($sp)
    lw		$t0,	0($sp)
    addi 	$sp,	$sp,	24

    beqz	$v0,	doneDatagram

    #addi	$t0,	$v0,	1
    sw		$t0,	0($t2)
    #addi	$t0,	$v0,	1
    move	$t0,	$v0
    #lb		$t6	0($t0)
    #beqz	$t6,	doneDatagram

    addi	$t2,	$t2,	4	#move backward in t2
    addi	$t7,	$t7,	1
    j		forDatagram

 doneDatagram:

    li	$t5,	'\n'
    bne 	$t4,	$t5,	notSkip
    move	$v0,	$t7
    jr $ra

 datagramError:
 	li	$v0,	-1
    jr $ra
notSkip:
     sw		$t0,	0($t2)
     addi	$t7,	$t7,	1
     move	$v0,	$t7
     jr $ra

##############################
# PART 3 FUNCTIONS
##############################

printDatagram:
    #Define your code here
    ############################################
    # DELETE THIS CODE. Only here to allow main program to run without fully implementing the function
    move 	$t0,	$a0  #package array
    move 	$t1,	$a1  #package number
    move 	$t2,	$a2  #msg
    move 	$t3,	$a3  #array string

    ble		$t1,	0, quit
    addi	$sp,	$sp,	-20
    sw	$ra,	16($sp)
    sw	$t0,	12($sp)
    sw	$t1,	8($sp)
    sw	$t2,	4($sp)
    sw	$t3,	0($sp)

    jal	extractData
    lw	$ra,	16($sp)
    beq	$v0,	-1, quit
    lw	$t0,	12($sp)
    lw	$t1,	8($sp)
    lw	$t2,	4($sp)
    lw	$t3,	0($sp)

    move $a0,	$t2
    move $a1,	$v1
    move $a2,	$t3


    jal	processDatagram
    lw	$ra,	16($sp)
    beq	$v0,	-1, quit
    lw	$t0,	12($sp)
    lw	$t1,	8($sp)
    lw	$t2,	4($sp)
    lw	$t3,	0($sp)

    move $a0,	$t3
    li	$a1,	0
    move $a3,	$v0
    addi	$v0,	$v0,	-1
    move $a2,	$v0

    jal printStringArray

    lw	$ra,	16($sp)
    beq	$v0,	-1, quit
    addi	$sp, $sp,20

    ############################################
    li	$v0,	0
    jr $ra

quit:

    li	$v0,	-1
    jr	$ra


printUnorderedDatagram:
    lw	$t0,	0($sp)

    addi	$sp,	$sp,	-24
    sw	$a0	20($sp)
    sw	$a1,	16($sp)
    sw	$a2,	12($sp)
    sw	$a3,	8($sp)
    sw	$t0,	4($sp)
    sw	$ra,	0($sp)

    lw	$a0, 20($sp)
    lw  $a1, 16($sp)
    lw	$a2, 12($sp)
    lw	$a3, 4($sp)
    sw	$ra, 0($sp)
    ble	$a1, 0, quitfinal
    jal extractUnorderedData
    beq	$v0,	-1, quitfinal

    lw $a0, 12($sp)
    move $a1,	$v1
    lw	$a2, 8($sp)
    jal	processDatagram
    beq	$v0,	-1, quitfinal

    lw  $a0,	8($sp)
    li	$a1,	0
    move $a3,	$v0
    addi	$v0,	$v0,	-1
    move $a2,	$v0
    jal printStringArray
    beq	$v0,	-1, quitfinal


    lw  $ra,	0($sp)
    addi	$sp,	$sp,	24
    li	$v0,	0
    jr	$ra

 quitfinal:
 	li $v0,-1
    	lw  $ra,	0($sp)
    	addi	$sp,	$sp,	24
    	li	$v0,	-1
    jr	$ra
######################################################################
editDistance:
	addi	$sp,	$sp,	-32
	sw	$a0,	0($sp)			#start address of frist string
	sw	$a1,	4($sp)			#address of 2nd string
	sw	$a2,	8($sp)			#m
	sw	$a3,	12($sp)			#n
	sw	$ra,	16($sp)
	sw	$s0,	20($sp)
	sw	$s1,	24($sp)
	sw	$s2,	28($sp)

    	lw	$t0,	8($sp)		#m
    	lw	$t1,	12($sp)		#n

    	bge	$t0,	0,	judgeN
    	li	$v0,	-1
    	lw	$ra,	16($sp)
    	lw	$s0,	20($sp)
	lw	$s1,	24($sp)
	lw	$s2,	28($sp)
    	addi	$sp,	$sp,	32
    	jr	$ra
judgeN:
	bge	$t1,	0,	else
	li	$v0,	-1
   	lw	$ra,	16($sp)
   	lw	$s0,	20($sp)
	lw	$s1,	24($sp)
	lw	$s2,	28($sp)
    	addi	$sp,	$sp,	32
    	jr	$ra
else:
	#print
	la	$a0,	mm
	li	$v0,	4
	syscall

	move	$a0,	$t0
	li	$v0,	1
	syscall

	la	$a0,	comma
	li	$v0,	4
	syscall

	la	$a0,	nn
	li	$v0,	4
	syscall

	move	$a0,	$t1
	li	$v0,	1
	syscall


	la	$a0,	newline
	li	$v0,	4
	syscall

	lw	$t0,	8($sp)			#m

	beq	$t0,	0,	returnN	#if(m==0)
	lw	$t1,	12($sp)
	beq	$t1,	0,	returnM #if(n==0)

	#if(str1.charat(m-1)==str2.charat(n-1))
	lw	$t2,	0($sp)	#address of str1
	lw	$t3,	4($sp)	#address of str2

	addi	$t0,	$t0,	-1	#m-1
	add	$t2,	$t2,	$t0
	lb	$t4,	($t2)		#str1.charat(m-1)

	addi	$t1,	$t1,	-1	#n-1
	add	$t3,	$t3,	$t1
	lb	$t5,	($t3)	#str2.charat(n-1)

	beq	$t4,	$t5,	returnD1

	#int insert t7
	lw	$t2,	($sp)
	lw	$t3,	4($sp)
	lw	$t0,	8($sp)
	lw	$t1,	12($sp)
	addi	$t1,	$t1,	-1
	move	$a0,	$t2
	move	$a1,	$t3
	move	$a2,	$t0
	move	$a3,	$t1
	jal	editDistance
	move	$s0,	$v0

	#int removet8
	lw	$t2,	($sp)
	lw	$t3,	4($sp)
	lw	$t0,	8($sp)
	lw	$t1,	12($sp)
	addi	$t0,	$t0,	-1
	move	$a0,	$t2
	move	$a1,	$t3
	move	$a2,	$t0
	move	$a3,	$t1
	jal	editDistance
	move	$s1,	$v0

	#int replace t6
	lw	$t2,	($sp)
	lw	$t3,	4($sp)
	lw	$t0,	8($sp)
	lw	$t1,	12($sp)
    	addi	$t0,	$t0,	-1
    	addi	$t1,	$t1,	-1
	move	$a0,	$t2
	move	$a1,	$t3
	move	$a2,	$t0
	move	$a3,	$t1
	jal	editDistance
	move	$s2,	$v0


	#cacluate
	bgt	$s2,	$s0,	com1
	bgt	$s2,	$s1,	com2
	move	$v0,	$s2
	addi	$v0,	$v0,	1
	j	compDone
com1:
	bgt	$s0,	$s1,	com2
	move	$v0,	$s0
	addi	$v0,	$v0,	1
	j	compDone
com2:
	move	$v0,	$s1
	addi	$v0,	$v0,	1
	j	compDone



returnN:
       	lw	$t1,	12($sp)
	move	$v0,	$t1
	lw	$ra,	16($sp)
	lw	$s0,	20($sp)
	lw	$s1,	24($sp)
	lw	$s2,	28($sp)
    	addi	$sp,	$sp,	32
    	jr	$ra
returnM:
	lw	$t0,	8($sp)
	move	$v0,	$t0
	lw	$ra,	16($sp)
	lw	$s0,	20($sp)
	lw	$s1,	24($sp)
	lw	$s2,	28($sp)
    	addi	$sp,	$sp,	32
    	jr	$ra
returnD1:
	lw	$t2,	($sp)
	lw	$t3,	4($sp)
	lw	$t0,	8($sp)
	lw	$t1,	12($sp)
	addi	$t0,	$t0,	-1
	addi	$t1,	$t1,	-1
	move	$a0,	$t2
	move	$a1,	$t3
	move	$a2,	$t0
	move	$a3,	$t1
	jal	editDistance
   	lw	$ra,	16($sp)
   	lw	$s0,	20($sp)
	lw	$s1,	24($sp)
	lw	$s2,	28($sp)
    	addi	$sp,	$sp,	32
    	jr	$ra

compDone:
	lw	$ra,	16($sp)
	lw	$s0,	20($sp)
	lw	$s1,	24($sp)
	lw	$s2,	28($sp)
    	addi	$sp,	$sp,	32
    	jr	$ra









#################################################################
# Student defined data section
#################################################################
.data
newlinee:  .asciiz "\n\n"
mm:	.asciiz "m:"
nn:	.asciiz "n:"
comma:   .asciiz ","
newline:  .asciiz "\n"

.align 2  # Align next items to word boundary

#place all data declarations here
