  .data # Data declaration section
    #globals go here
  .text # Assembly language instructions

main:
  li $v0, 1
  li $t3, 4
  
  move 	$a0, $t3		# $a0 = $31 $a0, $t3
  syscall 

end: