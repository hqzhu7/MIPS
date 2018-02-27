
##############################################################
# Homework #4
# name: Hengqi Zhu
# sbuid: 111212811
##############################################################
.text

##############################
# PART 1 FUNCTIONS
##############################

clear_board:
    #Define your code here
	############################################
	# DELETE THIS CODE. Only here to allow main program to run without fully implementing the function
	blt	$a1,	2,	quit
	blt	$a2,	2,	quit
	
	move	$t0,	$a0	#address
	move	$t1,	$a1	#numb_rows
	move	$t2,	$a2	#num_cols
	
	li	$t3,	0	#int i=0
	li	$t4,	0	#int j=0
	
forRow:
	beq	$t3,	$t1,	rowDone
	forCol:
		beq	$t4,	$t2,	colDone
		li	$t5,	-1
		
		
		li	$t6,	2
		mul	$t6,	$t6,	$t4 #(sizeof obj)*j
		
		li	$t7,	2
		mul	$t7,	$t7,	$t2 #row_size=n_col*sizeof(obj)
		mul	$t7,	$t7,	$t3 #row_size*i
		
		move	$t0,	$a0
		add	$t0,	$t0,	$t6
		add	$t0,	$t0,	$t7
		
		sh	$t5,	0($t0)
		
		addi	$t4,	$t4,	1
		j	forCol
	colBack:
	addi	$t3,	$t3,	1
	j	forRow	
	###########################################
quit:	
	li	$v0,	-1
	jr	$ra
rowDone:
	li	$v0,	0
	jr	$ra
colDone:
	li	$t4,	0
	j	colBack

place:
    #Define your code here
	############################################
	# DELETE THIS CODE. Only here to allow main program to run without fully implementing the function
	move	$t0,	$a0	#address
	move	$t1,	$a1	#n_rows
	move	$t2,	$a2	#n_cols
	move	$t3,	$a3	#row==i
	lw	$t4,	0($sp)	#col==j
	lw	$t5,	4($sp)	#value
	
	blt	$a1,	2,	quit
	blt	$a2,	2,	quit	
	bltz	$t3,	quit
	bge	$t3,	$t1,	quit
	bltz	$t4,	quit
	bge	$t4,	$t2,	quit
	beq	$t5,	-1,	continueJ
	blt	$t5,	2,	quit
	######################check $t5 is power of two
	addi	$sp	$sp	-8
	sw	$s0,	4($sp)
	sw	$s1,	0($sp)
	move $s0, $t5 	# num = input value
	li $s1, 0 		# counter = 0
	li $t0, 1 		# position = 1
	li $t1, 0 		# i = 0

	loop:
		and $s2, $s0, $t0 	# bit = num & position
		beqz $s2, end_if	# bit == 0, so leave if-statement
		addi $s1, $s1, 1	# bit == 1, so add 1 to counter
	end_if:
		sll $t0, $t0, 1		# position = position << 1
		addi $t1, $t1, 1	# i++
		blt $t1, 32, loop	# if i < 32 then iterate again
	
	bne	$s1,	1,	quitPower

	sw	$s0,	4($sp)
	sw	$s1,	0($sp)
	addi	$sp	$sp	8
	move	$t0,	$a0	#address
	move	$t1,	$a1	#n_rows
	######################check $t5 is power of two
continueJ:
	
	li	$t6,	2
	mul	$t6,	$t6,	$t4 #(sizeof obj)*j
	
	li	$t7,	2
	mul	$t7,	$t7,	$t2 #row_size=n_col*sizeof(obj)
	mul	$t7,	$t7,	$t3 #row_size*i
	
	add	$t0,	$t0,	$t6
	add	$t0,	$t0,	$t7
	
	sh	$t5,	0($t0)
	
	li	$v0,	0
	############################################
    jr $ra

quitPower:
	sw	$s0,	4($sp)
	sw	$s1,	0($sp)
	addi	$sp	$sp	8
	li	$v0	-1
	jr	$ra


start_game:
    #Define your code here
	############################################
	# DELETE THIS CODE. Only here to allow main program to run without fully implementing the function
	
	
	
	
  	move	$t0,	$a0	#address
	move	$t1,	$a1	#n_rows
	move	$t2,	$a2	#n_cols
	move	$t3,	$a3	#r1
	lw	$t4,	0($sp)	#c1
	lw	$t5,	4($sp)	#r2
	lw	$t6,	8($sp)	#c2
	
	blt	$a1,	2,	quit
	blt	$a2,	2,	quit
	bltz	$t3,	quit
	bge	$t3,	$t1,	quit
	bltz	$t4,	quit
	bge	$t4,	$t2,	quit
	bltz	$t5,	quit
	bge	$t5,	$t1,	quit
	bltz	$t6,	quit
	bge	$t6,	$t2,	quit
	
	
	addi	$sp,	$sp,	-36
	sw	$t0,	32($sp)	
	sw	$t1,	28($sp)	
	sw	$t2,	24($sp)	
	sw	$t3,	20($sp)
	sw	$t4,	16($sp)
	sw	$t5,	12($sp)
	sw	$t6,	8($sp)
	sw	$ra,	4($sp)	
	
	
	jal	clear_board
	lw	$t0,	32($sp)	
	lw	$t1,	28($sp)	
	lw	$t2,	24($sp)	
	lw	$t3,	20($sp)
	lw	$t4,	16($sp)
	lw	$t5,	12($sp)
	lw	$t6,	8($sp)
	lw	$ra,	4($sp)
	
	move	$a0,	$t0	#address
	move	$a1,	$t1	#n_row
	move	$a2,	$t2	#n_col
	move	$a3,	$t3	#row
	addi	$sp,	$sp,	-12
	sw	$ra,	8($sp)
	sw	$t4,	0($sp)  #col
	li	$t7,	2
	sw	$t7,	4($sp) #val
	jal	place		
	lw	$ra,	8($sp)
	addi	$sp,	$sp,	12
	
	
	lw	$t0,	32($sp)	
	lw	$t1,	28($sp)	
	lw	$t2,	24($sp)	
	lw	$t3,	20($sp)
	lw	$t4,	16($sp)
	lw	$t5,	12($sp)
	lw	$t6,	8($sp)
	lw	$ra,	4($sp)
	
	move	$a0,	$t0	#address
	move	$a1,	$t1	#n_row
	move	$a2,	$t2	#n_col
	move	$a3,	$t5	#row
	addi	$sp,	$sp,	-12
	sw	$ra,	8($sp)
	sw	$t6,	0($sp)  #col
	li	$t7,	2
	sw	$t7,	4($sp)
	jal	place		
	lw	$ra,	8($sp)
	addi	$sp,	$sp,	12
	
	
	
	lw	$t0,	32($sp)	
	lw	$t1,	28($sp)	
	lw	$t2,	24($sp)	
	lw	$t3,	20($sp)
	lw	$t4,	16($sp)
	lw	$t5,	12($sp)
	lw	$t6,	8($sp)
	lw	$ra,	4($sp)
	addi	$sp,	$sp,	36
	
	li $v0,	0
	############################################
    jr $ra

##############################
# PART 2 FUNCTIONS
##############################

merge_row:
    #Define your code here
    ############################################
    # DELETE THIS CODE. Only here to allow main program to run without fully implementing the function
	move	$t0,	$a0	#address
	move 	$t1,	$a1	#n_row
	move	$t2,	$a2	#n_col
	move	$t3,	$a3	#row
	lw	$t4,	0($sp)  #dir

    	blt	$a1,	2,	quit
	blt	$a2,	2,	quit
	bltz	$t3,	quit
	bge	$t3,	$t1,	quit
	
	beqz	$t4,	leftToRight
	beq	$t4,	1,	RightToLeft
	li	$v0,	-1
	jr	$ra
leftToRight:
	li	$t5,	1 #intj=1
	forLtoR:
		beq	$t5,	$t2,	froLtoRDone	
		
		move	$t6,	$t0 #address
		move	$t7,	$t2
		sll	$t7,	$t7,	1  #obj(2)*n_col
		mul	$t7,	$t7,	$t3 #obj(2)*n_col*i
		move	$t8,	$t5 
		sll	$t8,	$t8,	1 #sizeof*j

		add	$t6,	$t6,	$t7
		add	$t6,	$t6,	$t8
		
		lh	$t9,	0($t6)
		beq	$t9,	-1,	skipMerge
		#####################################
		addi	$t5,	$t5,	-1
		move	$t6,	$t0 #address
		move	$t7,	$t2
		sll	$t7,	$t7,	1  #obj(2)*n_col
		mul	$t7,	$t7,	$t3 #obj(2)*n_col*i
		move	$t8,	$t5 
		sll	$t8,	$t8,	1 #sizeof*j

		add	$t6,	$t6,	$t7
		add	$t6,	$t6,	$t8
		
		lh	$t4,	0($t6)

		beq	$t4,	$t9,	addLtoR
		
	jback:		
		lw	$t4,	0($sp)  #dir
		addi	$t5,	$t5,	1
	skipMerge:	
	addi	$t5,	$t5,	1
	j	forLtoR
froLtoRDone:	
	li $v0, 0	
    ############################################
	jr $ra

addLtoR:
	add	$t4,	$t4,	$t9
	
	move	$t6,	$t0 #address
	move	$t7,	$t2
	sll	$t7,	$t7,	1  #obj(2)*n_col
	mul	$t7,	$t7,	$t3 #obj(2)*n_col*i
	move	$t8,	$t5 
	sll	$t8,	$t8,	1 #sizeof*j

	add	$t6,	$t6,	$t7
	add	$t6,	$t6,	$t8
	sh	$t4,	0($t6)
	#########################################
	addi	$t5,	$t5,	1
	move	$t6,	$t0 #address
	move	$t7,	$t2
	sll	$t7,	$t7,	1  #obj(2)*n_col
	mul	$t7,	$t7,	$t3 #obj(2)*n_col*i
	move	$t8,	$t5 
	sll	$t8,	$t8,	1 #sizeof*j

	add	$t6,	$t6,	$t7
	add	$t6,	$t6,	$t8

	li	$t4,	-1
	sh	$t4,	0($t6)
	addi	$t5,	$t5,	-1
	j	jback

RightToLeft:
	addi	$t5,	$t2,	-1
	forRtoL:
		blez	$t5,		froRtoLDone	
		
		move	$t6,	$t0 #address
		move	$t7,	$t2
		sll	$t7,	$t7,	1  #obj(2)*n_col
		mul	$t7,	$t7,	$t3 #obj(2)*n_col*i
		move	$t8,	$t5 
		sll	$t8,	$t8,	1 #sizeof*j

		add	$t6,	$t6,	$t7
		add	$t6,	$t6,	$t8
		
		lh	$t9,	0($t6)
		beq	$t9,	-1,	skipMerge1
		#####################################
		addi	$t5,	$t5,	-1
		
		move	$t6,	$t0 #address
		move	$t7,	$t2
		sll	$t7,	$t7,	1  #obj(2)*n_col
		mul	$t7,	$t7,	$t3 #obj(2)*n_col*i
		move	$t8,	$t5 
		sll	$t8,	$t8,	1 #sizeof*j

		add	$t6,	$t6,	$t7
		add	$t6,	$t6,	$t8
		
		lh	$t4,	0($t6)

		beq	$t4,	$t9,	addRtoL
		
	jback1:		
		lw	$t4,	0($sp)  #dir
		addi	$t5,	$t5,	1
	skipMerge1:	
	addi	$t5,	$t5,	-1
	j	forRtoL
froRtoLDone:		
    ############################################
    	li	$v0,0
	jr $ra

addRtoL:
	add	$t9,	$t4,	$t9
	
	move	$t6,	$t0 #address
		move	$t7,	$t2
		sll	$t7,	$t7,	1  #obj(2)*n_col
		mul	$t7,	$t7,	$t3 #obj(2)*n_col*i
		move	$t8,	$t5 
		sll	$t8,	$t8,	1 #sizeof*j

		add	$t6,	$t6,	$t7
		add	$t6,	$t6,	$t8
	li	$t4,	-1
	sh	$t4,	0($t6)
	
	
	
	addi	$t5,	$t5,	1
	move	$t6,	$t0 #address
		move	$t7,	$t2
		sll	$t7,	$t7,	1  #obj(2)*n_col
		mul	$t7,	$t7,	$t3 #obj(2)*n_col*i
		move	$t8,	$t5 
		sll	$t8,	$t8,	1 #sizeof*j

		add	$t6,	$t6,	$t7
		add	$t6,	$t6,	$t8
	
	sh	$t9,	0($t6)
	
	
	addi	$t5,	$t5,	-1
	j	jback1


merge_col:
    #Define your code here
    ############################################
    # DELETE THIS CODE. Only here to allow main program to run without fully implementing the function
	move	$t0,	$a0	#address
	move 	$t1,	$a1	#n_row
	move	$t2,	$a2	#n_col
	move	$t3,	$a3	#col
	lw	$t4,	0($sp)  #dir
	
	blt	$a1,	2,	quit
	blt	$a2,	2,	quit
	bltz	$t3,	quit
	bge	$t3,	$t2,	quit
	
	beqz	$t4,	botTotTop
	beq	$t4,	1,	topToBot
	li	$v0,	-1
	jr	$ra
	
topToBot:
	li	$t5,	1  #int i=1	
    	forBtoT:
    		beq	$t5,	$t1,	forBtoTDone	
    		
    		move	$t6,	$t0 #address
    		
		move	$t7,	$t2
		sll	$t7,	$t7,	1  #obj(2)*n_col
		mul	$t7,	$t7,	$t5 #obj(2)*n_col*i
		move	$t8,	$t3 
		sll	$t8,	$t8,	1 #sizeof*j

		add	$t6,	$t6,	$t7
		add	$t6,	$t6,	$t8
		
		lh	$t9,	0($t6)
		beq	$t9,	-1,	skipMerge2
		##############################################
    		addi	$t5,	$t5,	-1
    		move	$t6,	$t0 #address
    		
		move	$t7,	$t2
		sll	$t7,	$t7,	1  #obj(2)*n_col
		mul	$t7,	$t7,	$t5 #obj(2)*n_col*i
		move	$t8,	$t3 
		sll	$t8,	$t8,	1 #sizeof*j

		add	$t6,	$t6,	$t7
		add	$t6,	$t6,	$t8
		
		lh	$t4,	0($t6)
		
		beq	$t4,	$t9,	addBtoT
    jback2:
    		lw	$t4,	0($sp)  #dir
		addi	$t5,	$t5,	1
    
    
    skipMerge2:
    		addi	$t5,	$t5,	1
    		j	forBtoT
forBtoTDone:
	li $v0, 0    
    ############################################
    jr $ra
 addBtoT:
 	add	$t4,	$t4,	$t9
	
	move	$t6,	$t0 	#address
	move	$t7,	$t2
	sll	$t7,	$t7,	1  #obj(2)*n_col
	mul	$t7,	$t7,	$t5 #obj(2)*n_col*i
	move	$t8,	$t3 
	sll	$t8,	$t8,	1 #sizeof*j

	add	$t6,	$t6,	$t7
	add	$t6,	$t6,	$t8
	sh	$t4,	0($t6)
	#########################################
	addi	$t5,	$t5,	1
	move	$t6,	$t0 #address
	move	$t7,	$t2
	sll	$t7,	$t7,	1  #obj(2)*n_col
	mul	$t7,	$t7,	$t5 #obj(2)*n_col*i
	move	$t8,	$t3 
	sll	$t8,	$t8,	1 #sizeof*j

	add	$t6,	$t6,	$t7
	add	$t6,	$t6,	$t8

	li	$t4,	-1
	sh	$t4,	0($t6)
	addi	$t5,	$t5,	-1
	j	jback2
    
botTotTop:
	addi	$t5,	$t1,	-1  #int i=.length	
    	forTtoB:
    		blez	$t5,		forTtoLDone	
    		
    		move	$t6,	$t0 #address
    		
		move	$t7,	$t2
		sll	$t7,	$t7,	1  #obj(2)*n_col
		mul	$t7,	$t7,	$t5 #obj(2)*n_col*i
		move	$t8,	$t3 
		sll	$t8,	$t8,	1 #sizeof*j

		add	$t6,	$t6,	$t7
		add	$t6,	$t6,	$t8
		
		lh	$t9,	0($t6)
		beq	$t9,	-1,	skipMerge3
		##############################################
    		addi	$t5,	$t5,	-1
    		move	$t6,	$t0 #address
    		
		move	$t7,	$t2
		sll	$t7,	$t7,	1  #obj(2)*n_col
		mul	$t7,	$t7,	$t5 #obj(2)*n_col*i
		move	$t8,	$t3 
		sll	$t8,	$t8,	1 #sizeof*j

		add	$t6,	$t6,	$t7
		add	$t6,	$t6,	$t8
		
		lh	$t4,	0($t6)
		
		beq	$t4,	$t9,	addTtoB
    jback3:
    		lw	$t4,	0($sp)  #dir
		addi	$t5,	$t5,	1
    
    
    skipMerge3:
    		addi	$t5,	$t5,	-1
    		j	forTtoB
forTtoLDone:   
	li $v0,0 
    ############################################
    jr $ra
 addTtoB:
 	add	$t9,	$t4,	$t9
	
	move	$t6,	$t0 	#address
	move	$t7,	$t2
	sll	$t7,	$t7,	1  #obj(2)*n_col
	mul	$t7,	$t7,	$t5 #obj(2)*n_col*i
	move	$t8,	$t3 
	sll	$t8,	$t8,	1 #sizeof*j

	add	$t6,	$t6,	$t7
	add	$t6,	$t6,	$t8
	
	li	$t4,	-1
	sh	$t4,	0($t6)
	
	#########################################
	addi	$t5,	$t5,	1
	move	$t6,	$t0 #address
	move	$t7,	$t2
	sll	$t7,	$t7,	1  #obj(2)*n_col
	mul	$t7,	$t7,	$t5 #obj(2)*n_col*i
	move	$t8,	$t3 
	sll	$t8,	$t8,	1 #sizeof*j

	add	$t6,	$t6,	$t7
	add	$t6,	$t6,	$t8
	
	sh	$t9,	0($t6)
	
	
	addi	$t5,	$t5,	-1
	j	jback3


shift_row:
    #Define your code here
    ############################################
    # DELETE THIS CODE. Only here to allow main program to run without fully implementing the function
	move	$t0,	$a0	#address
	move 	$t1,	$a1	#n_row
	move	$t2,	$a2	#n_col
	move	$t3,	$a3	#row
	lw	$t4,	0($sp)  #dir

	blt	$a1,	2,	quit
	blt	$a2,	2,	quit
    
	bltz	$t3,	quit
	bge	$t3,	$t1,	quit
	
	addi	$sp	$sp	-8
	sw	$s0,	0($sp)
	sw	$s1,	4($sp)
	
	beqz	$t4,	shiftToLeft
	beq	$t4,	1,	shiftToRight
	li	$v0,	-1
	
	lw	$s1,	4($sp)
	lw	$s0,	0($sp)
	addi	$sp	$sp	8
	
	jr	$ra
    
shiftToLeft:
	li	$t5,	1  #int i=1
	forShiftLeft:
		beq	$t5,	$t2,	forShiftDone
	
		move	$t6,	$t0 #address
		move	$t7,	$t2
		sll	$t7,	$t7,	1  #obj(2)*n_col
		mul	$t7,	$t7,	$t3 #obj(2)*n_col*i
		move	$t8,	$t5 
		sll	$t8,	$t8,	1 #sizeof*j
		add	$t6,	$t6,	$t7
		add	$t6,	$t6,	$t8

		lh	$t9,	0($t6)		#target
		
		
		
		beq	$t9,	-1,	skipMove
		
		move	$s0,	$t5	# int j=i, j--
		forMove:
			blez	$s0,	skipMove
			addi	$s0,	$s0,	-1
			move	$t6,	$t0 #address
			move	$t7,	$t2
			sll	$t7,	$t7,	1  #obj(2)*n_col
			mul	$t7,	$t7,	$t3 #obj(2)*n_col*i
			move	$t8,	$s0 
			sll	$t8,	$t8,	1 #sizeof*j
			add	$t6,	$t6,	$t7
			add	$t6,	$t6,	$t8
			lh	$t8,	0($t6)		#number before target	

			beq	$t8,	-1,	moveBlock  

	skipMove:
    		addi	$t5,	$t5,	1
    		j	forShiftLeft
    
forShiftDone: 
	lw	$s1,	4($sp)  
	lw	$s0,	0($sp)
	addi	$sp	$sp	8
	li	$v0,	0
    ############################################
    jr $ra
    
moveBlock:
	sh	$t9,	0($t6)
	
	addi	$s0,	$s0,	1
	move	$t6,	$t0 #address
	move	$t7,	$t2
	sll	$t7,	$t7,	1  #obj(2)*n_col
	mul	$t7,	$t7,	$t3 #obj(2)*n_col*i
	move	$t8,	$s0 
	sll	$t8,	$t8,	1 #sizeof*j
	add	$t6,	$t6,	$t7
	add	$t6,	$t6,	$t8
	
	li	$t8,	-1
	sh	$t8,	0($t6)
	
	addi	$s0,	$s0,	-1
	j	forMove
    
##################    shiftTo Right      ##########################
shiftToRight:
	addi	$t5,	$t2,	-2
	forShiftRight:
		bltz	$t5,	forShiftDone1
	
		move	$t6,	$t0 #address
		move	$t7,	$t2
		sll	$t7,	$t7,	1  #obj(2)*n_col
		mul	$t7,	$t7,	$t3 #obj(2)*n_col*i
		move	$t8,	$t5 
		sll	$t8,	$t8,	1 #sizeof*j
		add	$t6,	$t6,	$t7
		add	$t6,	$t6,	$t8

		lh	$t9,	0($t6)		#target
		
		beq	$t9,	-1,	skipMove1
		
		move	$s0,	$t5	# int j=i, j--
		forMove1:
			addi	$s1,	$t2,	-1
			bge	$s0,	$s1,	skipMove1
			addi	$s0,	$s0,	1
			move	$t6,	$t0 #address
			move	$t7,	$t2
			sll	$t7,	$t7,	1  #obj(2)*n_col
			mul	$t7,	$t7,	$t3 #obj(2)*n_col*i
			move	$t8,	$s0 
			sll	$t8,	$t8,	1 #sizeof*j
			add	$t6,	$t6,	$t7
			add	$t6,	$t6,	$t8
			lh	$t8,	0($t6)		#number after target	

			beq	$t8,	-1,	moveBlock1  

	skipMove1:
    		addi	$t5,	$t5,	-1
    		j	forShiftRight
    
forShiftDone1: 
	lw	$s1,	4($sp)  
	lw	$s0,	0($sp)
	addi	$sp	$sp	8
	li	$v0,	0
    ############################################
    jr $ra
    
moveBlock1:
	sh	$t9,	0($t6)
	
	addi	$s0,	$s0,	-1
	move	$t6,	$t0 #address
	move	$t7,	$t2
	sll	$t7,	$t7,	1  #obj(2)*n_col
	mul	$t7,	$t7,	$t3 #obj(2)*n_col*i
	move	$t8,	$s0 
	sll	$t8,	$t8,	1 #sizeof*j
	add	$t6,	$t6,	$t7
	add	$t6,	$t6,	$t8
	
	li	$t8,	-1
	sh	$t8,	0($t6)
	
	addi	$s0,	$s0,	1
	j	forMove1

shift_col:
    #Define your code here
    ############################################
    # DELETE THIS CODE. Only here to allow main program to run without fully implementing the function
    	move	$t0,	$a0	#address
	move 	$t1,	$a1	#n_row
	move	$t2,	$a2	#n_col
	move	$t3,	$a3	#row
	lw	$t4,	0($sp)  #dir
    
    	blt	$a1,	2,	quit
	blt	$a2,	2,	quit
	
	bltz	$t3,	quit
	bge	$t3,	$t2,	quit
    
    	addi	$sp	$sp	-8
	sw	$s0,	0($sp)
	sw	$s1,	4($sp)
    
    
    	beqz	$t4,	shiftToUp
	beq	$t4,	1,	shiftToDown
	li	$v0,	-1
    
    	lw	$s1,	4($sp)
	lw	$s0,	0($sp)
	addi	$sp	$sp	8
	
	jr	$ra
    	
shiftToUp:
	li	$t5,	1  #int i=1
	forShiftUp:
		beq	$t5,	$t1,	forShiftDone2
	
		move	$t6,	$t0 #address
		move	$t7,	$t2
		sll	$t7,	$t7,	1  #obj(2)*n_col
		mul	$t7,	$t7,	$t5 #obj(2)*n_col*i
		move	$t8,	$t3 
		sll	$t8,	$t8,	1 #sizeof*j

		add	$t6,	$t6,	$t7
		add	$t6,	$t6,	$t8

		lh	$t9,	0($t6)		#target

		beq	$t9,	-1,	skipMove2
		
		move	$s0,	$t5	# int j=i, j--
		forMove2:
			blez	$s0,	skipMove2
			addi	$s0,	$s0,	-1
			move	$t6,	$t0 #address
			move	$t7,	$t2
			sll	$t7,	$t7,	1  #obj(2)*n_col
			mul	$t7,	$t7,	$s0 #obj(2)*n_col*i
			move	$t8,	$t3 
			sll	$t8,	$t8,	1 #sizeof*j

			add	$t6,	$t6,	$t7
			add	$t6,	$t6,	$t8
			lh	$t8,	0($t6)		#number before target	

			beq	$t8,	-1,	moveBlock2  

	skipMove2:
    		addi	$t5,	$t5,	1
    		j	forShiftUp
    
forShiftDone2:
	lw	$s1,	4($sp)  
	lw	$s0,	0($sp)
	addi	$sp	$sp	8
	li	$v0,	0
    ############################################
    jr $ra
    
moveBlock2:
	sh	$t9,	0($t6)
	
	addi	$s0,	$s0,	1
	move	$t6,	$t0 #address
	move	$t7,	$t2
	sll	$t7,	$t7,	1  #obj(2)*n_col
	mul	$t7,	$t7,	$s0 #obj(2)*n_col*i
	move	$t8,	$t3 
	sll	$t8,	$t8,	1 #sizeof*j

	add	$t6,	$t6,	$t7
	add	$t6,	$t6,	$t8
	
	li	$t8,	-1
	sh	$t8,	0($t6)
	
	addi	$s0,	$s0,	-1
	j	forMove2
	
 ##############################################################   
 shiftToDown:
	addi	$t5,	$t1,	-2
	forShiftDown:
		bltz	$t5,	forShiftDone3
	
		move	$t6,	$t0 #address
		move	$t7,	$t2
		sll	$t7,	$t7,	1  #obj(2)*n_col
		mul	$t7,	$t7,	$t5 #obj(2)*n_col*i
		move	$t8,	$t3 
		sll	$t8,	$t8,	1 #sizeof*j

		add	$t6,	$t6,	$t7
		add	$t6,	$t6,	$t8

		lh	$t9,	0($t6)		#target

		beq	$t9,	-1,	skipMove3
		
		move	$s0,	$t5	# int j=i, j--
		forMove3:
			addi	$s1,	$t1,	-1
			bge	$s0,	$t1,	skipMove3
			addi	$s0,	$s0,	1
			move	$t6,	$t0 #address
			move	$t7,	$t2
			sll	$t7,	$t7,	1  #obj(2)*n_col
			mul	$t7,	$t7,	$s0 #obj(2)*n_col*i
			move	$t8,	$t3 
			sll	$t8,	$t8,	1 #sizeof*j

			add	$t6,	$t6,	$t7
			add	$t6,	$t6,	$t8
			lh	$t8,	0($t6)		#number before target	

			beq	$t8,	-1,	moveBlock3  

	skipMove3:
    		addi	$t5,	$t5,	-1
    		j	forShiftDown
    
forShiftDone3:
	lw	$s1,	4($sp)  
	lw	$s0,	0($sp)
	addi	$sp	$sp	8
	li	$v0,	0
    ############################################
    jr $ra
    
moveBlock3:
	sh	$t9,	0($t6)
	
	addi	$s0,	$s0,	-1
	move	$t6,	$t0 #address
	move	$t7,	$t2
	sll	$t7,	$t7,	1  #obj(2)*n_col
	mul	$t7,	$t7,	$s0 #obj(2)*n_col*i
	move	$t8,	$t3 
	sll	$t8,	$t8,	1 #sizeof*j

	add	$t6,	$t6,	$t7
	add	$t6,	$t6,	$t8
	
	li	$t8,	-1
	sh	$t8,	0($t6)
	
	addi	$s0,	$s0,	1
	j	forMove3
    
    
    li	$v0,	0
    ############################################
    jr $ra   
    
    


check_state:
    #Define your code here
    ############################################
    # DELETE THIS CODE. Only here to allow main program to run without fully implementing the function
    move	$t0,	$a0
    move	$t1,	$a1
    move	$t2,	$a2
    
    li	$t3,	0	#int i=0
    li	$t4,	0	#int j=0
    
    addi	$sp	$sp	-24
    sw		$s0,	0($sp)
    sw		$s1,	4($sp)  
    sw		$s2,	8($sp)
    sw		$s3,	12($sp)
    sw		$s4,	16($sp)
    sw	$s5,	20($sp)
    
    li		$s0,	0 #has no empty
    li		$s1,	0 #has no adjecent  
    forRow1:
	beq	$t3,	$t1,	rowDone1
	forCol1:
		beq	$t4,	$t2,	colDone1
		
		#
		li	$t6,	2
		mul	$t6,	$t6,	$t4 #(sizeof obj)*j
		li	$t7,	2
		mul	$t7,	$t7,	$t2 #row_size=n_col*sizeof(obj)
		mul	$t7,	$t7,	$t3 #row_size*i
		move	$t0,	$a0
		add	$t0,	$t0,	$t6
		add	$t0,	$t0,	$t7
		#
		
		lh	$t5,	0($t0)			#target
		
	
		
		bge	$t5,	2048,	win
		beq	$t5,	-1,	hasEmpty
		
		
		addi	$t3,	$t3,	-1
		bltz	$t3,	skipUp
		#
		li	$t6,	2
		mul	$t6,	$t6,	$t4 #(sizeof obj)*j
		li	$t7,	2
		mul	$t7,	$t7,	$t2 #row_size=n_col*sizeof(obj)
		mul	$t7,	$t7,	$t3 #row_size*i
		move	$t0,	$a0
		add	$t0,	$t0,	$t6
		add	$t0,	$t0,	$t7
		lh	$s2,	0($t0)
		#
		beq	$t5,	$s2,	hasAdj1	#up	
		
		skipUp:
		addi	$t3,	$t3,	1
		addi	$t4,	$t4,	-1
		bltz	$t4,	skipLeft
		#
		li	$t6,	2
		mul	$t6,	$t6,	$t4 #(sizeof obj)*j
		li	$t7,	2
		mul	$t7,	$t7,	$t2 #row_size=n_col*sizeof(obj)
		mul	$t7,	$t7,	$t3 #row_size*i
		move	$t0,	$a0
		add	$t0,	$t0,	$t6
		add	$t0,	$t0,	$t7
		lh	$s3,	0($t0)
		#
		beq	$t5,	$s3,	hasAdj2	#left
		
		skipLeft:
		addi	$t4,	$t4,	1
		addi	$t3,	$t3,	1
		bge	$t3,	$a1,	skipDown
		#
		li	$t6,	2
		mul	$t6,	$t6,	$t4 #(sizeof obj)*j
		li	$t7,	2
		mul	$t7,	$t7,	$t2 #row_size=n_col*sizeof(obj)
		mul	$t7,	$t7,	$t3 #row_size*i
		move	$t0,	$a0
		add	$t0,	$t0,	$t6
		add	$t0,	$t0,	$t7
		lh	$s4,	0($t0)
		#
		beq	$t5,	$s4,	hasAdj3	#down
		
		skipDown:
		addi	$t3,	$t3,	-1
		addi	$t4,	$t4,	1
		bge	$t4,	$a2,	skipRight
		#
		li	$t6,	2
		mul	$t6,	$t6,	$t4 #(sizeof obj)*j
		li	$t7,	2
		mul	$t7,	$t7,	$t2 #row_size=n_col*sizeof(obj)
		mul	$t7,	$t7,	$t3 #row_size*i
		move	$t0,	$a0
		add	$t0,	$t0,	$t6
		add	$t0,	$t0,	$t7
		lh	$s5,	0($t0)
		#
		beq	$t5,	$s5,	hasAdj4	#right
		skipRight:
		addi	$t4,	$t4,	-1
		

		
		jback00000000000:
		
		
		addi	$t4,	$t4,	1
		j	forCol1
	colBack1:
	addi	$t3,	$t3,	1
	j	forRow1
	###########################################
win:	
	lw		$s2,	8($sp)
    lw		$s3,	12($sp)
    lw		$s4,	16($sp)
    lw	$s5,	20($sp)
	lw		$s1,	4($sp)
	lw		$s0,	0($sp)
	addi	$sp	$sp	24
	li	$v0,	1
	jr	$ra
rowDone1:
	beq	$s0,	1,	others
	beq	$s0,	0,	hasNoEmpty
hasNoEmpty:
	beq	$s1,	0,	lost
	beq	$s1,	1,	others


colDone1:
	li	$t4,	0
	j	colBack1
    
hasEmpty:
	li	$s0,	1 #there is empty
	j	jback00000000000 
    
others:
	 lw		$s2,	8($sp)
    lw		$s3,	12($sp)
    lw		$s4,	16($sp)
    lw	$s5,	20($sp)
	lw		$s1,	4($sp)
	lw		$s0,	0($sp)
	addi	$sp	$sp	24
	li	$v0, 0
	jr 	$ra    
    
 lost:
 	lw		$s2,	8($sp)
    lw		$s3,	12($sp)
    lw		$s4,	16($sp)
    lw	$s5,	20($sp)
	lw		$s1,	4($sp)
	lw		$s0,	0($sp)
	addi	$sp	$sp	24
 	li $v0,	-1
 	jr 	$ra   
 
hasAdj1:
	li	$s1,	1
	j	skipUp  

hasAdj2:
	li	$s1,	1
	j skipLeft
hasAdj3:
	li	$s1,	1
	j skipDown

hasAdj4	:
	li	$s1,	1
	j skipRight
      

user_move:
    #Define your code here
    ############################################
    # DELETE THIS CODE. Only here to allow main program to run without fully implementing the function
	move	$t0,	$a0	#address
	move	$t1,	$a1	#n_row
	move	$t2,	$a2	#n_col
	move	$t3,	$a3	
	
	
	
	beq	$t3,	'L',	left
	beq	$t3,	'R',	right
	beq	$t3,	'U',	up
	beq	$t3,	'D',	down
	li	$v0,	-1
	li	$v1,	-1
	jr	$ra
  
left:
	addi	$sp	$sp	-24
	sw	$t0,	0($sp)
	sw 	$t1,	4($sp)
	sw	$t2,	8($sp)
	sw	$t3,	12($sp)
	sw	$ra,	16($sp)
	sw	$s0,	20($sp)

	li	$s0,	0	#int i=0
forLeft:
	lw	$t1,	4($sp)
	beq	$s0,	$t1,	forLeftDone
	
	lw	$a0,	0($sp)
	lw	$a1,	4($sp)
	lw	$a2,	8($sp)
	move	$a3,	$s0
	addi	$sp,	$sp,	-4
	li	$t9,	0
	sw	$t9	0($sp)
	
	jal	shift_row
	addi	$sp,	$sp,	4
	beq	$v0,	-1,	finalExam
	
	lw	$a0,	0($sp)
	lw	$a1,	4($sp)
	lw	$a2,	8($sp)
	move	$a3,	$s0
	addi	$sp,	$sp,	-4
	li	$t9,	0
	sw	$t9	0($sp)
	jal	merge_row
	addi	$sp,	$sp,	4
	beq	$v0,	-1,	finalExam
	
	lw	$a0,	0($sp)
	lw	$a1,	4($sp)
	lw	$a2,	8($sp)
	move	$a3,	$s0
	addi	$sp,	$sp,	-4
	li	$t9,	0
	sw	$t9	0($sp)
	jal	shift_row
	addi	$sp,	$sp,	4
	beq	$v0,	-1,	finalExam

	addi	$s0,	$s0,	1
	j	forLeft
	
forLeftDone:
    ############################################
    lw	$a0,	0($sp)
	lw	$a1,	4($sp)
	lw	$a2,	8($sp)
	jal	check_state
	
	move	$v1,	$v0
	li	$v0,	0	
    lw	$s0,	20($sp)
    
    lw	$ra,	16($sp)
    addi	$sp,	$sp,	24
    jr $ra

finalExam:
	li	$v0,	-1
	li	$v1,	-1
	lw	$s0,	20($sp)
	lw	$ra,	16($sp)
    	addi	$sp,	$sp,	24
	jr	$ra

right:
	addi	$sp	$sp	-24
	sw	$t0,	0($sp)
	sw 	$t1,	4($sp)
	sw	$t2,	8($sp)
	sw	$t3,	12($sp)
	sw	$ra,	16($sp)
	sw	$s0,	20($sp)

	li	$s0,	0	#int i=0
forRight:
	lw	$t1,	4($sp)
	beq	$s0,	$t1,	forRightDone
	
	lw	$a0,	0($sp)
	lw	$a1,	4($sp)
	lw	$a2,	8($sp)
	move	$a3,	$s0
	addi	$sp,	$sp,	-4
	li	$t9,	1
	sw	$t9	0($sp)
	
	jal	shift_row
	addi	$sp,	$sp,	4
	beq	$v0,	-1,	finalExam
	
	lw	$a0,	0($sp)
	lw	$a1,	4($sp)
	lw	$a2,	8($sp)
	move	$a3,	$s0
	addi	$sp,	$sp,	-4
	li	$t9,	1
	sw	$t9	0($sp)
	jal	merge_row
	addi	$sp,	$sp,	4
	beq	$v0,	-1,	finalExam
	
	lw	$a0,	0($sp)
	lw	$a1,	4($sp)
	lw	$a2,	8($sp)
	move	$a3,	$s0
	addi	$sp,	$sp,	-4
	li	$t9,	1
	sw	$t9	0($sp)
	jal	shift_row
	addi	$sp,	$sp,	4
	beq	$v0,	-1,	finalExam

	addi	$s0,	$s0,	1
	j	forRight
	
forRightDone:
    ############################################
    lw	$a0,	0($sp)
	lw	$a1,	4($sp)
	lw	$a2,	8($sp)
	jal	check_state
	
	move	$v1,	$v0
	li	$v0,	0	
    lw	$s0,	20($sp)
    
    lw	$ra,	16($sp)
    addi	$sp,	$sp,	24
    jr $ra
    
    
    up:
	addi	$sp	$sp	-24
	sw	$t0,	0($sp)
	sw 	$t1,	4($sp)
	sw	$t2,	8($sp)
	sw	$t3,	12($sp)
	sw	$ra,	16($sp)
	sw	$s0,	20($sp)

	li	$s0,	0	#int i=0
forUp:
	lw	$t1,	4($sp)
	beq	$s0,	$t2,	forupDone
	
	lw	$a0,	0($sp)
	lw	$a1,	4($sp)
	lw	$a2,	8($sp)
	move	$a3,	$s0
	addi	$sp,	$sp,	-4
	li	$t9,	0
	sw	$t9	0($sp)
	
	jal	shift_col
	addi	$sp,	$sp,	4
	beq	$v0,	-1,	finalExam
	
	lw	$a0,	0($sp)
	lw	$a1,	4($sp)
	lw	$a2,	8($sp)
	move	$a3,	$s0
	addi	$sp,	$sp,	-4
	li	$t9,	1
	sw	$t9	0($sp)
	jal	merge_col
	addi	$sp,	$sp,	4
	beq	$v0,	-1,	finalExam
	
	lw	$a0,	0($sp)
	lw	$a1,	4($sp)
	lw	$a2,	8($sp)
	move	$a3,	$s0
	addi	$sp,	$sp,	-4
	li	$t9,	0
	sw	$t9	0($sp)
	jal	shift_col
	addi	$sp,	$sp,	4
	beq	$v0,	-1,	finalExam

	addi	$s0,	$s0,	1
	j	forUp
	
forupDone:
    ############################################
    lw	$a0,	0($sp)
	lw	$a1,	4($sp)
	lw	$a2,	8($sp)
	jal	check_state
	
	move	$v1,	$v0
	li	$v0,	0	
    lw	$s0,	20($sp)
    
    lw	$ra,	16($sp)
    addi	$sp,	$sp,	24
    jr $ra
    
     down:
	addi	$sp	$sp	-24
	sw	$t0,	0($sp)
	sw 	$t1,	4($sp)
	sw	$t2,	8($sp)
	sw	$t3,	12($sp)
	sw	$ra,	16($sp)
	sw	$s0,	20($sp)

	li	$s0,	0	#int i=0
forDown:
	lw	$t1,	4($sp)
	beq	$s0,	$t2,	fordownDone
	
	lw	$a0,	0($sp)
	lw	$a1,	4($sp)
	lw	$a2,	8($sp)
	move	$a3,	$s0
	addi	$sp,	$sp,	-4
	li	$t9,	1
	sw	$t9	0($sp)
	
	jal	shift_col
	addi	$sp,	$sp,	4
	beq	$v0,	-1,	finalExam
	
	lw	$a0,	0($sp)
	lw	$a1,	4($sp)
	lw	$a2,	8($sp)
	move	$a3,	$s0
	addi	$sp,	$sp,	-4
	li	$t9,	0
	sw	$t9	0($sp)
	jal	merge_col
	addi	$sp,	$sp,	4
	beq	$v0,	-1,	finalExam
	
	lw	$a0,	0($sp)
	lw	$a1,	4($sp)
	lw	$a2,	8($sp)
	move	$a3,	$s0
	addi	$sp,	$sp,	-4
	li	$t9,	1
	sw	$t9	0($sp)
	jal	shift_col
	addi	$sp,	$sp,	4
	beq	$v0,	-1,	finalExam

	addi	$s0,	$s0,	1
	j	forDown
	
fordownDone:
    ############################################
    lw	$a0,	0($sp)
	lw	$a1,	4($sp)
	lw	$a2,	8($sp)
	jal	check_state
	
	move	$v1,	$v0
	li	$v0,	0	
    lw	$s0,	20($sp)
    
    lw	$ra,	16($sp)
    addi	$sp,	$sp,	24
    jr $ra







#################################################################
# Student defined data section
#################################################################
.data
.align 2  # Align next items to word boundary

#place all data declarations here


