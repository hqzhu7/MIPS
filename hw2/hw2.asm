
##############################################################
# Homework #2
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
	############################################
    jr $ra

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
#################################################################
# Student defined data section
#################################################################
.data
newlinee:  .asciiz "\n\n"
.align 2  # Align next items to word boundary

#place all data declarations here
