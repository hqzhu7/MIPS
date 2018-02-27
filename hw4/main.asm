.data
address: .word 0xffff0000


.text
.globl _start

_start:
la	$t0,	address

lw	$a0,	0($t0)
li	$a1,	3
li	$a2,	3
li	$a3,	0 #r1

addi	$sp,	$sp,	-12
li	$t0,	0	#c1
li	$t1,	0	#r2
li	$t2,	2	#c2
sw	$t2,	8($sp) #c2
sw	$t1,	4($sp) #r2
sw	$t0,	0($sp) #c1

jal 	start_game
addi	$sp,	$sp,	12


la	$t0,	address
lw	$a0,	0($t0)
li	$a1,	3
li	$a2,	3
li	$a3,	0
addi	$sp,	$sp,	-8
li	$t0,	1	#col
li	$t1,	2	#val
sw	$t0,	0($sp)  #col
sw	$t1,	4($sp)	#val
jal	place
addi	$sp,	$sp,	8

la	$t0,	address
lw	$a0,	0($t0)
li	$a1,	3
li	$a2,	3
li	$a3,	1
addi	$sp,	$sp,	-8
li	$t0,	0	#col
li	$t1,	2	#val
sw	$t0,	0($sp)  #col
sw	$t1,	4($sp)	#val
jal	place
addi	$sp,	$sp,	8

la	$t0,	address
lw	$a0,	0($t0)
li	$a1,	3
li	$a2,	3
li	$a3,	1
addi	$sp,	$sp,	-8
li	$t0,	1	#col
li	$t1,	2	#val
sw	$t0,	0($sp)  #col
sw	$t1,	4($sp)	#val
jal	place
addi	$sp,	$sp,	8

la	$t0,	address
lw	$a0,	0($t0)
li	$a1,	3
li	$a2,	3
li	$a3,	1
addi	$sp,	$sp,	-8
li	$t0,	2	#col
li	$t1,	2	#val
sw	$t0,	0($sp)  #col
sw	$t1,	4($sp)	#val
jal	place
addi	$sp,	$sp,	8

la	$t0,	address
lw	$a0,	0($t0)
li	$a1,	3
li	$a2,	3
li	$a3,	2
addi	$sp,	$sp,	-8
li	$t0,	0	#col
li	$t1,	2	#val
sw	$t0,	0($sp)  #col
sw	$t1,	4($sp)	#val
jal	place
addi	$sp,	$sp,	8

la	$t0,	address
lw	$a0,	0($t0)
li	$a1,	3
li	$a2,	3
li	$a3,	2
addi	$sp,	$sp,	-8
li	$t0,	2	#col
li	$t1,	2	#val
sw	$t0,	0($sp)  #col
sw	$t1,	4($sp)	#val
jal	place
addi	$sp,	$sp,	8

la	$t0,	address
lw	$a0,	0($t0)
li	$a1,	3
li	$a2,	3
li	$a3,	2
addi	$sp,	$sp,	-8
li	$t0,	1	#col
li	$t1,	2	#val
sw	$t0,	0($sp)  #col
sw	$t1,	4($sp)	#val
jal	place
addi	$sp,	$sp,	8


###############################

la	$t0,	address
lw	$a0,	0($t0)

li	$a1,	3
li	$a2,	3
li	$a3,	0 #col
addi	$sp,	$sp,	-4
li	$t2,	0
sw	$t2,	0($sp)
#jal	merge_col
addi	$sp,	$sp,	4
#################################
la	$t0,	address
lw	$a0,	0($t0)
li	$a1,	2
li	$a2,	8
li	$a3,	0 #row
addi	$sp,	$sp,	-4
li	$t2,	1 #direction
sw	$t2,	0($sp)
#jal	shift_row
addi	$sp,	$sp,	4

li	$a0,	0xffff0000
li	$a1,	8
li	$a2,	2
li	$a3,	0 #col
addi	$sp,	$sp,	-4
li	$t2,	1 #direction
sw	$t2,	0($sp)
#jal	shift_col
addi	$sp,	$sp,	4



la	$t0,	address
lw	$a0,	0($t0)
li	$a1,	3
li	$a2,	3
#jal	check_state


la	$t0,	address
lw	$a0,	0($t0)
li	$a1,	3
li	$a2,	3
#jal	check_state

la	$t0,	address
lw	$a0,	0($t0)
li	$a1,	3
li	$a2,	3
li	$a3,	'D'
jal	user_move


li	$v0	10
syscall


	

.include "hw4.asm"
