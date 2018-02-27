.include "hw3_examples.asm"


.data
str1: .asciiz ""
str2: .asciiz "1"	

.text
.globl _start

_start:
la $a0,queen_all_unsorted
li $a1,	5
la $a2,	msg_buffer
li $a3,	80
#jal extractUnorderedData

move $a0, $v0
li $v0, 1
#syscall

move $a0, $v1
li $v0, 1
#syscall
	
la $a0,	queen_holes_unsorted
li $a1,	4
la $a2,	msg_buffer
la $a3,	str_array
li $t0,	80

addi	$sp	$sp	-4
sw	$t0	($sp)
#jal printUnorderedDatagram
addi	$sp	$sp	4

la	$a0,	str1
la	$a1,	str2
li	$a2,	0
li	$a3,	1
jal	editDistance

move $a0, $v0
li $v0, 1
syscall


li $v0, 10
syscall


.include "hw3.asm"
