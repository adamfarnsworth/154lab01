  .data # Data declaration section
    #globals
    emptyArrayC: .space 32 #1 word = 4 bytes, 8 words = 32 bytes
    emptyArrayD: .space 32 #1 word = 4 bytes, 8 words = 32 bytes    
    wordSet1: .word 1, 2, 3, 4, 5, 6, 7, 8
    wordSet2: .word 0, 2, 4, 8, 16, 32, 64, 128

  .text # Assembly language instructions

# a0 = A[]
# a1 = B[]
# s3 = C[]
# s4 = D[]
# t0 = temp
# t1 = Count
# t2 = offset A
# t3 = offset B
# t4 = current word in A[i]
# t5 = current word in B[i]
# t6 = overflow
# t7 = current half of A[i]
# t8 = current half of B[i]
# s0 = exit condition
# s1 = left hand side
# s2 = right hand side

main:

  la		$a0, wordSet1		        # A = first set of words
  la		$a1, wordSet2		        # B = second set of words  
  la		$s3, emptyArrayC	      # declairing "C"
  la		$s4, emptyArrayD	      # declairing "D" 
  move 	$s0, $zero		          # exit condition = 0  
  move 	$t1, $zero		          # Count = 0
  move  $t6, $zero              # overflow = 0
  
  li  $v0, 1 
  syscall
#___________________________________________________________________________
# Addition
#___________________________________________________________________________  
startAdd:
  # getting position for next value
  sll   $t2, $t1, 2             # offset A = count*4
  addu	$t2, $t2, $a0		        # offset A = offset + &A
  sll   $t3, $t1, 2             # offset B = count*4
  add		$t3, $t3, $a1		        # offset B = offset + &B

  #loading values at current position
  lw		$t4, 0($t2)		          # $t4 = A[i]
  lw		$t5, 0($t3)		          # $t5 = B[i]  

  # adding right side
sll   $t7, $t4, 16              # xx..xx00..00
srl   $t7, $t7, 16              # 00..00xx..xx
sll   $t8, $t5, 16              # xx..xx00..00
srl   $t8, $t8, 16              # 00..00xx..xx 
add   $s2, $t7, $t8             # rhs = rhsA[i] + rhsB[i]
add   $s2, $s2, $t6             # rhs = rhs + 0 or 1 
bgt		$s2, 32767, bitCarryRHS	  # if rhs > maxInt then bitCarry
move	$t6, $zero		            # overflow = flase   
j		continueRHS				          # jump to else
bitCarryRHS:
  li		$t6, 1		              # overflow = true 

continueRHS:
  # adding left side
  srl   $t7, $t4, 16              # 00..00xx..xx
  srl   $t8, $t5, 16              # 00..00xx..xx 
  add   $s1, $t7, $t8             # LHS = lhsA[i] + lhsB[i]
  add   $s1, $s1, $t6             # LHS = LHS + 0 or 1
  bgt		$s1, 32767, bitCarryLHS	  # if LHS > maxInt then bitCarry
  move	$t6, $zero		            # overflow = flase   
  j		continueLHS				          # jump to else
  bitCarryLHS:
    li		$t6, 1		              # overflow = true 
continueLHS:
  sll   $s1, $s1, 16             # xx..xx00..00
  # add LHS and RHS together
  add   $t0, $s1, $s2            # temp = LHS + RHS
  sw		$t0, 0($s3)		           # C[i] = temp
  sll   $s3, $s3, 4              # i++ 
  
  addi	$t1, $t1, 1			         # Count++
  blt		$t1, 8, startAdd	       # if Count < 8, repeat
  nop

  add   $s0, $s0, 1              # exit condition ++
  beq		$s0, 2, end	             # if $s0 == $t1 then target
  
#___________________________________________________________________________
# Reseting
#___________________________________________________________________________
move 	  $t1, $zero		          # Count = 0
move    $t6, $zero              # overflow = 0

# swapping $s3 and $s4 addresses
#la      $t0, $s4                # temp = s4  
la      $s4, emptyArrayC                # s4 = s3
la      $s3, emptyArrayD                # s3 = temp

# setting B to -B
settingB:
  # getting position for next value
  sll   $t3, $t1, 2             # offset B = count*4
  addu	$t3, $t3, $a1		        # offset B = offset + &B

  lw		$t5, 0($t3)		          # $t5 = B[i]  

  #setting B[i] to -B[i]
  not   $t5, $t5                # flip dem bits
  add   $t5, $t5, 1             # add 1
  add   $t1, $t1, 1             # count ++
  sw		$t5, 0($t3)		          # saving new value
  
  bne		$t1, 8, settingB	      # if count < 8 goto settingB
  

move 	  $t1, $zero		          # Count = 0
b		startAdd			              # branch to startAdd


   
  

end:
move $t1, $zero
  while:
    # getting position for next value
  sll   $t2, $t1, 2             # offset A = count*4
  addu	$t2, $t2, $s4		        # offset A = offset + &A
  lw $t0, 0($t2)
  
  # print current number
  li $v0, 1
  move $a0, $t0
  syscall

  # # print space
  # li $v0, 4
  # la $a0, " "
  # syscall

  add $t1, $t1, 1
  blt		$t1, 8, while	              # if $t1 => 8 while
  
  nop

  exit:
    li $v0, 10
    syscall