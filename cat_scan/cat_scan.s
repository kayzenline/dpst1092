########################################################################
# DPST1092 25T2 -- Assignment 1 -- Cat Scan!
#
#
# !!! IMPORTANT !!!
# Before starting work on the assignment, make sure you set your tab-width to 8!
# It is also suggested to indent with tabs only.
# Instructions to configure your text editor can be found here:
#   https://cgi.cse.unsw.edu.au/~dp1092/25T2/resources/mips-editors.html
# !!! IMPORTANT !!!
#
#
# This program was written by JIAWEN LIN (z5647814)
# on 08/06/2025
#
########################################################################

#![tabsize(8)]

# ##########################################################
# ####################### Constants ########################
# ##########################################################

# MIPS syscalls
SYSCALL_PRINT_INT    = 1
SYSCALL_PRINT_STRING = 4
SYSCALL_READ_INT     = 5
SYSCALL_PRINT_CHAR   = 11
SYSCALL_READ_CHAR    = 12
SYSCALL_EXIT2        = 17

# C constants
FALSE = 0
TRUE  = 1

MIN_BOX_SIZE = 4
MAX_BOX_SIZE = 12
MAX_PATHS    = 4 * MAX_BOX_SIZE

AREA_PER_CAT          = 13
POINTS_PER_CAT        = 100
POINT_LOSS_BAD_GUESS  = 25
POINT_GAIN_GOOD_GUESS = 25

CAT_NAME_BUFFER_SIZE = 128
NUM_OF_CAT_TITLES    = 18
NUM_OF_CAT_SURNAMES  = 30

TURN_LEFT  = 0
TURN_RIGHT = 1

INTERACTION_ABSORB        = 0
INTERACTION_REFLECT       = 1
INTERACTION_DEFLECT_LEFT  = 2
INTERACTION_DEFLECT_RIGHT = 3
INTERACTION_NONE          = 4

BALL_INIT = -1
BALL_STATE_ROLLING = 'r'
BALL_STATE_STOPPED = 's'

PATH_ENTRY_NOT_SET = -1
PATH_EXIT_NOT_SET  = -1

PATH_STATE_NOT_CHECKED = 0
PATH_STATE_ABSORBED    = 1
PATH_STATE_REFLECTED   = 2
PATH_STATE_CHECKED     = 3

STATE_PLAYING = 0
STATE_QUIT    = 1
STATE_WIN     = 2
STATE_LOSE    = 3

CMD_QUIT        = 'q'
CMD_HELP        = 'h'
CMD_AUTOPRINT   = 'a'
CMD_PRINT_GAME  = 'p'
CMD_PRINT_STATS = 's'
CMD_GUESS       = 'g'
CMD_ROLL        = 'r'
CMD_CHEAT       = 'c'
CMD_DEBUG       = 'd'

RNG_MULTIPLIER = 75
RNG_INCREMENT  = 74
RNG_MODULUS    = 65537
RNG_MIN_SEED   = 0
RNG_MAX_SEED   = RNG_MODULUS - 2

# Other useful constants
SIZEOF_CHAR = 1
SIZEOF_INT  = 4
SIZEOF_PTR  = 4
SIZEOF_BYTE = 1
SIZEOF_WORD = 4

# Offsets and size of `struct ball_of_string`
OFFSET_BALL_START = 0
OFFSET_BALL_X     = OFFSET_BALL_START + SIZEOF_INT
OFFSET_BALL_Y     = OFFSET_BALL_X     + SIZEOF_INT
OFFSET_BALL_DX    = OFFSET_BALL_Y     + SIZEOF_INT
OFFSET_BALL_DY    = OFFSET_BALL_DX    + SIZEOF_INT
OFFSET_BALL_STATE = OFFSET_BALL_DY    + SIZEOF_INT
# Note: +3 padding bytes to align the struct to a 4-byte boundary
PADDING_BALL = 3
SIZEOF_BALL       = OFFSET_BALL_STATE + SIZEOF_CHAR + PADDING_BALL

# Offsets and size of `struct ball_path`
OFFSET_BALL_PATH_ENTRY = 0
OFFSET_BALL_PATH_EXIT  = OFFSET_BALL_PATH_ENTRY + SIZEOF_INT
OFFSET_BALL_PATH_STATE = OFFSET_BALL_PATH_EXIT  + SIZEOF_INT
SIZEOF_BALL_PATH       = OFFSET_BALL_PATH_STATE + SIZEOF_INT

# Offsets and size of `struct box`
OFFSET_BOX_CONTAINS_CAT = 0
OFFSET_BOX_GUESSED      = MAX_BOX_SIZE * MAX_BOX_SIZE * SIZEOF_INT
SIZEOF_BOX              = MAX_BOX_SIZE * MAX_BOX_SIZE * SIZEOF_INT * 2
SIZEOF_BOX_ARRAY_ROW    = MAX_BOX_SIZE * SIZEOF_INT

# Offsets and size of 'struct game'
OFFSET_GAME_BALL  = 0
OFFSET_GAME_PATHS = OFFSET_GAME_BALL  + SIZEOF_PTR
OFFSET_GAME_BOX   = OFFSET_GAME_PATHS + SIZEOF_PTR
SIZEOF_GAME       = OFFSET_GAME_BOX   + SIZEOF_PTR


############################################################
####                                                    ####
####   Your journey begins here, intrepid adventurer!   ####
####                                                    ####
############################################################

################################################################################
#
# Implement the following functions,
# and check these boxes as you finish implementing each function.
#
#  SUBSET 0
#  - [ ] main
#  - [ ] print_welcome
#  SUBSET 1
#  - [ ] game_setup
#  - [ ] prompt_for_int
#  - [ ] initialise_ball_of_string
#  - [ ] initialise_ball_paths
#  - [ ] initialise_box
#  - [ ] print_stats
#  SUBSET 2
#  - [ ] game_loop
#  - [ ] is_cat_at_position
#  - [ ] do_move_ball_forward
#  - [ ] do_turn_ball
#  - [ ] spawn_cats
#  SUBSET 3
#  - [ ] guess_cat_location
#  - [ ] handle_ball_movement
#  - [ ] generate_cat_name
#  - [ ] roll_ball_of_string
#  PROVIDED
#  - [X] random_in_range
#  - [X] update_random_number
#  - [X] process_command
#  - [X] print_help
#  - [X] print_debug_info
#  - [X] print_smiling_cat
#  - [X] print_crying_cat
#  - [X] configure_ball
#  - [X] check_ball_interactions
#  - [X] edge_number_from_position
#  - [X] print_game
#  - [X] print_game_row_upper
#  - [X] print_game_row_inner
#  - [X] print_game_row_lower
#  - [X] print_grid_row_edge
#  - [X] print_grid_row_edge_upper
#  - [X] print_grid_row_edge_inner
#  - [X] print_grid_row_edge_lower
#  - [X] print_grid_row_cells
#  - [X] print_cell_content
#  - [X] is_position_in_box
#  - [X] is_position_an_edge_number
#  - [X] is_position_a_path_result
#  - [X] print_edge_number


################################################################################
# .TEXT <main>
	.text
main:
	# Subset:   0
	#
	# Frame:    [$ra, $s0]   <-- FILL THESE OUT!
	# Uses:     [$ra, $s0, ]
	# Clobbers: [$ra, $s0, ]
	#
	# Locals:           <-- FILL THIS OUT!
	#   - ...
	#
	# Structure:        <-- FILL THIS OUT!
	#   main
	#   -> [prologue]
	#       -> body
	#   -> [epilogue]


main__prologue:
        push    $ra
       # push    $s0

main__body:
        jal print_welcome
        jal game_setup
        jal game_loop
main__epilogue:
      #  pop     $s0
        pop     $ra

        li $v0, 0
	jr	$ra


################################################################################
# .TEXT <print_welcome>
	.text
print_welcome:
	# Subset:   0
	#
	# Frame:    [0]   <-- FILL THESE OUT!
	# Uses:     [$v0, $a0, $ra]
	# Clobbers: [$v0, $a0, ]
	#
	# Locals:   none        <-- FILL THIS OUT!
	#   - ...
	#
	# Structure:        <-- FILL THIS OUT!
	#   print_welcome
	# 
	#       -> body
	#   -> [epilogue]

print_welcome__prologue:




print_welcome__body:
        li $v0, 4
        la $a0, str_print_welcome_1
        syscall
        li $v0, 4
        la $a0, str_print_welcome_2
        syscall
        li $v0, 4
        la $a0, str_print_welcome_3
        syscall
        li $v0, 4
        la $a0, str_print_welcome_4
        syscall
        li $v0, 4
        la $a0, str_print_welcome_5
        syscall
        li $v0, 4
        la $a0, str_print_welcome_6
        syscall
        li $v0, 4
        la $a0, str_print_welcome_7
        syscall
        li $v0, 4
        la $a0, str_print_welcome_8
        syscall
        li $v0, 4
        la $a0, str_print_welcome_9
        syscall


print_welcome__epilogue:
        jr      $ra

################################################################################
# .TEXT <game_setup>
	.text
game_setup:
	# Subset:   1
	#
	# Frame:    [$ra, $s0]   <-- FILL THESE OUT!
	# Uses:     [$t0-$t8, $a0-$a3, $ra, $s0, $zero]
	# Clobbers: [$a0–$a3, $t0–$t6, $ra, $s0]
	#
	# Locals:       none    <-- FILL THIS OUT!
	#   - ...
	#
	# Structure:        <-- FILL THIS OUT!
	#   game_setup
	#   -> [prologue]
	#       -> body
	#   -> [epilogue]

game_setup__prologue:
        push $ra
        push $s0
game_setup__body:
        # 1. prompt_for_int("a random seed", RNG_MIN_SEED, RNG_MAX_SEED, &random_number)
        la $a0, str_game_setup_1
        li $a1, RNG_MIN_SEED
        li $a2, RNG_MAX_SEED
        la $a3, random_number
        jal prompt_for_int

        # 2. prompt_for_int("a height", MIN_BOX_SIZE, MAX_BOX_SIZE, &height);
        la $a0, str_game_setup_2
        li $a1, MIN_BOX_SIZE
        li $a2, MAX_BOX_SIZE
        la $a3, height
        jal prompt_for_int
        # 3. prompt_for_int("a width ", MIN_BOX_SIZE, MAX_BOX_SIZE, &width);
        la $a0, str_game_setup_3
        li $a1, MIN_BOX_SIZE
        li $a2, MAX_BOX_SIZE
        la $a3, width
        jal prompt_for_int

        #   num_cats = (height * width) / AREA_PER_CAT;
        la $t0, height
        lw $t0, 0($t0)
        la $t1, width
        lw $t1, 0($t1)
        mul $t2, $t0, $t1 #height * width

        li $t3, AREA_PER_CAT
        div $t2, $t3               # LO = t2 / AREA_PER_CAT
        mflo $t2
        la $t6, num_cats
        sw $t2, 0($t6)
        #    num_cats_found = 0;
        li  $t5, 0
        sw  $t5, num_cats_found


        jal initialise_ball_of_string
        jal initialise_ball_paths
        jal initialise_box

        #score = num_cats * POINTS_PER_CAT;
        lw $t0, num_cats
        li $t1, POINTS_PER_CAT
        mul $t2, $t0, $t1
        sw $t2, score
        #cost_per_roll = score / (width + height);
        la $t5, score
        la $t6, width
        la $t7, height
        lw $t0, 0($t5)
        lw $t1, 0($t6)
        lw $t3, 0($t7)
        add $t4, $t1, $t3         # t4 = width + height
        div  $t0, $t4              # LO = score / (width + height)
        mflo $t0
        la $t7, cost_per_roll
        sw $t0, 0($t7)


        # is_cheat_mode = FALSE; is_auto_print = TRUE; game_state = STATE_PLAYING
        li $t0, FALSE
        la $t1, is_cheat_mode
        sb $t0, 0($t1)
        li $t0, TRUE
        la $t1, is_auto_print
        sb $t0, 0($t1)
        li $t0, STATE_PLAYING
        la $t1, game_state
        sw $t0, 0($t1)

        #  guess_x = -1; guess_y = -1
        li $t0, -1
        la $t1, guess_x
        la $t2, guess_y
        sw $t0, ($t1)
        sw $t0, ($t2)

        la $t0, cat_name
        sb $zero, ($t0)

game_setup__epilogue:
        pop $s0             
        pop $ra          
        jr $ra              
################################################################################
# .TEXT <prompt_for_int>
	.text
prompt_for_int:
	# Subset:   1
	#
	# Frame:    [16]   <-- FILL THESE OUT!
	# Uses:     [$ra, $s0, $s1, $t0, $t1, $t2, $v0, $a0–$a3, $zero]
	# Clobbers: [$a0–$a3, $t0–$t2, $v0]
	#
	# Locals:           <-- FILL THIS OUT!
	#   - ...
	#
	# Structure:        <-- FILL THIS OUT!
	#   prompt_for_int
	#   -> [prologue]
	#       -> body
        #           ->prompt_loop_cond
        #           -> prompt_loop_else
        #       -> prompt_bad_input
	#   -> [epilogue]
        
        
prompt_for_int__prologue:
        push $ra
        push $s0
        push $s1
      
        move $s1, $a0 #use s1 to save *prompt





prompt_for_int__body:
        li $s0, 0 #int is_valid_input = FALSE;
prompt_loop_cond:
        bne $s0, $zero, prompt_for_int__epilogue
prompt_loop:
        li $v0, 4
        la $a0, str_prompt_for_int_1
        syscall
        li $v0, 4
        move $a0, $s1
        syscall
        li $v0, 4
        la $a0, str_prompt_for_int_2
        syscall       
        li $v0, 1
        move $a0, $a1
        syscall
        li $v0, 4
        la $a0, str_prompt_for_int_3
        syscall
        li $v0, 1
        move $a0, $a2
        syscall
        li $v0, 4
        la $a0, str_prompt_for_int_4
        syscall
        li $v0, 5
        syscall
        move $t0, $v0 #scanf("%d", &input);

        blt $t0, $a1, prompt_bad_input
        bgt $t0, $a2, prompt_bad_input
prompt_loop_else:
        li $t1, 1 #is_valid_input = TRUE
        j prompt_for_int__epilogue
prompt_bad_input:
        li $v0, 4
        la $a0, str_prompt_for_int_err_1
        syscall
        li $v0, 1
        move $a0, $a1
        syscall
        li $v0, 4
        la $a0, str_prompt_for_int_err_2
        syscall
        li $v0, 1
        move $a0, $a2
        syscall
        li $v0, 4
        la $a0, str_prompt_for_int_err_3 
	syscall
        j prompt_loop_cond
prompt_for_int__epilogue:
        sw $t0, 0($a3)
     
        pop $s1
        pop $s0
        pop $ra
	jr	$ra


################################################################################
# .TEXT <initialise_ball_of_string>
	.text
initialise_ball_of_string:
	# Subset:   1
	#
	# Frame:    [4]   <-- FILL THESE OUT!
	# Uses:     [$ra, $t0, $t1, $t2]
	# Clobbers: [$t0, $t1, $t2]
	#
	# Locals:           <-- FILL THIS OUT!
	#   - ...
	#
	# Structure:        <-- FILL THIS OUT!
	#   initialise_ball_of_string
	#   -> [prologue]
	#       -> body
	#   -> [epilogue]

initialise_ball_of_string__prologue:
        push $ra
initialise_ball_of_string__body:
        la $t0, ball_of_string
        li $t1, BALL_INIT
        sw $t1, 0($t0)
        sw $t1, 4($t0)
        sw $t1, 8($t0)
        sw $t1, 12($t0)
        sw $t1, 16($t0)
        li $t2, BALL_STATE_STOPPED
        sb $t2, 20($t0)
initialise_ball_of_string__epilogue:
        pop $ra
	jr	$ra


################################################################################
# .TEXT <initialise_ball_paths>
	.text
initialise_ball_paths:
	# Subset:   1
	#
	# Frame:    [12]   <-- FILL THESE OUT!
	# Uses:     [$ra, $s0, $s1, $t0–$t6]
	# Clobbers: [$s0, $s1,$t0–$t6]
	#
	# Locals:           <-- FILL THIS OUT!
	#   - ...
	#
	# Structure:        <-- FILL THIS OUT!
	#   initialise_ball_paths
	#   -> [prologue]
	#       -> body
        #          -> loop
	#   -> [epilogue]

initialise_ball_paths__prologue:
        push $ra
        push $s0
        push $s1
initialise_ball_paths__body:
        li $s0, 0
        la $s1, ball_paths
        li $t0,  MAX_PATHS
        li $t1, PATH_ENTRY_NOT_SET
        li $t2, PATH_EXIT_NOT_SET
        li $t3, PATH_STATE_NOT_CHECKED
        li $t5, 12
initialise_ball_paths_loop:
        bge $s0, $t0, initialise_ball_paths__epilogue
        mul $t4, $s0, $t5     #offset of strucy   
        add $t6, $s1, $t4
        sw $t1, ($t6)
        sw $t2, 4($t6)
        sw $t3, 8($t6)
        addi $s0, $s0, 1
        j initialise_ball_paths_loop
initialise_ball_paths__epilogue:
        pop     $s1
        pop     $s0
        pop     $ra
        jr      $ra


################################################################################
# .TEXT <initialise_box>
	.text
initialise_box:
	# Subset:   1
	#
	# Frame:    [20 bytes]   <-- FILL THESE OUT!
	# Uses:     [$ra,$s0–$s3,$t0–$t6]
	# Clobbers: [$t0–$t6]
	#
	# Locals:           <-- FILL THIS OUT!
	#   - ...
	#
	# Structure:        <-- FILL THIS OUT!
	#   initialise_box
	#   -> [prologue]
	#       -> body
	#	 -> initialise_box_loop01
	#	-> initialise_box_loop02
	#   -> [epilogue]

initialise_box__prologue:
        push $ra
        push $s0
        push $s1
        push $s2
        push $s3
initialise_box__body:


        li $s0, 0 #row

        li $s2, MAX_BOX_SIZE
        li $t0, OFFSET_BOX_GUESSED
        li $t1, SIZEOF_BOX
        li $t2, SIZEOF_BOX_ARRAY_ROW
        la $t3, box
        li $s3, FALSE



initialise_box_loop01:
        bge $s0, $s2, initialise_box__epilogue
        li $s1, 0 #col


initialise_box_loop02:
        bge $s1, $s2, initialise_box__end2

	# (row * MAX_BOX_SIZE + col)* SIZEOF_INT + OFFSET_BOX_CONTAINS_CAT + box
        mul $t4, $s0, $s2
        add $t4, $t4, $s1
        mul $t4, $t4, SIZEOF_INT
	add $t4, $t4, OFFSET_BOX_CONTAINS_CAT
        add $t5, $t3, $t4
        sw  $s3, ($t5)
	# (MAX_BOX_SIZE * row + col) * SIZEOF_INT + OFFSET_BOX_GUESSED + box
        mul $t4, $s2, $s0
	add $t4, $t4, $s1
        mul $t4, $t4, SIZEOF_INT
        add $t4, $t4, $t0
        add $t6, $t3, $t4
        sw $s3, ($t6)

        addi $s1, $s1, 1
        j initialise_box_loop02
initialise_box__end2:
        addi $s0, $s0, 1
        j initialise_box_loop01


initialise_box__epilogue:
        pop $s3
        pop $s2
        pop $s1
        pop $s0
        pop $ra        
	jr	$ra


################################################################################
# .TEXT <print_stats>
	.text
print_stats:
	# Subset:   1
	#
	# Frame:    [36]   <-- FILL THESE OUT!
	# Uses:     [$ra,$s0–$s7, $t0–$t3, $v0, $a0]
	# Clobbers: [$v0, $a0,$t0–$t3]
	#
	# Locals:           <-- FILL THIS OUT!
	#   - ...
	#
	# Structure:        <-- FILL THIS OUT!
	#   print_stats
	#   -> [prologue]
	#       -> body
	#   -> [epilogue]

print_stats__prologue:
        push $ra
        push $s0        
        push $s1
        push $s2
        push $s3
        push $s4
        push $s5
        push $s6
        push $s7
print_stats__body:
        la $s0, score
        lw $s1, ($s0)
        li $s2, POINT_LOSS_BAD_GUESS
        div $s1, $s2
        mflo $t0 #num_guesses_left
        li $v0, 4
        la $a0, str_print_stats_1
        syscall
        li $v0, 1
        move $a0, $s1
        syscall
        li $v0, 4
        la $a0, str_print_stats_2
        syscall
        li $v0, 1
        move $a0, $t0
        syscall
        beq $t0, 1, print_stats__body_if
        li $v0, 4
        la $a0, str_print_stats_4
        syscall
        j print_stats__body_def
print_stats__body_if:
        li $v0, 4
        la $a0, str_print_stats_3
        syscall
print_stats__body_def:
        la $s3, cost_per_roll
        lw $s4, ($s3) 
        div $s1, $s4
        mflo $t1 #cost_per_roll
        li $v0, 1
        move $a0, $t1
        syscall
        li $v0, 4
        la $a0, str_print_stats_5
        syscall
        la $s5, num_cats
        lw $s6, ($s5) 
        la $s7, num_cats_found
        lw $t3, ($s7)
        sub $t2, $s6, $t3
        li $v0, 1
        move $a0, $t2
        syscall
        li $v0, 4
        la $a0, str_print_stats_6
        syscall
print_stats__epilogue:
        pop $s7
        pop $s6
        pop $s5
        pop $s4
        pop $s3
        pop $s2
        pop $s1
        pop $s0
        pop $ra
	jr	$ra
        

################################################################################
# .TEXT <game_loop>
	.text
game_loop:
	# Subset:   2
	#
	# Frame:    [12]   <-- FILL THESE OUT!
	# Uses:     [$ra, $s0-s1, $t0-t3, $a0]
	# Clobbers: [$t0–$t3, $a0, $v0]
	#
	# Locals:           <-- FILL THIS OUT!
	#   - ...
	#
	# Structure:        <-- FILL THIS OUT!
	#   game_loop
	#   -> [prologue]
	#       -> body
	#	-> game_loop__lable0
	#	-> game_loop__lable
	#	-> game_loop__if
	#	-> game_loop__if_lable
	#	-> game_loop__else_lable
	#   -> [epilogue]

game_loop__prologue:
	push $ra
	push $s0
	push $s1
game_loop__body:
	jal print_help
	la $t1, num_cats
	lw $a0, ($t1)
	jal spawn_cats
	la $t3, game_state
	li $s0, STATE_PLAYING
	sw $s0, 0($t3)

game_loop__lable0:
	la $t2, game_state
	lw $s1, ($t2)
	beq $s1, STATE_PLAYING, game_loop__lable
	j game_loop__if
game_loop__lable:
	jal process_command
	j game_loop__lable0
game_loop__if:
	beq $s1, STATE_WIN, game_loop__if_lable
	beq $s1, STATE_LOSE, game_loop__else_lable
game_loop__if_lable:
	li $v0, 4
	la $a0, str_game_loop_1
	syscall
	jal print_smiling_cat
	li $v0, 4
	la $a0, str_game_loop_2
	syscall	

	li $v0, 1
	la $t0, score
	lw $a0, ($t0)
	syscall
	li $v0, 11
	li $a0, '\n'
	syscall
	j game_loop__epilogue
game_loop__else_lable:
	jal print_crying_cat
	li $v0, 4
	la $a0, str_game_loop_3
	syscall
game_loop__epilogue:
	pop $s1
	pop $s0
	pop $ra
	jr	$ra


################################################################################
# .TEXT <is_cat_at_position>
	.text
is_cat_at_position:
	# Subset:   2
	#
	# Frame:    [20]   <-- FILL THESE OUT!
	# Uses:     [$ra, $s0-s3, $t0-t4, $a0-a1,$v0]
	# Clobbers: [$t0-t4, $v0, $a0-a1]
	#
	# Locals:           <-- FILL THIS OUT!
	#   - ...
	#
	# Structure:        <-- FILL THIS OUT!
	#   is_cat_at_position
	#   -> [prologue]
	#       -> body
	#	-> is_cat_at_position_zero
	#   -> [epilogue]

is_cat_at_position__prologue:
        push $ra
        push $s0
        push $s1
        push $s2
        push $s3
is_cat_at_position__body:
        #move $a0, $a0
        #move $a1, $a1
        move $s0, $a0
        move $s1, $a1
        jal is_position_in_box
        beq $v0, $zero, is_cat_at_position_zero
        #offset = (row*MAX_BOX_SIZE + col) * SIZEOF_INT
        li $t0, MAX_BOX_SIZE
        li $t1, SIZEOF_INT
        mul $t2, $s0, $t0
        add $t3, $t2, $s1
        mul $t4, $t3, $t1
        la $s3, box
        add $s3, $s3, $t4

        lw $v0, ($s3)

is_cat_at_position__epilogue:
        pop $s3
        pop $s2
        pop $s1
        pop $s0
        pop $ra
	jr	$ra     
is_cat_at_position_zero:
        li $v0, 0
        j is_cat_at_position__epilogue

################################################################################
# .TEXT <do_move_ball_forward>
	.text
do_move_ball_forward:
	# Subset:   2
	#
	# Frame:    [4]   <-- FILL THESE OUT!
	# Uses:     [$ra, $a0, $t0-t1]
	# Clobbers: [$t0-t1]
	#
	# Locals:           <-- FILL THIS OUT!
	#   - ...
	#
	# Structure:        <-- FILL THIS OUT!
	#   do_move_ball_forward
	#   -> [prologue]
	#       -> body
	#   -> [epilogue]

do_move_ball_forward__prologue:
        push $ra
do_move_ball_forward__body:
        # t0 = ball->x
        lw $t0, 4($a0)
        # t1 = ball->dx
        lw $t1,12($a0)
        # ball->x = t0 + t1
        add $t0, $t0, $t1
        sw $t0, 4($a0)

        # t0 = ball->y
        lw $t0, 8($a0)
        # t1 = ball->dy
        lw $t1,16($a0)
        # ball->y = t0 + t1
        add $t0, $t0, $t1
        sw $t0, 8($a0)
do_move_ball_forward__epilogue:
        pop $ra
	jr	$ra


################################################################################
# .TEXT <do_turn_ball>
	.text
do_turn_ball:
	# Subset:   2
	#
	# Frame:    [16]   <-- FILL THESE OUT!
	# Uses:     [$ra, $s0-s2, $a0-a1, $t0-t2, $zero]
	# Clobbers: [$a0-a1, $t0-t2]
	#
	# Locals:           <-- FILL THIS OUT!
	#   - ...
	#
	# Structure:        <-- FILL THIS OUT!
	#   do_turn_ball
	#   -> [prologue]
	#       -> body
	#	->do_turn_ball__left
	#	->do_turn_ball__right
	#   -> [epilogue]

do_turn_ball__prologue:
        push $ra
        push $s0
        push $s1
        push $s2

        move $s0, $a0  
        move $s1, $a1
do_turn_ball__body:
        li $t0, TURN_LEFT
        beq $s1, $t0, do_turn_ball__left

        li $t1, TURN_RIGHT
        beq $s1, $t1, do_turn_ball__right

        j do_turn_ball__epilogue

do_turn_ball__left:

        lw $s2, 12($s0)

        lw $t2, 16($s0)
        sw $t2, 12($s0)
	sub  $t2, $zero, $s2
        sw $t2, 16($s0)
        j do_turn_ball__epilogue

do_turn_ball__right:
        move $a0, $s0
        li $a1, TURN_LEFT	
        jal do_turn_ball
        
        move $a0, $s0
        li $a1, TURN_LEFT	
        jal do_turn_ball

        move $a0, $s0
        li $a1, TURN_LEFT	
        jal do_turn_ball
		
        j do_turn_ball__epilogue

do_turn_ball__epilogue:
        pop $s2
        pop $s1
        pop $s0
        pop $ra
        jr      $ra



################################################################################
# .TEXT <spawn_cats>
	.text
spawn_cats:
	# Subset:   2
	#
	# Frame:    [20]   <-- FILL THESE OUT!
	# Uses:     [$ra,$s0–$s3,$a0–$a1,$v0,$t0–$t6]
	# Clobbers: [$a0–$a1,$v0,$t0–$t6]
	#
	# Locals:           <-- FILL THIS OUT!
	#   - ...
	#
	# Structure:        <-- FILL THIS OUT!
	#   spawn_cats
	#   -> [prologue]
	#       -> body
	#	-> spawn_cats__row  
	#	-> spawn_cats__col  
	#	-> spawn_cats__while 
	#   -> [epilogue	

spawn_cats__prologue:
        push $ra
        push $s0
        push $s1
        push $s2
        push $s3

        move $s3, $a0          
        li $s0, 0           

spawn_cats__body:
        bge $s0, $s3, spawn_cats__epilogue

spawn_cats__row:
        li $a0, 0
        lw $a1, height
        addi $a1, $a1, -1
        jal random_in_range
        move $s1, $v0          

    
spawn_cats__col:
        li $a0, 0
        lw $a1, width
        addi $a1, $a1, -1
        jal random_in_range
        move $s2, $v0         

spawn_cats__while:
   
        li $t0, MAX_BOX_SIZE
        mul $t1, $s1, $t0    
        add $t1, $t1, $s2    
    
        li $t2, SIZEOF_INT
        mul $t3, $t1, $t2
        la $t4, box
        add $t4, $t4, $t3
        lw $t5, 0($t4)
        bne $t5, $zero, spawn_cats__row

        li $t6, TRUE
        sw $t6, 0($t4)

        addi $s0, $s0, 1      
        j       spawn_cats__body
spawn_cats__epilogue:
        pop $s3
        pop $s2
        pop $s1
        pop $s0
        pop $ra
        jr $ra



################################################################################
# .TEXT <guess_cat_location>
	.text
guess_cat_location:
	# Subset:   3
	#
	# Frame:    [24]   <-- FILL THESE OUT!
	# Uses:     [$ra, $s0–$s4, $s0- $s4, $t0–$t7,  $a0–$a3, $v0, $zero]
	# Clobbers: [$a0–$a3, $v0, $t0–$t7]
	#
	# Locals:           <-- FILL THIS OUT!
	#   - ...
	#
	# Structure:        <-- FILL THIS OUT!
	#   guess_cat_location
	#   -> [prologue]
	#       -> body
        #       -> guess_cat_location__bad_input
        #       -> maybe_print_game
        #       -> check_contains
        #       -> set_win
        #       -> check_contains_else
        #       -> check_contains_else_end
	#   -> [epilogue]

guess_cat_location__prologue:
        push $ra
        push $s0
        push $s1
        push $s2
        push $s3
        push $s4

        # compute base address of box.guessed
        la $s4, box
        li $t0, OFFSET_BOX_GUESSED
        add $s4, $s4, $t0      # $s4 = &box.guessed[0][0]	
guess_cat_location__body:
        la $a0, str_guess_cat_location_1
        li $a1, 1
        lw $a2, height
        la $a3, guess_y
        jal prompt_for_int

        la $a0, str_guess_cat_location_2
        lw $t1, height
        addi $a1, $t1, 1
        lw $t2, width
        add $a2, $t1, $t2
        la $a3, guess_x
        jal prompt_for_int

        # row = guess_y - 1
        lw $t3, guess_y
        addi $s0, $t3, -1

        # col = guess_x - (height + 1)
        lw $t3, guess_x
        lw $s2, height
        addi $s2, $s2, 1
        sub $s1, $t3, $s2

        mul $t5, $s0, MAX_BOX_SIZE  
        add $t5, $t5, $s1            

        li $t6, SIZEOF_INT          
        mul $t5, $t5, $t6            

        move $t4, $s4
        add  $t4, $t4, $t5     
        lw $t6, 0($t4)    
        bne $t6, $zero, guess_cat_location__bad_input
        
        # mark guessed[row][col] = TRUE
        li $t7, TRUE
        sw $t7, 0($t4)
        j maybe_print_game
guess_cat_location__bad_input:
        li $v0, 4
        la $a0, str_guess_cat_location_3
        syscall
        j guess_cat_location__body
maybe_print_game:
        lw $s3, is_auto_print
        beq $s3, $zero, check_contains
        jal print_game
check_contains:
        la $t0, box
        li $t7, OFFSET_BOX_CONTAINS_CAT
        add  $t0, $t0, $t7
        li $t7, MAX_BOX_SIZE
        mul $t1, $s0, $t7 
        add $t2, $s1, $t1
        
        li $t7, SIZEOF_INT
        mul $t1, $t2, $t7  
        add $t0, $t0, $t1
        lw $t3, 0($t0)
        beq $t3, $zero, check_contains_else
        li $v0, 4
        la $a0, str_guess_cat_location_4
        syscall
        li $v0, 1
        li $a0, POINT_GAIN_GOOD_GUESS
        syscall
        li $v0, 4
        la $a0, str_guess_cat_location_5
        syscall
        la $a0, cat_name
        jal generate_cat_name

        # printf("You found \"%s\"\n", cat_name);
        li $v0, 4
        la $a0, str_guess_cat_location_6
        syscall
        li $v0, 4
        la $a0, cat_name
        syscall
        li $v0, 4
        la $a0, str_guess_cat_location_7
        syscall
        # score += POINT_GAIN_GOOD_GUESS
        lw $t1, score
        addi $t1, $t1, POINT_GAIN_GOOD_GUESS
        sw $t1, score

        # num_cats_found++
        lw $t1, num_cats_found
        addi $t1, $t1, 1
        sw $t1, num_cats_found

        # if (num_cats_found = = num_cats) game_state = STATE_WIN
        lw $t2, num_cats
        beq $t1, $t2, set_win
        # else print_stats()
        jal print_stats
        j guess_cat_location__epilogue
set_win:
        li $t3, STATE_WIN
        la $t4, game_state
        sw $t3, 0($t4)
        j guess_cat_location__epilogue
check_contains_else:
        # printf("Bad Guess [-%d points]\n", POINT_LOSS_BAD_GUESS);
        li $v0, 4
        la $a0, str_guess_cat_location_8
        syscall
        li $v0, 1
        li $a0, POINT_LOSS_BAD_GUESS
        syscall
        li $v0, 4
        la $a0, str_guess_cat_location_9
        syscall

        # score -= POINT_LOSS_BAD_GUESS
        lw $t1, score
        li $t7, POINT_LOSS_BAD_GUESS
        sub $t1, $t1, $t7
        sw $t1, score

        # if (score < POINT_LOSS_BAD_GUESS) game_state = STATE_LOSE
        blt $t1, POINT_LOSS_BAD_GUESS, check_contains_else_end
        jal print_stats
        j guess_cat_location__epilogue
check_contains_else_end:
        li $t3, STATE_LOSE
        la $t4, game_state
        sw $t3, 0($t4)
        jal print_stats
guess_cat_location__epilogue:
        pop  $s4
        pop  $s3
        pop  $s2
        pop  $s1
        pop  $s0
        pop  $ra
	jr	$ra


################################################################################
# .TEXT <handle_ball_movement>
	.text
handle_ball_movement:
	# Subset:   3
	#
	# Frame:    [20]   <-- FILL THESE OUT!
	# Uses:     [$ra, $s0–$s3, $a0–$a2, $t0–$t6, $v0, $zero]
	# Clobbers: [$a0–$a2, $t0–$t6, $v0]
	#
	# Locals:           <-- FILL THIS OUT!
	#   - ...
	#
	# Structure:        <-- FILL THIS OUT!
	#   handle_ball_movement
	#   -> [prologue]
	#       -> body
	#	-> handle_ball_movement_if01
	#	-> handle_ball_movement_else01
	#	-> handle_ball_movement_if02
	#	-> handle_ball_movement_else02
	#	-> stop_ball
	#	-> handle_ball_movement__epilogue
	#   -> [epilogue]

handle_ball_movement__prologue:
	push $ra
	push $s0
	push $s1
	push $s2
	push $s3
	move $s0, $a0
	move $s1, $a1
	move $s2, $a2

handle_ball_movement__body:
        lw $t0, OFFSET_BALL_START($s0) 
        addi $t0, $t0, -1
        li $t1, SIZEOF_BALL_PATH        
        mul $t0, $t0, $t1
        add $s3, $s1, $t0              

	li $t0, INTERACTION_ABSORB
	beq $t0, $s2, handle_ball_movement_if01
        li $t0, INTERACTION_REFLECT
        beq $s2, $t0, handle_ball_movement_else01

	li $t0, INTERACTION_DEFLECT_LEFT
        beq $s2, $t0, handle_ball_movement_if02
        li $t0, INTERACTION_DEFLECT_RIGHT
        beq $s2, $t0, handle_ball_movement_else02

	j stop_ball
handle_ball_movement_if01:
	lw $t2, OFFSET_BALL_START($s0)
        sw $t2, OFFSET_BALL_PATH_EXIT($s3)
        li $t2, PATH_STATE_ABSORBED
        sw $t2, OFFSET_BALL_PATH_STATE($s3)
        li $t2, BALL_STATE_STOPPED
        sb $t2, OFFSET_BALL_STATE($s0)
        j handle_ball_movement__epilogue
handle_ball_movement_else01:
        lw $t2, OFFSET_BALL_START($s0)
        sw $t2, OFFSET_BALL_PATH_EXIT($s3)
        li $t2, PATH_STATE_REFLECTED
        sw $t2, OFFSET_BALL_PATH_STATE($s3)
        li $t2, BALL_STATE_STOPPED
        sb $t2, OFFSET_BALL_STATE($s0)
        j handle_ball_movement__epilogue
handle_ball_movement_if02:
        move $a0, $s0
        li $a1, TURN_LEFT
        jal do_turn_ball
        j stop_ball
handle_ball_movement_else02:
        move $a0, $s0
        li $a1, TURN_RIGHT
        jal do_turn_ball
        j stop_ball
stop_ball:
        move $a0, $s0
        jal do_move_ball_forward

        lw $a0, OFFSET_BALL_Y($s0)
        lw $a1, OFFSET_BALL_X($s0)
        jal is_position_in_box
        bne $v0, $zero, handle_ball_movement__epilogue

        li $t3, BALL_STATE_STOPPED
        sb $t3, OFFSET_BALL_STATE($s0)

        lw $a0, OFFSET_BALL_Y($s0)
        lw $a1, OFFSET_BALL_X($s0)
        jal edge_number_from_position
        sw $v0, OFFSET_BALL_PATH_EXIT($s3)

        li $t3, PATH_STATE_CHECKED
        sw $t3, OFFSET_BALL_PATH_STATE($s3)

        addi   $t4, $v0, -1
        li $t5, SIZEOF_BALL_PATH
        mul $t4, $t4, $t5
        add $t4, $s1, $t4

        lw $t6, OFFSET_BALL_PATH_EXIT($s3)
        sw $t6, OFFSET_BALL_PATH_ENTRY($t4)
        lw $t6, OFFSET_BALL_PATH_ENTRY($s3)
        sw $t6, OFFSET_BALL_PATH_EXIT($t4)
        li $t6, PATH_STATE_CHECKED
        sw $t6, OFFSET_BALL_PATH_STATE($t4)
handle_ball_movement__epilogue:
        pop $s3
        pop $s2
        pop $s1
        pop $s0
        pop $ra
        jr $ra

################################################################################
# .TEXT <generate_cat_name>
	.text
generate_cat_name:
	# Subset:   3
	#
	# Frame:    [4]   <-- FILL THESE OUT!
	# Uses:     [$a0–$a1, $v0, $t0–$t7， $ra]
	# Clobbers: [$a0–$a1, t0–$t7, $v0]
	#
	# Locals:           <-- FILL THIS OUT!
	#   - ...
	#
	# Structure:        <-- FILL THIS OUT!
	#   generate_cat_name
	#   -> [prologue]
	#       -> body
	#	-> generate_cat_name__label
	#	-> generate_cat_name__label01
	#   -> [epilogue]

generate_cat_name__prologue:
	push $ra
	push $s0
	move $s0, $a0    
generate_cat_name__body:
	li $a0, 0
	li $t1, NUM_OF_CAT_TITLES
	addi $a1, $t1, -1
	jal random_in_range

	la $t4, cat_titles
	li $t3, 4
	mul $t2, $v0, $t3
	add $t4, $t4, $t2
	lw $t4, 0($t4)
	move $t5, $t4
generate_cat_name__label:
	lb $t6, 0($t5)
	sb $t6, 0($s0)
	addi $t5, $t5, 1
	addi $s0, $s0, 1
	bnez $t6, generate_cat_name__label

	addi $s0, $s0, -1
	li $t6, ' '
	sb $t6, 0($s0)
	addi $s0, $s0, 1

	li $a0, 0
	li $t1, NUM_OF_CAT_SURNAMES
	addi $a1, $t1, -1
	jal random_in_range

	la $t3, cat_surnames
	li $t4, 4
	mul $t5, $v0, $t4
	add $t3, $t3, $t5
	lw $t3, 0($t3)

	move $t6, $t3
generate_cat_name__label01:
	lb $t7, 0($t6)
	sb $t7, 0($s0)
	addi $t6, $t6, 1
	addi $s0, $s0, 1
	bnez $t7, generate_cat_name__label01
generate_cat_name__epilogue:
	pop $s0
	pop $ra
	jr	$ra


roll_ball_of_string:
	# Subset:   3
	#
	# Frame:    [16]   <-- FILL THESE OUT!
	# Uses:     [$a0–$a2, $v0, $t0–$t9, $s0–$s2, $ra]
	# Clobbers: [$a0–$a2, $v0, $t0–$t9]
	#
	# Locals:           <-- FILL THIS OUT!
	#   - ...
	#
	# Structure:        <-- FILL THIS OUT!
	#   roll_ball_of_string
	#   -> [prologue]
	#       -> body
	#	-> roll_ball_of_string_if01
	#	-> roll_ball_of_string_ball_move
	#	-> roll_ball_of_string_ball_loop01
	#	-> Ldo_move
	#	-> roll_ball_of_string_ball_if02
	#	-> roll_ball_of_string_ball_printf01
	#	-> roll_ball_of_string_ball_else
	#	-> roll_ball_of_string_ball_half
	#	-> roll_ball_of_string_ball_if03
	#	-> roll_ball_of_string_ball_final
	#   -> [epilogue]

roll_ball_of_string__prologue:
	push $ra
	push $s0
	push $s1
	push $s2

	move $s0, $a0
roll_ball_of_string__body:
	lw $s1, OFFSET_GAME_BALL($s0)
	# compute 2*(width+height)
	lw $t0, height
	lw $t1, width
	add $t0, $t0, $t1
	li $t2, 2
	mul $t0, $t0, $t2
	move $a0, $s1
	move $a1, $t0
	jal configure_ball

	lw $s2, OFFSET_GAME_PATHS($s0)
	lw $t0, OFFSET_BALL_START($s1)
	addi $t0, $t0, -1
	li $t1, SIZEOF_BALL_PATH
	mul $t0, $t0, $t1
	add $t0, $t0, $s2
	lw $t2, OFFSET_BALL_START($s1)
	sw $t2, OFFSET_BALL_PATH_ENTRY($t0)

	move $a0, $s1
	jal check_ball_interactions
	move $t3, $v0
	li $t4, INTERACTION_DEFLECT_LEFT
	beq $t3, $t4,  roll_ball_of_string_if01
	li $t4, INTERACTION_DEFLECT_RIGHT
	beq $t3, $t4,  roll_ball_of_string_if01
	j roll_ball_of_string_ball_move
 roll_ball_of_string_if01:
    	li $t3, INTERACTION_REFLECT
 roll_ball_of_string_ball_move:
	move $a0, $s1
	move $a1, $s2
	move $a2, $t3
	jal handle_ball_movement
 roll_ball_of_string_ball_loop01:
	lb $t5, OFFSET_BALL_STATE($s1)
	li $t6, BALL_STATE_ROLLING
	beq $t5, $t6,  Ldo_move
	j roll_ball_of_string_ball_if02
 Ldo_move:
	move $a0, $s1
	jal check_ball_interactions
	move $a2, $v0
	move $a0, $s1
	move $a1, $s2
	jal handle_ball_movement
	j roll_ball_of_string_ball_loop01

 roll_ball_of_string_ball_if02:
	lw $t7, is_auto_print
	beqz $t7,  roll_ball_of_string_ball_printf01
	jal print_game
 roll_ball_of_string_ball_printf01:
	li $v0, SYSCALL_PRINT_STRING
	la $a0, str_roll_ball_of_string_1
	syscall
	lw $t0, OFFSET_BALL_START($s1)
	li $v0, SYSCALL_PRINT_INT
	move $a0, $t0
	syscall

	lw $s2, OFFSET_GAME_PATHS($s0)
	lw $t0, OFFSET_BALL_START($s1)
	addi $t0, $t0, -1
	li $t1, SIZEOF_BALL_PATH
	mul $t0, $t0, $t1
	add    $t0, $t0, $s2

	lw $t8, OFFSET_BALL_PATH_STATE($t0)
	li $t9, PATH_STATE_ABSORBED
	beq $t8, $t9,  roll_ball_of_string_ball_else

	li $v0, SYSCALL_PRINT_STRING
	la $a0, str_roll_ball_of_string_3
	syscall
	lw $t1, OFFSET_BALL_PATH_EXIT($t0)
	li $v0, SYSCALL_PRINT_INT
	move $a0, $t1
	syscall
	li $v0, 11
	li $a0, '\n'
	syscall
	j roll_ball_of_string_ball_half

 roll_ball_of_string_ball_else:
	li $v0, SYSCALL_PRINT_STRING
	la $a0, str_roll_ball_of_string_2
	syscall

 roll_ball_of_string_ball_half:
	li $v0, SYSCALL_PRINT_STRING
	la $a0, str_roll_ball_of_string_4
	syscall
	lw $t2, cost_per_roll
	li $v0, SYSCALL_PRINT_INT
	move $a0, $t2
	syscall
	li $v0, SYSCALL_PRINT_STRING
	la $a0, str_roll_ball_of_string_5
	syscall

	lw $t3, score
	lw $t4, cost_per_roll
	subu    $t3, $t3, $t4
	sw $t3, score

	# if (score < POINT_LOSS_BAD_GUESS) game_state = STATE_LOSE;
	li $t5, POINT_LOSS_BAD_GUESS
	blt $t3, $t5,  roll_ball_of_string_ball_if03
	j roll_ball_of_string_ball_final
 roll_ball_of_string_ball_if03:
	li $t6, STATE_LOSE
	la $t7, game_state
	sw $t6, 0($t7)

 roll_ball_of_string_ball_final:
    # print_stats();
    	jal print_stats

roll_ball_of_string__epilogue:
	pop $s2
	pop $s1
	pop $s0
	pop $ra
	jr	$ra



################################################################################
################################################################################
###                   PROVIDED FUNCTIONS — DO NOT CHANGE                     ###
################################################################################
################################################################################

################################################################################
# .TEXT <random_in_range>
	.text
random_in_range:
	# Subset:   N/A - Provided Function
	#
	# Frame:    [$ra, $s0, $s1]
	# Uses:     [$a0, $a1, $s0, $s1, $t0, $v0, $ra]
	# Clobbers: [$t0, $v0]
	#
	# Locals:
	#   - $s0: int min
	#   - $s1: int max
	#   - $t0: temporary for computing (max - min + 1)
	#
	# Structure:
	#   random_in_range
	#   -> [prologue]
	#       -> body
	#   -> [epilogue]

random_in_range__prologue:
	push	$ra
	push	$s0
	push	$s1

random_in_range__body:
	move	$s0, $a0			# int min
	move	$s1, $a1			# int max

	jal	update_random_number		# update_random_number();

	move	$t0, $s1			# max
	sub	$t0, $t0, $s0			# max - min
	addi	$t0, $t0, 1			# max - min + 1;

	lw	$v0, random_number		# random_number
	rem	$v0, $v0, $t0			# random_number % (max - min + 1);

	add	$v0, $v0, $s0			# (random_number % (max - min + 1)) + min;

random_in_range__epilogue:
	pop	$s1
	pop	$s0
	pop	$ra
	jr	$ra				# return (random_number % (max - min + 1)) + min;


################################################################################
# .TEXT <update_random_number>
	.text
update_random_number:
	# Subset:   N/A - Provided Function
	#
	# Frame:    []
	# Uses:     [$t0]
	# Clobbers: [$t0]
	#
	# Locals:
	#   - $t0: temporary int to hold intermediate calculations
	#
	# Structure:
	#   update_random_number
	#   -> [prologue]
	#       -> body
	#   -> [epilogue]

update_random_number__prologue:

update_random_number__body:
	lw	$t0, random_number
	mul	$t0, $t0, RNG_MULTIPLIER	# random_number *= RNG_MULTIPLIER;
	addi	$t0, $t0, RNG_INCREMENT		# random_number += RNG_INCREMENT;
	rem	$t0, $t0, RNG_MODULUS		# random_number %= RNG_MODULUS;
	sw	$t0, random_number

update_random_number__epilogue:
	jr	$ra


################################################################################
# .TEXT <process_command>
	.text
process_command:
	# Subset:   N/A - Provided Function
	#
	# Frame:    [$ra]
	# Uses:     [$v0, $a0, $a1, $t0, $ra]
	# Clobbers: [$v0, $a0, $a1, $t0]
	#
	# Locals:
	#   - $t0 - char command
	#
	# Structure:
	#   process_command
	#   -> [prologue]
	#       -> body
	#           -> autoprint
	#               -> if_autoprint__cond
	#               -> if_autoprint__true
	#               -> if_autoprint__false
	#               -> if_autoprint__end
	#           -> stats
	#           -> print
	#           -> guess
	#           -> roll
	#           -> cheat
	#           -> debug
	#           -> quit
	#           -> bad_command
	#   -> [epilogue]

process_command__prologue:
	push	$ra

process_command__body:
	li	$v0, SYSCALL_PRINT_STRING
	la	$a0, str_process_command_prompt
	syscall						# printf("\nEnter Command: ");

	li	$v0, SYSCALL_READ_CHAR
	syscall						# scanf(" %c", &command);
	move	$t0, $v0

	beq	$t0, CMD_HELP, process_command__help		# if (command == CMD_HELP) { ...
	beq	$t0, CMD_AUTOPRINT, process_command__autoprint	# } else if (command == CMD_AUTOPRINT) { ...
	beq	$t0, CMD_PRINT_STATS, process_command__stats	# } else if (command == CMD_PRINT_STATS) { ...
	beq	$t0, CMD_PRINT_GAME, process_command__print	# } else if (command == CMD_PRINT_GAME) { ...
	beq	$t0, CMD_GUESS, process_command__guess		# } else if (command == CMD_GUESS) { ...
	beq	$t0, CMD_ROLL, process_command__roll		# } else if (command == CMD_ROLL) { ...
	beq	$t0, CMD_CHEAT, process_command__cheat		# } else if (command == CMD_CHEAT) { ...
	beq	$t0, CMD_DEBUG, process_command__debug		# } else if (command == CMD_DEBUG) { ...
	beq	$t0, CMD_QUIT, process_command__quit		# } else if (command == CMD_QUIT) { ...
	b	process_command__bad_command			# } else { ...

process_command__help:					# if (command == CMD_HELP) {
	li	$v0, SYSCALL_PRINT_STRING
	la	$a0, str_process_command_help
	syscall						#   printf("(printing help)\n");

	jal	print_help				#   print_help();
	b	process_command__epilogue

process_command__autoprint:				# } else if (command == CMD_AUTOPRINT) {
	li	$v0, SYSCALL_PRINT_STRING
	la	$a0, str_process_command_autoprint_1
	syscall						#   printf("(auto-print turned ");

process_command__if_autoprint__cond:
	lw	$t0, is_auto_print
	bne	$t0, TRUE, process_command__if_autoprint__false

process_command__if_autoprint__true:			#   if (is_auto_print) {
	li	$t0, FALSE
	sw	$t0, is_auto_print			#     is_auto_print = FALSE;

	li	$v0, SYSCALL_PRINT_STRING
	la	$a0, str_process_command_autoprint_2
	syscall						#     printf("OFF)\n");

	b	process_command__if_autoprint__end

process_command__if_autoprint__false:			#   } else {
	li	$t0, TRUE
	sw	$t0, is_auto_print			#     is_auto_print = TRUE;
	
	li	$v0, SYSCALL_PRINT_STRING
	la	$a0, str_process_command_autoprint_3
	syscall						#     printf("ON)\n");

process_command__if_autoprint__end:			#   }
	b	process_command__epilogue

process_command__stats:					# } else if (command == CMD_PRINT_STATS) {
	li	$v0, SYSCALL_PRINT_STRING
	la	$a0, str_process_command_print_stats
	syscall						#   printf("(printing game stats)\n");

	jal	print_stats				#   print_stats();
	b	process_command__epilogue

process_command__print:					# } else if (command == CMD_PRINT_GAME) {
	li	$v0, SYSCALL_PRINT_STRING
	la	$a0, str_process_command_print_game
	syscall						#   printf("(printing game)\n");

	jal	print_game				#   print_game();
	b	process_command__epilogue

process_command__guess:					# } else if (command == CMD_GUESS) {
	li	$v0, SYSCALL_PRINT_STRING
	la	$a0, str_process_command_guess
	syscall						#   printf("(guessing cat location)\n");

	jal	guess_cat_location			#   guess_cat_location();
	b	process_command__epilogue

process_command__roll:					# } else if (command == CMD_ROLL) {
	li	$v0, SYSCALL_PRINT_STRING
	la	$a0, str_process_command_roll
	syscall						#   printf("(rolling ball of string from edge)\n");

	lw	$a0, game_pointer
	jal	roll_ball_of_string			#   roll_ball_of_string(game_pointer);
	b	process_command__epilogue

process_command__cheat:					# } else if (command == CMD_CHEAT) {
	li	$v0, SYSCALL_PRINT_STRING
	la	$a0, str_process_command_cheat
	syscall						#   printf("(cheating)\n");

	li	$t0, TRUE
	sw	$t0, is_cheat_mode			#   is_cheat_mode = TRUE;

	jal	print_game				#   print_game();

	li	$t0, FALSE
	sw	$t0, is_cheat_mode			#   is_cheat_mode = FALSE;
	b	process_command__epilogue

process_command__debug:					# } else if (command == CMD_DEBUG) {
	li	$v0, SYSCALL_PRINT_STRING
	la	$a0, str_process_command_debug
	syscall						#   printf("(printing debug info)");

	jal	print_debug_info			#   print_debug_info();
	b	process_command__epilogue

process_command__quit:					# } else if (command == CMD_QUIT) {
	li	$v0, SYSCALL_PRINT_STRING
	la	$a0, str_process_command_quit
	syscall						#   printf("(quitting)\n");

	li	$t0, STATE_QUIT
	sw	$t0, game_state				#   game_state = STATE_QUIT;

	b	process_command__epilogue

process_command__bad_command:				# } else {
	li	$v0, SYSCALL_PRINT_STRING
	la	$a0, str_process_command_bad_command
	syscall						#   printf("(bad command)\n");

	jal	print_help				#   print_help();

process_command__epilogue:				# } 
	pop	$ra

	jr	$ra


################################################################################
# .TEXT <print_help>
	.text
print_help:
	# Subset:   N/A - Provided Function
	#
	# Frame:    []
	# Uses:     [$v0, $a0]
	# Clobbers: [$v0, $a0]
	#
	# Locals:
	#   - $a0 - int num_cats, int height, int width, score, cost_per_roll
	#
	# Structure:
	#   print_help
	#   -> [prologue]
	#       -> body
	#   -> [epilogue]

print_help__prologue:

print_help__body:
	li	$v0, SYSCALL_PRINT_STRING
	la	$a0, str_print_help_line
	syscall			# printf("\n===============================================================\n");

	li	$v0, SYSCALL_PRINT_STRING
	la	$a0, str_print_help_intro_1
	syscall			# printf("There are ");

	li	$v0, SYSCALL_PRINT_INT
	lw	$a0, num_cats
	syscall			# printf("%d", num_cats);

	li	$v0, SYSCALL_PRINT_STRING
	la	$a0, str_print_help_intro_2
	syscall			# printf(" cats hidden in a ");

	li	$v0, SYSCALL_PRINT_INT
	lw	$a0, height
	syscall			# printf("%d", height);

	li	$v0, SYSCALL_PRINT_STRING
	la	$a0, str_print_help_intro_3
	syscall			# printf("-by-");

	li	$v0, SYSCALL_PRINT_INT
	lw	$a0, width
	syscall			# printf("%d", width);

	li	$v0, SYSCALL_PRINT_STRING
	la	$a0, str_print_help_intro_4
	syscall			# printf(" box. Your goal is to deduce\ntheir locations by rolling balls of ");

	li	$v0, SYSCALL_PRINT_STRING
	la	$a0, str_print_help_intro_5
	syscall			# printf("string in from the edges\nand noticing where they exit the grid.\n");

	li	$v0, SYSCALL_PRINT_STRING
	la	$a0, str_print_help_interact_1
	syscall			# printf("\nBalls of string interact with cats as follows:\n");

	li	$v0, SYSCALL_PRINT_STRING
	la	$a0, str_print_help_interact_2
	syscall			# printf("- Absorbed:         when hitting a cat directly.\n");

	li	$v0, SYSCALL_PRINT_STRING
	la	$a0, str_print_help_interact_3
	syscall			# printf("- Deflected 90 degrees:  when passing diagonally near a cat.\n");

	li	$v0, SYSCALL_PRINT_STRING
	la	$a0, str_print_help_interact_4
	syscall			# printf("- Reflected:        when aimed between two cats one square apart.\n");

	li	$v0, SYSCALL_PRINT_STRING
	la	$a0, str_print_help_interact_5
	syscall			# printf("- Reflected:        when deflected before entering the box.\n");

	li	$v0, SYSCALL_PRINT_STRING
	la	$a0, str_print_help_interact_6
	syscall			# printf("- Straight-line:    otherwise (no interaction).\n");

	li	$v0, SYSCALL_PRINT_STRING
	la	$a0, str_print_help_score
	syscall			# printf("\nStarting Score: ");

	li	$v0, SYSCALL_PRINT_INT
	lw	$a0, score
	syscall			# printf("%d", score);

	li	$v0, SYSCALL_PRINT_STRING
	la	$a0, str_print_help_points_1
	syscall			# printf("\n\nPoints/Costs:\n- Correct guess   = +");

	li	$v0, SYSCALL_PRINT_INT
	li	$a0, POINT_GAIN_GOOD_GUESS
	syscall			# printf("%d", POINT_GAIN_GOOD_GUESS);

	li	$v0, SYSCALL_PRINT_STRING
	la	$a0, str_print_help_points_2
	syscall			# printf(" points\n- Incorrect guess = -");

	li	$v0, SYSCALL_PRINT_INT
	li	$a0, POINT_LOSS_BAD_GUESS
	syscall			# printf("%d", POINT_LOSS_BAD_GUESS);

	li	$v0, SYSCALL_PRINT_STRING
	la	$a0, str_print_help_points_3
	syscall			# printf(" points\n- Rolling a ball  = -");

	li	$v0, SYSCALL_PRINT_INT
	lw	$a0, cost_per_roll
	syscall			# printf("%d", cost_per_roll);

	li	$v0, SYSCALL_PRINT_STRING
	la	$a0, str_print_help_cmds
	syscall			# printf(" points\n\nAvailable Commands:\n ");

	li	$v0, SYSCALL_PRINT_CHAR
	li	$a0, CMD_HELP
	syscall			# printf("%c", CMD_HELP);

	li	$v0, SYSCALL_PRINT_STRING
	la	$a0, str_print_help_cmd_help
	syscall			# printf(" - Print this help message.\n ");

	li	$v0, SYSCALL_PRINT_CHAR
	li	$a0, CMD_PRINT_GAME
	syscall			# printf("%c", CMD_PRINT_GAME);

	li	$v0, SYSCALL_PRINT_STRING
	la	$a0, str_print_help_cmd_print_game
	syscall			# printf(" - Print the game.\n ");

	li	$v0, SYSCALL_PRINT_CHAR
	li	$a0, CMD_AUTOPRINT
	syscall			# printf("%c", CMD_AUTOPRINT);
	
	li	$v0, SYSCALL_PRINT_STRING
	la	$a0, str_print_help_cmd_autoprint
	syscall			# printf(" - Toggle auto-print ON/OFF.\n ");

	li	$v0, SYSCALL_PRINT_CHAR
	li	$a0, CMD_GUESS
	syscall			# printf("%c", CMD_GUESS);

	li	$v0, SYSCALL_PRINT_STRING
	la	$a0, str_print_help_cmd_guess
	syscall			# printf(" - Guess a cat location.\n ");

	li	$v0, SYSCALL_PRINT_CHAR
	li	$a0, CMD_ROLL
	syscall			# printf("%c", CMD_ROLL);

	li	$v0, SYSCALL_PRINT_STRING
	la	$a0, str_print_help_cmd_roll
	syscall			# printf(" - Roll a ball of string.\n ");

	li	$v0, SYSCALL_PRINT_CHAR
	li	$a0, CMD_PRINT_STATS
	syscall			# printf("%c", CMD_PRINT_STATS);

	li	$v0, SYSCALL_PRINT_STRING
	la	$a0, str_print_help_cmd_print_stats
	syscall			# printf(" - Print game stats.\n ");

	li	$v0, SYSCALL_PRINT_CHAR
	li	$a0, CMD_CHEAT
	syscall			# printf("%c", CMD_CHEAT);

	li	$v0, SYSCALL_PRINT_STRING
	la	$a0, str_print_help_cmd_cheat
	syscall			# printf(" - Cheat (reveal cat positions).\n ");

	li	$v0, SYSCALL_PRINT_CHAR
	li	$a0, CMD_DEBUG
	syscall			# printf("%c", CMD_DEBUG);

	li	$v0, SYSCALL_PRINT_STRING
	la	$a0, str_print_help_cmd_debug
	syscall			# printf(" - Debug info.\n ");

	li	$v0, SYSCALL_PRINT_CHAR
	li	$a0, CMD_QUIT
	syscall			# printf("%c", CMD_QUIT);

	li	$v0, SYSCALL_PRINT_STRING
	la	$a0, str_print_help_cmd_quit
	syscall			# printf(" - Quit the game.\n");

	li	$v0, SYSCALL_PRINT_STRING
	la	$a0, str_print_help_line
	syscall			# printf("\n===============================================================\n");	

print_help__epilogue:
	jr	$ra


################################################################################
# .TEXT <print_debug_info>
	.text
print_debug_info:
	# Subset:   N/A - Provided Function
	#
	# Frame:    []
	# Uses:     [$v0, $a0, $t0, $t1, $t2]
	# Clobbers: [$v0, $a0, $t0, $t1, $t2]
	#
	# Locals:
	#   - $t0: loop counter (row, col)
	#   - $t1: loop counter and temporary
	#   - $t2: pointer (to traverse arrays e.g. box[][] and ball_paths[])
	#
	# Structure:
	#   -> [prologue]
	#       -> [body]
	#           -> box_col_nums1__init
	#           -> box_col_nums1__cond
	#           -> box_col_nums1__body
	#           -> box_col_nums1__step
	#           -> box_col_nums1__end
	#           -> box_contains_row__init
	#           -> box_contains_row__cond
	#           -> box_contains_row__body
	#               -> box_contains_col__init
	#               -> box_contains_col__cond
	#               -> box_contains_col__body
	#               -> box_contains_col__step
	#               -> box_contains_col__end
	#           -> box_contains_row__step
	#           -> box_contains_row__end
	#           -> box_col_nums2__init
	#           -> box_col_nums2__cond
	#           -> box_col_nums2__body
	#           -> box_col_nums2__step
	#           -> box_col_nums2__end
	#           -> box_guessed_row__init
	#           -> box_guessed_row__cond
	#           -> box_guessed_row__body
	#               -> box_guessed_col__init
	#               -> box_guessed_col__cond
	#               -> box_guessed_col__body
	#               -> box_guessed_col__step
	#               -> box_guessed_col__end
	#           -> box_guessed_row__step
	#           -> box_guessed_row__end
	#           -> ball_paths_loop__init
	#           -> ball_paths_loop__cond
	#           -> ball_paths_loop__body
	#           -> ball_paths_loop__step
	#           -> ball_paths_loop__end
	#   -> [epilogue]

print_debug_info__prologue:

print_debug_info__body:
	li	$v0, SYSCALL_PRINT_STRING
	la	$a0, str_print_debug_info_header
	syscall						# printf("\n================ DEBUG INFO ================\n");

	li	$v0, SYSCALL_PRINT_STRING
	la	$a0, str_print_debug_info_random_number
	syscall						# printf("random_number  = ");

	li	$v0, SYSCALL_PRINT_INT
	lw	$a0, random_number
	syscall						# printf("%d", random_number);

	li	$v0, SYSCALL_PRINT_STRING
	la	$a0, str_print_debug_info_height
	syscall						# printf("\nheight         = ");

	li	$v0, SYSCALL_PRINT_INT
	lw	$a0, height
	syscall						# printf("%d", height);

	li	$v0, SYSCALL_PRINT_STRING
	la	$a0, str_print_debug_info_width
	syscall						# printf("\nwidth          = ");

	li	$v0, SYSCALL_PRINT_INT
	lw	$a0, width
	syscall						# printf("%d", width);

	li	$v0, SYSCALL_PRINT_STRING
	la	$a0, str_print_debug_info_num_cats
	syscall						# printf("\nnum_cats       = ");

	li	$v0, SYSCALL_PRINT_INT
	lw	$a0, num_cats
	syscall						# printf("%d", num_cats);

	li	$v0, SYSCALL_PRINT_STRING
	la	$a0, str_print_debug_info_num_cats_found
	syscall						# printf("\nnum_cats_found = ");

	li	$v0, SYSCALL_PRINT_INT
	lw	$a0, num_cats_found
	syscall						# printf("%d", num_cats_found);

	li	$v0, SYSCALL_PRINT_STRING
	la	$a0, str_print_debug_info_score
	syscall						# printf("\nscore          = ");

	li	$v0, SYSCALL_PRINT_INT
	lw	$a0, score
	syscall						# printf("%d", score);

	li	$v0, SYSCALL_PRINT_STRING
	la	$a0, str_print_debug_info_cost_per_roll
	syscall						# printf("\ncost_per_roll  = ");

	li	$v0, SYSCALL_PRINT_INT
	lw	$a0, cost_per_roll
	syscall						# printf("%d", cost_per_roll);

	li	$v0, SYSCALL_PRINT_STRING
	la	$a0, str_print_debug_info_is_cheat_mode
	syscall						# printf("\nis_cheat_mode  = ");

	li	$v0, SYSCALL_PRINT_INT
	lw	$a0, is_cheat_mode
	syscall						# printf("%d", is_cheat_mode);

	li	$v0, SYSCALL_PRINT_STRING
	la	$a0, str_print_debug_info_game_state
	syscall						# printf("\ngame_state     = ");

	li	$v0, SYSCALL_PRINT_INT
	lw	$a0, game_state
	syscall						# printf("%d", game_state);

	li	$v0, SYSCALL_PRINT_STRING
	la	$a0, str_print_debug_info_guess_x
	syscall						# printf("\nguess_x        = ");

	li	$v0, SYSCALL_PRINT_INT
	lw	$a0, guess_x
	syscall						# printf("%d", guess_x);

	li	$v0, SYSCALL_PRINT_STRING
	la	$a0, str_print_debug_info_guess_y
	syscall						# printf("\nguess_y        = ");

	li	$v0, SYSCALL_PRINT_INT
	lw	$a0, guess_y
	syscall						# printf("%d", guess_y);

	li	$v0, SYSCALL_PRINT_STRING
	la	$a0, str_print_debug_info_cat_name_1
	syscall						# printf("\ncat_name       = \"");

	li	$v0, SYSCALL_PRINT_STRING
	la	$a0, cat_name
	syscall						# printf("%s, cat_name);

	li	$v0, SYSCALL_PRINT_STRING
	la	$a0, str_print_debug_info_cat_name_2
	syscall						# printf("\"\n", cat_name);

	li	$v0, SYSCALL_PRINT_STRING
	la	$a0, str_print_debug_info_box_contains_header
	syscall						# printf("\n                     ");

print_debug_info__box_col_nums1__init:
	li	$t0, 0					# int col = 0

print_debug_info__box_col_nums1__cond:			# while (col < MAX_BOX_SIZE) {
	bge	$t0, MAX_BOX_SIZE, print_debug_info__box_col_nums1__end

print_debug_info__box_col_nums1__body:
	li	$v0, SYSCALL_PRINT_CHAR
	li	$a0, ' '
	syscall						#   putchar(' ');

	li	$v0, SYSCALL_PRINT_INT
	rem	$a0, $t0, 10				#   col % 10
	syscall						#   printf("%d", col % 10);

print_debug_info__box_col_nums1__step:
	addi	$t0, $t0, 1				#   col++;
	b	print_debug_info__box_col_nums1__cond

print_debug_info__box_col_nums1__end:			# }

	li	$v0, SYSCALL_PRINT_CHAR
	li	$a0, '\n'
	syscall						# putchar('\n');

print_debug_info__box_contains_row__init:
	li	$t0, 0					# int row = 0;
	la	$t2, box				# int *p = &box.contains_cat[0][0]

print_debug_info__box_contains_row__cond:		# while (row < MAX_BOX_SIZE) {
	bge	$t0, MAX_BOX_SIZE, print_debug_info__box_contains_row__end

print_debug_info__box_contains_row__body:
	li	$v0, SYSCALL_PRINT_STRING
	la	$a0, str_print_debug_info_box_contains_1
	syscall						#   printf("box.contains_cat[");

	li	$v0, SYSCALL_PRINT_INT
	move	$a0, $t0
	syscall						#   printf("%d", row);

	li	$v0, SYSCALL_PRINT_STRING
	la	$a0, str_print_debug_info_box_contains_2
	syscall						#   printf("]: ");

	bge	$t0, 10, print_debug_info__box_contains_col__init
							#   if (row < 10) {
	li	$v0, SYSCALL_PRINT_CHAR
	li	$a0, ' '
	syscall						#     putchar(' ');

print_debug_info__box_contains_col__init:		#   }
	li	$t1, 0					#   int col = 0;

print_debug_info__box_contains_col__cond:		#   while (col < MAX_BOX_SIZE) {
	bge	$t1, MAX_BOX_SIZE, print_debug_info__box_contains_col__end

print_debug_info__box_contains_col__body:
	li	$v0, SYSCALL_PRINT_INT
	lw	$a0, ($t2)
	syscall						#     printf("%d ", box.contains_cat[row][col]);

	li	$v0, SYSCALL_PRINT_CHAR
	li	$a0, ' '
	syscall						#     putchar(' ');

print_debug_info__box_contains_col__step:
	addi	$t1, $t1, 1				#     col++;
	addi	$t2, $t2, SIZEOF_INT			#     p++;
	b	print_debug_info__box_contains_col__cond

print_debug_info__box_contains_col__end:		#   }
	li	$v0, SYSCALL_PRINT_CHAR
	li	$a0, '\n'
	syscall						#   putchar('\n');

print_debug_info__box_contains_row__step:
	addi	$t0, $t0, 1				#   row++;
	b	print_debug_info__box_contains_row__cond

print_debug_info__box_contains_row__end:		# }

	li	$v0, SYSCALL_PRINT_STRING
	la	$a0, str_print_debug_info_box_guessed_header
	syscall						# printf("\n                ");

print_debug_info__box_col_nums2__init:
	li	$t0, 0					# int col = 0;

print_debug_info__box_col_nums2__cond:			# while (col < MAX_BOX_SIZE) {
	bge	$t0, MAX_BOX_SIZE, print_debug_info__box_col_nums2__end

print_debug_info__box_col_nums2__body:
	li	$v0, SYSCALL_PRINT_CHAR
	li	$a0, ' '
	syscall						#   putchar(' ');

	li	$v0, SYSCALL_PRINT_INT
	rem	$a0, $t0, 10
	syscall						#   printf("%d", col % 10);

print_debug_info__box_col_nums2__step:
	addi	$t0, $t0, 1				#   col++;
	b	print_debug_info__box_col_nums2__cond

print_debug_info__box_col_nums2__end:			# }

	li	$v0, SYSCALL_PRINT_CHAR
	li	$a0, '\n'
	syscall						# putchar(' ');

print_debug_info__box_guessed_row__init:
	li	$t0, 0					# int row = 0;
	la	$t2, box				# &box
	addi	$t2, $t2, OFFSET_BOX_GUESSED		# int *p = &box.guessed[0][0]

print_debug_info__box_guessed_row__cond:		# while (row < MAX_BOX_SIZE) {
	bge	$t0, MAX_BOX_SIZE, print_debug_info__box_guessed_row__end

print_debug_info__box_guessed_row__body:
	li	$v0, SYSCALL_PRINT_STRING
	la	$a0, str_print_debug_info_box_guessed_1
	syscall						#   printf("box.guessed[");

	li	$v0, SYSCALL_PRINT_INT
	move	$a0, $t0
	syscall						#   printf("%d", row);

	li	$v0, SYSCALL_PRINT_STRING
	la	$a0, str_print_debug_info_box_guessed_2
	syscall						#   printf("]: ");

	bge	$t0, 10, print_debug_info__box_guessed_col__init
							#   if (row < 10) {
	li	$v0, SYSCALL_PRINT_CHAR			
	li	$a0, ' '				
	syscall						#     putchar(' ');
							#   }
print_debug_info__box_guessed_col__init:
	li	$t1, 0					#   int col = 0;

print_debug_info__box_guessed_col__cond:		#   while (col < MAX_BOX_SIZE) {
	bge	$t1, MAX_BOX_SIZE, print_debug_info__box_guessed_col__end

print_debug_info__box_guessed_col__body:
	li	$v0, SYSCALL_PRINT_INT
	lw	$a0, ($t2)
	syscall						#     printf("%d", box.guessed[row][col]);

	li	$v0, SYSCALL_PRINT_CHAR
	li	$a0, ' '
	syscall						#     putchar(' ');

print_debug_info__box_guessed_col__step:
	addi	$t1, $t1, 1				#     col++;
	addi	$t2, $t2, SIZEOF_INT			#     p++;
	b	print_debug_info__box_guessed_col__cond

print_debug_info__box_guessed_col__end:			#   }
	li	$v0, SYSCALL_PRINT_CHAR
	li	$a0, '\n'
	syscall						#   putchar('\n');

print_debug_info__box_guessed_row__step:
		addi	$t0, $t0, 1			#   row++;
	b	print_debug_info__box_guessed_row__cond

print_debug_info__box_guessed_row__end:			# }

	la	$t0, ball_of_string			# &ball_of_string

	li	$v0, SYSCALL_PRINT_STRING
	la	$a0, str_print_debug_info_ball_start
	syscall						# printf("\nball_of_string.start = ");

	li	$v0, SYSCALL_PRINT_INT
	lw	$a0, OFFSET_BALL_START($t0)
	syscall						# printf("%d", ball_of_string.start);

	li	$v0, SYSCALL_PRINT_STRING
	la	$a0, str_print_debug_info_ball_x
	syscall						# printf("\nball_of_string.x     = ");

	li	$v0, SYSCALL_PRINT_INT
	lw	$a0, OFFSET_BALL_X($t0)
	syscall						# printf("%d", ball_of_string.x);

	li	$v0, SYSCALL_PRINT_STRING
	la	$a0, str_print_debug_info_ball_y
	syscall						# printf("\nball_of_string.y     = ");

	li	$v0, SYSCALL_PRINT_INT
	lw	$a0, OFFSET_BALL_Y($t0)
	syscall						# printf("%d", ball_of_string.y);

	li	$v0, SYSCALL_PRINT_STRING
	la	$a0, str_print_debug_info_ball_dx
	syscall						# printf("\nball_of_string.dx    = ");

	li	$v0, SYSCALL_PRINT_INT
	lw	$a0, OFFSET_BALL_DX($t0)
	syscall						# printf("%d", ball_of_string.dx);

	li	$v0, SYSCALL_PRINT_STRING
	la	$a0, str_print_debug_info_ball_dy
	syscall						# printf("\nball_of_string.dy    = ");

	li	$v0, SYSCALL_PRINT_INT
	lw	$a0, OFFSET_BALL_DY($t0)
	syscall						# printf("%d", ball_of_string.dy);

	li	$v0, SYSCALL_PRINT_STRING
	la	$a0, str_print_debug_info_ball_state
	syscall						# printf("\nball_of_string.state = ");

	li	$v0, SYSCALL_PRINT_CHAR
	lb	$a0, OFFSET_BALL_STATE($t0)
	syscall						# printf("%c", ball_of_string.state);

	li	$v0, SYSCALL_PRINT_CHAR
	li	$a0, '\n'
	syscall						# putchar('\n');

	li	$v0, SYSCALL_PRINT_CHAR
	li	$a0, '\n'
	syscall						# putchar('\n');

print_debug_info__ball_paths_loop__init:
	li	$t0, 0					# int i = 0;
	la	$t1, ball_paths				# struct ball_path *b = &ball_paths

print_debug_info__ball_paths_loop__cond:		# while (i < MAX_PATHS) {
	bge	$t0, MAX_PATHS, print_debug_info__ball_paths_loop__end

print_debug_info__ball_paths_loop__body:
	li	$v0, SYSCALL_PRINT_STRING
	la	$a0, str_print_debug_info_ball_paths_1
	syscall						#   printf("ball_paths[");

	li	$v0, SYSCALL_PRINT_INT
	move	$a0, $t0
	syscall						#   printf("%d", i);

	li	$v0, SYSCALL_PRINT_STRING
	la	$a0, str_print_debug_info_ball_paths_2
	syscall						#   printf("]: { entry: ");

	li	$v0, SYSCALL_PRINT_INT
	lw	$a0, OFFSET_BALL_PATH_ENTRY($t1)
	syscall						#   printf("%d", ball_paths[i].entry);

	li	$v0, SYSCALL_PRINT_STRING
	la	$a0, str_print_debug_info_ball_paths_3
	syscall						#   printf(", exit: ");

	li	$v0, SYSCALL_PRINT_INT
	lw	$a0, OFFSET_BALL_PATH_EXIT($t1)
	syscall						#   printf("%d", ball_paths[i].exit);

	li	$v0, SYSCALL_PRINT_STRING
	la	$a0, str_print_debug_info_ball_paths_4
	syscall						#   printf(", state: ");

	li	$v0, SYSCALL_PRINT_INT
	lw	$a0, OFFSET_BALL_PATH_STATE($t1)
	syscall						#   printf("%d", ball_paths[i].state);

	li	$v0, SYSCALL_PRINT_STRING
	la	$a0, str_print_debug_info_ball_paths_5
	syscall						#   printf(" }\n");

print_debug_info__ball_paths_loop__step:
	addi	$t0, $t0, 1				#   i++;
	addi	$t1, $t1, SIZEOF_BALL_PATH		#   b += SIZEOF_BALL_PATH;
	b	print_debug_info__ball_paths_loop__cond

print_debug_info__ball_paths_loop__end:			# }

print_debug_info__epilogue:
	jr	$ra


################################################################################
# .TEXT <print_smiling_cat>
	.text
print_smiling_cat:
	# Subset:   N/A - Provided Function
	#
	# Frame:    []
	# Uses:     [$a0, $v0]
	# Clobbers: [$a0, $v0]
	#
	# Locals:
	#   - (none)
	#
	# Structure:
	#   print_smiling_cat
	#   -> [prologue]
	#       -> body
	#   -> [epilogue]

print_smiling_cat__prologue:

print_smiling_cat__body:

	li	$v0, SYSCALL_PRINT_STRING
	la	$a0, str_print_smiling_cat_1
	syscall					# printf("┌─────────┐\n");
	
	li	$v0, SYSCALL_PRINT_STRING
	la	$a0, str_print_smiling_cat_2
	syscall					# printf("│  /\\_/\\  │\n");
	
	li	$v0, SYSCALL_PRINT_STRING
	la	$a0, str_print_smiling_cat_3
	syscall					# printf("│ (*^_^*) │\n");
	
	li	$v0, SYSCALL_PRINT_STRING
	la	$a0, str_print_smiling_cat_4
	syscall					# printf("│ /     \\ │\n");
	
	li	$v0, SYSCALL_PRINT_STRING
	la	$a0, str_print_smiling_cat_5
	syscall					# printf("└─────────┘\n");

print_smiling_cat__epilogue:
	jr	$ra


################################################################################
# .TEXT <print_crying_cat>
	.text
print_crying_cat:
	# Subset:   N/A - Provided Function
	#
	# Frame:    []
	# Uses:     [$a0, $v0]
	# Clobbers: [$a0, $v0]
	#
	# Locals:
	#   - (none)
	#
	# Structure:
	#   print_crying_cat
	#   -> [prologue]
	#       -> body
	#   -> [epilogue]

print_crying_cat__prologue:

print_crying_cat__body:

	li	$v0, SYSCALL_PRINT_STRING
	la	$a0, str_print_crying_cat_1
	syscall					# printf("┌─────────┐\n");
	
	li	$v0, SYSCALL_PRINT_STRING
	la	$a0, str_print_crying_cat_2
	syscall					# printf("│  /\\_/\\  │\n");
	
	li	$v0, SYSCALL_PRINT_STRING
	la	$a0, str_print_crying_cat_3
	syscall					# printf("│ ( T_T ) │\n");
	
	li	$v0, SYSCALL_PRINT_STRING
	la	$a0, str_print_crying_cat_4
	syscall					# printf("│ /     \\ │\n");
	
	li	$v0, SYSCALL_PRINT_STRING
	la	$a0, str_print_crying_cat_5
	syscall					# printf("└─────────┘\n");

print_crying_cat__epilogue:
	jr	$ra


################################################################################
# .TEXT <configure_ball>
	.text
configure_ball:
	# Subset:   N/A - Provided Function
	#
	# Frame:    [$ra, $s0, $s1]
	# Uses:     [$a0, $a1, $a2, $a3, $s0, $s1, $t0, $t1, $t2, $t3, $t4, $t5, $t6, $t7, $t9, $ra]
	# Clobbers: [$a0, $a1, $a2, $a3, $t0, $t1, $t2, $t3, $t4, $t5, $t6, $t7, $t9]
	#
	# Locals:
	#   - $s0: struct ball_of_string *ball
	#   - $s1: int number_of_edges
	#   - $t0: int edge_number
	#   - $t1: copy of height
	#   - $t2: copy of width
	#   - $t3: ball->x
	#   - $t4: ball->y
	#   - $t5: ball->dx
	#   - $t6: ball->dy
	#   - $t7: temporary int
	#   - $t9: temporary int
	#
	# Structure:
	#   configure_ball
	#   -> [prologue]
	#       -> body
	#       -> case_left
	#       -> case_bottom
	#       -> case_right
	#       -> case_top
	#   -> [epilogue]

configure_ball__prologue:
	push	$ra
	push	$s0
	push	$s1

configure_ball__body:
	move	$s0, $a0				# struct ball_of_string *ball
	move	$s1, $a1				# int number_of_edges

							# prompt_for_int(
	la	$a0, str_configure_ball			#   "an edge number",
	li	$a1, 1					#   1,
	move	$a2, $s1				#   number_of_edges,
	add	$a3, $s0, OFFSET_BALL_START		#   &ball->start
	jal	prompt_for_int				# );

	lw	$t0, OFFSET_BALL_START($s0)		# int edge_number = ball->start;
	lw	$t1, height
	lw	$t2, width

	move	$t9, $t1				# height
	ble	$t0, $t9, configure_ball__case_left	# if (edge_number <= height) {...
	add	$t9, $t9, $t2				# height + width
	ble	$t0, $t9, configure_ball__case_bottom	# } else if (edge_number <= height + width) {...
	add	$t9, $t9, $t1				# height + width + height
	ble	$t0, $t9, configure_ball__case_right	# } else if (edge_number <= height + width + height) {...
	b	configure_ball__case_top		# } else {...

configure_ball__case_left:			# if (edge_number <= height) {
	li	$t3, -1				#   ball->x = -1;
	sub	$t4, $t0, 1			#   ball->y = edge_number - 1;
	li	$t5, 1				#   ball->dx = 1;
	li	$t6, 0				#   ball->dy = 0;
	b	configure_ball__case_end

configure_ball__case_bottom:			# } else if (edge_number <= height + width) {
	move	$t9, $t0			#   edge_number
	sub	$t9, $t9, 1			#   edge_number - 1
	sub	$t9, $t9, $t1			#   edge_number - 1 - height
	move	$t3, $t9			#   ball->x = edge_number - 1 - height;
	move	$t4, $t1			#   ball->y = height;
	li	$t5, 0				#   ball->dx = 0;
	li	$t6, -1				#   ball->dy = -1;
	b	configure_ball__case_end

configure_ball__case_right:			# } else if (edge_number <= height + width + height) {
	move	$t3, $t2			#   ball->x = width;
	move	$t9, $t1			#   height
	mul	$t9, $t9, 2			#   2 * height
	add	$t9, $t9, $t2			#   2 * height + width
	sub	$t9, $t9, $t0			#   2 * height + width - edge_number
	move	$t4, $t9			#   ball->y = (height + width + height) - edge_number;
	li	$t5, -1				#   ball->dx = -1;
	li	$t6, 0				#   ball->dy = 0;
	b	configure_ball__case_end

configure_ball__case_top:			# } else {
	add	$t9, $t9, $t2			
	move	$t9, $t1			#   height
	add	$t9, $t9, $t2			#   height + width
	mul	$t9, $t9, 2			#   2 * (height + width)
	sub	$t9, $t9, $t0			#   2 * (height + width) - edge_number
	move	$t3, $t9			#   ball->x = (height + width + height + width) - edge_number;
	li	$t4, -1				#   ball->y = -1;
	li	$t5, 0				#   ball->dx = 0;
	li	$t6, 1				#   ball->dy = 1;
	b	configure_ball__case_end

configure_ball__case_end:			# }

	sw	$t3, OFFSET_BALL_X($s0)		# ball->x = ...
	sw	$t4, OFFSET_BALL_Y($s0)		# ball->y = ...
	sw	$t5, OFFSET_BALL_DX($s0)	# ball->dx = ...
	sw	$t6, OFFSET_BALL_DY($s0)	# ball->dy = ...
	li	$t7, BALL_STATE_ROLLING
	sb	$t7, OFFSET_BALL_STATE($s0)	# ball->state = BALL_STATE_ROLLING;

configure_ball__epilogue:
	pop	$s1
	pop	$s0
	pop	$ra

	jr	$ra


################################################################################
# .TEXT <check_ball_interactions>
	.text
check_ball_interactions:
	# Subset:   N/A - Provided Function
	#
	# Frame:    [$ra, $s0, $s1, $s2, $s3]
	# Uses:     [$a0, $a1, $s0, $s1, $s2, $s3, $t2, $ra]
	# Clobbers: [$a0, $a1, $t2]
	#
	# Locals:
	#   - $s0: struct ball_of_string *ball
	#   - $s1: int cat_ahead
	#   - $s2: int cat_to_left
	#   - $s3: int cat_to_right
	#   - $t2: intermediate result cat_to_left && cat_to_right
	#
	# Structure:
	#   check_ball_interactions
	#   -> [prologue]
	#       -> body
	#       -> return_absorb
	#       -> return_reflect
	#       -> return_deflect_right
	#       -> return_deflect_left
	#       -> return_none
	#   -> [epilogue]

check_ball_interactions__prologue:
	push	$ra
	push	$s0
	push	$s1
	push	$s2
	push	$s3

check_ball_interactions__body:
	move	$s0, $a0			# struct ball_of_string *ball

	move	$a0, $s0
	jal	do_move_ball_forward		# do_move_ball_forward(ball);
						# is_cat_at_position(
	lw	$a0, OFFSET_BALL_Y($s0)		#   ball->y,
	lw	$a1, OFFSET_BALL_X($s0)		#   ball->x
	jal	is_cat_at_position		# };
	move	$s1, $v0			# cat_ahead

	move	$a0, $s0
	li	$a1, TURN_LEFT
	jal	do_turn_ball			# do_turn_ball(ball, TURN_LEFT);

	move	$a0, $s0
	jal	do_move_ball_forward		# do_move_ball_forward(ball);

						# is_cat_at_position()
	lw	$a0, OFFSET_BALL_Y($s0)		#   ball->y,
	lw	$a1, OFFSET_BALL_X($s0)		#   ball->x
	jal	is_cat_at_position		# };
	move	$s2, $v0			# cat_to_left

	move	$a0, $s0
	li	$a1, TURN_LEFT
	jal	do_turn_ball			# do_turn_ball(ball, TURN_LEFT);

	move	$a0, $s0
	li	$a1, TURN_LEFT
	jal	do_turn_ball			# do_turn_ball(ball, TURN_LEFT);

	move	$a0, $s0
	jal	do_move_ball_forward		# do_move_ball_forward(ball);

	move	$a0, $s0
	jal	do_move_ball_forward		# do_move_ball_forward(ball);

						# is_cat_at_position()
	lw	$a0, OFFSET_BALL_Y($s0)		#   ball->y,
	lw	$a1, OFFSET_BALL_X($s0)		#   ball->x
	jal	is_cat_at_position		# };
	move	$s3, $v0			# cat_to_right

	move	$a0, $s0
	li	$a1, TURN_RIGHT
	jal	do_turn_ball			# do_turn_ball(ball, TURN_RIGHT);

	move	$a0, $s0
	jal	do_move_ball_forward		# do_move_ball_forward(ball);

	move	$a0, $s0
	li	$a1, TURN_RIGHT
	jal	do_turn_ball			# do_turn_ball(ball, TURN_RIGHT);

	move	$a0, $s0
	jal	do_move_ball_forward		# do_move_ball_forward(ball);

	move	$a0, $s0
	li	$a1, TURN_RIGHT
	jal	do_turn_ball			# do_turn_ball(ball, TURN_RIGHT);


	bne	$s1, $zero, check_ball_interactions__return_absorb		# if (cat_ahead) {...
	and	$t2, $s2, $s3			# cat_to_left && cat_to_right
	bne	$t2, $zero, check_ball_interactions__return_reflect		# } else if (cat_to_left && cat_to_right) {...
	bne	$s2, $zero, check_ball_interactions__return_deflect_right	# } else if (cat_to_left) {...
	bne	$s3, $zero, check_ball_interactions__return_deflect_left	# } else if (cat_to_right) {...
	b	check_ball_interactions__return_none

check_ball_interactions__return_absorb:
	li	$v0, INTERACTION_ABSORB
	b	check_ball_interactions__epilogue	#   return INTERACTION_ABSORB;

check_ball_interactions__return_reflect:
	li	$v0, INTERACTION_REFLECT
	b	check_ball_interactions__epilogue	#   return INTERACTION_REFLECT;

check_ball_interactions__return_deflect_right:
	li	$v0, INTERACTION_DEFLECT_RIGHT
	b	check_ball_interactions__epilogue	#   return INTERACTION_DEFLECT_RIGHT;

check_ball_interactions__return_deflect_left:
	li	$v0, INTERACTION_DEFLECT_LEFT
	b	check_ball_interactions__epilogue	#   return INTERACTION_DEFLECT_LEFT;

check_ball_interactions__return_none:
	li	$v0, INTERACTION_NONE
	b	check_ball_interactions__epilogue	#   return INTERACTION_NONE;

check_ball_interactions__epilogue:
	pop	$s3
	pop	$s2
	pop	$s1
	pop	$s0
	pop	$ra

	jr	$ra


################################################################################
# .TEXT <edge_number_from_position>
	.text
edge_number_from_position:
	# Subset:   N/A - Provided Function
	#
	# Frame:    []
	# Uses:     [$a0, $a1, $t0, $t1, $v0]
	# Clobbers: [$a0, $t0, $t1, $v0]
	#
	# Locals:
	#   - $t0: int height
	#   - $t1: int width
	#   - $a0: int row
	#   - $a1: int col
	#
	# Structure:
	#   edge_number_from_position
	#   edge_number_from_position
	#   -> [prologue]
	#       -> body
	#           -> if_left__cond
	#           -> if_left__true
	#           -> if_bottom__cond
	#           -> if_bottom__true
	#           -> if_right__cond
	#           -> if_right__true
	#           -> if_top__cond
	#           -> if_top__true
	#           -> else
	#   -> [epilogue]

edge_number_from_position__prologue:

edge_number_from_position__body:
	lw	$t0, height				# height
	lw	$t1, width				# width

edge_number_from_position__if_left__cond:
	bge	$a1,   0, edge_number_from_position__if_bottom__cond	# if (col >= 0) {...
	blt	$a0,   0, edge_number_from_position__if_bottom__cond	# if (row < 0) {...
	bge	$a0, $t0, edge_number_from_position__if_bottom__cond	# if (row >= height) {...

edge_number_from_position__if_left__true:		# if (col < 0 && 0 <= row && row < height) {
	li	$v0, 1					#   1
	add	$v0, $v0, $a0				#   1 + row
	b	edge_number_from_position__epilogue	#   return 1 + row;

edge_number_from_position__if_bottom__cond:
	blt	$a0, $t0, edge_number_from_position__if_right__cond	# if (row < height) {...
	blt	$a1,   0, edge_number_from_position__if_right__cond	# if (col < 0) {...
	bge	$a1, $t1, edge_number_from_position__if_right__cond	# if (col >= width) {...

edge_number_from_position__if_bottom__true:		# } else if (row >= height && 0 <= col && col < width) {
	li	$v0, 1					#   1
	add	$v0, $v0, $t0				#   1 + height
	add	$v0, $v0, $a1				#   1 + height + col
	b	edge_number_from_position__epilogue	#   return 1 + height + col;

edge_number_from_position__if_right__cond:
	blt	$a1, $t1, edge_number_from_position__if_top__cond	# if (col < width) {...
	blt	$a0,   0, edge_number_from_position__if_top__cond	# if (row < 0) {...
	bge	$a0, $t0, edge_number_from_position__if_top__cond	# if (row >= height) {...

edge_number_from_position__if_right__true:		# } else if (col >= width && 0 <= row && row < height) {
	move	$v0, $t0				#   height
	add	$v0, $v0, $t1				#   height + width
	add	$v0, $v0, $t0				#   height + width + height
	sub	$v0, $v0, $a0				#   height + width + (height - row)
	b	edge_number_from_position__epilogue	#   return height + width + (height - row);

edge_number_from_position__if_top__cond:
	bge	$a0,   0, edge_number_from_position__else		# if (row >= 0) {...
	blt	$a1,   0, edge_number_from_position__else		# if (col < 0) {...
	bge	$a1, $t1, edge_number_from_position__else		# if (col >= width) {...

edge_number_from_position__if_top__true:		# } else if (row < 0 && 0 <= col && col < width) {
	move	$v0, $t0				#   height
	add	$v0, $v0, $t1				#   height + width
	mul	$v0, $v0, 2				#   height + width + height + width
	sub	$v0, $v0, $a1				#   height + width + height + (width - col)
	b	edge_number_from_position__epilogue	#   return height + width + height + (width - col);

edge_number_from_position__else:			# } else {
	li	$v0, SYSCALL_PRINT_STRING
	la	$a0, str_edge_number_from_position_1
	syscall						#   printf("Fatal Error: edge_number_from_position(): position not on edge\n");

	li	$v0, SYSCALL_EXIT2
	li	$a0, 1
	syscall						#   exit(EXIT_FAILURE);

edge_number_from_position__epilogue:			# }
	jr	$ra


################################################################################
# .TEXT <print_game>
	.text
print_game:
	# Subset:   N/A - Provided Function
	#
	# Frame:    [$ra, $s0, $s1]
	# Uses:     [$a0, $s0, $s1, $ra]
	# Clobbers: [$a0]
	#
	# Locals:
	#   - $s0: int row
	#   - $s1: int height, height + 2
	#
	# Structure:
	#   print_game
	#   -> [prologue]
	#   -> [body]
	#       -> loop__init
	#       -> loop__cond
	#       -> loop__body
	#       -> loop__step
	#       -> loop__end
	#   -> [epilogue]

print_game__prologue:
	push	$ra
	push	$s0
	push	$s1

print_game__body:

print_game__loop__init:
	li	$s0, -2				# int row = -2;
	lw	$s1, height			# height
	addi	$s1, $s1, 2			# height + 2

print_game__loop__cond:				# while (row < height + 2) {
	bge	$s0, $s1, print_game__loop__end

print_game__loop__body:
	move	$a0, $s0
	jal	print_game_row_upper		#   print_game_row_upper(row);

	move	$a0, $s0
	jal	print_game_row_inner		#   print_game_row_inner(row);

	move	$a0, $s0
	jal	print_game_row_lower		#   print_game_row_lower(row);

print_game__loop__step:
	addi	$s0, $s0, 1			#   row++;
	b	print_game__loop__cond

print_game__loop__end:				# }

print_game__epilogue:
	pop	$s1
	pop	$s0
	pop	$ra

	jr	$ra


################################################################################
# .TEXT <print_game_row_upper>
	.text
print_game_row_upper:
	# Subset:   N/A - Provided Function
	#
	# Frame:    [$ra, $s0, $s1, $s2]
	# Uses:     [$a0, $a1, $a2, $a3, $v0, $s0, $s1, $s2, $t1, $ra]
	# Clobbers: [$a0, $a1, $a2, $a3, $v0, $t1]
	#
	# Locals:
	#   - $s0: int row
	#   - $s1: int height
	#   - $s2: int width
	#   - $t1: height + 1
	#
	# Structure:
	#   print_game_row_upper
	#   -> [prologue]
	#       -> body
	#           -> if_row_eq_neg2
	#           -> if_row_eq_neg1
	#           -> if_row_eq_height_plus_1
	#           -> if_row_eq_0
	#           -> if_row_eq_height
	#           -> if_row_else
	#           -> if_row__end
	#   -> [epilogue]

print_game_row_upper__prologue:
	push	$ra
	push	$s0
	push	$s1
	push	$s2

print_game_row_upper__body:
	move	$s0, $a0				# int row
	lw	$s1, height
	lw	$s2, width

	beq	$s0,  -2, print_grid_row_edge__if_row_eq_neg2		# if (row == -2) {...
	beq	$s0,  -1, print_grid_row_edge__if_row_eq_neg1		# } else if (row == -1) {...
	addi	$t1, $s1, 1						# height + 1
	beq	$s0, $t1, print_grid_row_edge__if_row_eq_height_plus_1	# } else if (row == height + 1) {...
	beq	$s0,   0, print_grid_row_edge__if_row_eq_0		# } else if (row == 0) {...
	beq	$s0, $s1, print_grid_row_edge__if_row_eq_height		# } else if (row == height) {...
	b	print_grid_row_edge__if_row_else			# } else {...

print_grid_row_edge__if_row_eq_neg2:
print_grid_row_edge__if_row_eq_neg1:
print_grid_row_edge__if_row_eq_height_plus_1:		# if (row == -2 || row == -1 || row == height + 1) {
	li	$v0, SYSCALL_PRINT_STRING
	la	$a0, STR_CORNER_ROW
	syscall						#   printf(STR_CORNER_ROW);

	li	$v0, SYSCALL_PRINT_STRING
	la	$a0, STR_MARGIN_HORIZONTAL
	syscall						#   printf(STR_MARGIN_HORIZONTAL);

	move	$a0, $s2
	jal	print_grid_row_edge_upper		#   print_grid_row_edge_upper(width)

	b	print_grid_row_edge__if_row__end

print_grid_row_edge__if_row_eq_0:			# } else if (row == 0) {
	li	$a0, 1
	jal	print_grid_row_edge_upper		#   print_grid_row_edge_upper(1)

	li	$v0, SYSCALL_PRINT_STRING
	la	$a0, STR_MARGIN_HORIZONTAL
	syscall						#   printf(STR_MARGIN_HORIZONTAL);

							#   print_grid_row_edge(
	addi	$a0, $s2, 2				#     width + 2,
	la	$a1, STR_CORNER_TOP_LEFT		#     STR_CORNER_TOP_LEFT,
	la	$a2, STR_INTERSECT_CENTRE		#     STR_INTERSECT_CENTRE,
	la	$a3, STR_CORNER_TOP_RIGHT		#     STR_CORNER_TOP_RIGHT,
	jal	print_grid_row_edge			#   );

	li	$v0, SYSCALL_PRINT_STRING
	la	$a0, STR_MARGIN_HORIZONTAL
	syscall						#   printf(STR_MARGIN_HORIZONTAL);

	li	$a0, 1
	jal	print_grid_row_edge_upper		#   print_grid_row_edge_upper(1)

	b	print_grid_row_edge__if_row__end

print_grid_row_edge__if_row_eq_height:			# } else if (row == height) {
	li	$a0, 1
	jal	print_grid_row_edge_lower		#   print_grid_row_edge_lower(1)

	li	$v0, SYSCALL_PRINT_STRING
	la	$a0, STR_MARGIN_HORIZONTAL
	syscall						#   printf(STR_MARGIN_HORIZONTAL);

							#   print_grid_row_edge(
	addi	$a0, $s2, 2				#     width + 2,
	la	$a1, STR_CORNER_BOT_LEFT		#     STR_CORNER_BOT_LEFT,
	la	$a2, STR_INTERSECT_CENTRE		#     STR_INTERSECT_CENTRE,
	la	$a3, STR_CORNER_BOT_RIGHT		#     STR_CORNER_BOT_RIGHT,
	jal	print_grid_row_edge			#   );

	li	$v0, SYSCALL_PRINT_STRING
	la	$a0, STR_MARGIN_HORIZONTAL
	syscall						#   printf(STR_MARGIN_HORIZONTAL);

	li	$a0, 1
	jal	print_grid_row_edge_lower		#   print_grid_row_edge_lower(1)

	b	print_grid_row_edge__if_row__end

print_grid_row_edge__if_row_else:			# } else {
	li	$a0, 1
	jal	print_grid_row_edge_inner		#   print_grid_row_edge_inner(1)

	li	$v0, SYSCALL_PRINT_STRING
	la	$a0, STR_MARGIN_HORIZONTAL
	syscall						#   printf(STR_MARGIN_HORIZONTAL);

	addi	$a0, $s2, 2				#   width + 2
	jal	print_grid_row_edge_inner		#   print_grid_row_edge_inner(width + 2)

	li	$v0, SYSCALL_PRINT_STRING
	la	$a0, STR_MARGIN_HORIZONTAL
	syscall						#   printf(STR_MARGIN_HORIZONTAL);

	li	$a0, 1
	jal	print_grid_row_edge_inner		#   print_grid_row_edge_inner(1)

print_grid_row_edge__if_row__end:			# }

	li	$v0, SYSCALL_PRINT_CHAR
	li	$a0, '\n'
	syscall						# putchar('\n');

print_game_row_upper__epilogue:
	pop	$s2
	pop	$s1
	pop	$s0
	pop	$ra

	jr	$ra


################################################################################
# .TEXT <print_game_row_inner>
	.text
print_game_row_inner:
	# Subset:   N/A - Provided Function
	#
	# Frame:    [$ra, $s0, $s1, $s2]
	# Uses:     [$a0, $a1, $a2, $v0, $s0, $s1, $s2, $ra]
	# Clobbers: [$a0, $a1, $a2, $v0]
	#
	# Locals:
	#   - $s0: int row
	#   - $s1: int height
	#   - $s2: int width
	#
	# Structure:
	#   print_game_row_inner
	#   -> [prologue]
	#       -> body
	#           -> if_row_lt_0
	#           -> if_row_ge_height
	#           -> if_row_else
	#           -> if_row_end
	#   -> [epilogue]

print_game_row_inner__prologue:
	push	$ra
	push	$s0
	push	$s1
	push	$s2

print_game_row_inner__body:
	move	$s0, $a0				# int row
	lw	$s1, height				# height
	lw	$s2, width				# width

	blt	$s0,   0, print_game_row_inner__if_row_lt_0		# if (row  < 0) {...
	bge	$s0, $s1, print_game_row_inner__if_row_ge_height	# } else if (row >= height) {...
	b	print_game_row_inner__if_row_else			# } else {...

print_game_row_inner__if_row_lt_0:
print_game_row_inner__if_row_ge_height:			# if (row  < 0 || row >= height) {
	li	$v0, SYSCALL_PRINT_STRING
	la	$a0, STR_CORNER_ROW
	syscall						#   printf(STR_CORNER_ROW);

	li	$v0, SYSCALL_PRINT_STRING
	la	$a0, STR_MARGIN_HORIZONTAL
	syscall						#   printf(STR_MARGIN_HORIZONTAL);

	move	$a0, $s2				#   width
	move	$a1, $s0				#   row
	li	$a2, 0
	jal	print_grid_row_cells			#   print_grid_row_cells(width, row, 0);

	b	print_game_row_inner__if_row_end

print_game_row_inner__if_row_else:			# } else {
	li	$a0, 1
	move	$a1, $s0				#   row
	li	$a2, -2
	jal	print_grid_row_cells			#   print_grid_row_cells(1, row, -2);

	li	$v0, SYSCALL_PRINT_STRING
	la	$a0, STR_MARGIN_HORIZONTAL
	syscall						#   printf(STR_MARGIN_HORIZONTAL);

	addi	$a0, $s2, 2				#   width + 2
	move	$a1, $s0				#   row
	li	$a2, -1
	jal	print_grid_row_cells			#   print_grid_row_cells(width + 2, row, -1);

	li	$v0, SYSCALL_PRINT_STRING
	la	$a0, STR_MARGIN_HORIZONTAL
	syscall						#   printf(STR_MARGIN_HORIZONTAL);

	li	$a0, 1
	move	$a1, $s0				#   row
	addi	$a2, $s2, 1				#   width + 1
	jal	print_grid_row_cells			#   print_grid_row_cells(1, row, width + 1);

print_game_row_inner__if_row_end:			# } 

	li	$v0, SYSCALL_PRINT_CHAR
	li	$a0, '\n'
	syscall						# putchar('\n');

print_game_row_inner__epilogue:
	pop	$s2
	pop	$s1
	pop	$s0
	pop	$ra

	jr	$ra


################################################################################
# .TEXT <print_game_row_lower>
	.text
print_game_row_lower:
	# Subset:   N/A - Provided Function
	#
	# Frame:    [$ra, $s0, $s1, $s2]
	# Uses:     [$a0, $s0, $s1, $s2, $t1, $v0, $ra]
	# Clobbers: [$a0, $t1, $v0]
	#
	# Locals:
	#   - $s0: int row
	#   - $s1: int height
	#   - $s2: int width
	#   - $t1: height + 1
	#
	# Structure:
	#   print_game_row_lower
	#   -> [prologue]
	#       -> body
	#           -> if_row_eq_neg2
	#           -> if_row_eq_height
	#           -> if_row_eq_height_plus_1
	#           -> if_end
	#   -> [epilogue]

print_game_row_lower__prologue:
	push	$ra
	push	$s0
	push	$s1
	push	$s2

print_game_row_lower__body:
	move	$s0, $a0					# int row
	lw	$s1, height
	lw	$s2, width

	beq	$s0,  -2, print_game_row_lower__if_row_eq_neg2		# if (row == -2) {...
	beq	$s0, $s1, print_game_row_lower__if_row_eq_height	# } else if (row == height) {...
	addi	$t1, $s1, 1						# height + 1
	beq	$s0, $t1, print_game_row_lower__if_row_eq_height_plus_1	# } else if (row == height + 1) {...
	b	print_game_row_lower__if_end

print_game_row_lower__if_row_eq_neg2:
print_game_row_lower__if_row_eq_height:
print_game_row_lower__if_row_eq_height_plus_1:			# if (row == -2 || row == height || row == height + 1) {
	li	$v0, SYSCALL_PRINT_STRING
	la	$a0, STR_CORNER_ROW
	syscall							#   printf(STR_CORNER_ROW);

	li	$v0, SYSCALL_PRINT_STRING
	la	$a0, STR_MARGIN_HORIZONTAL
	syscall							#   printf(STR_MARGIN_HORIZONTAL);

	move	$a0, $s2
	jal	print_grid_row_edge_lower			#   print_grid_row_edge_lower(width);

	li	$v0, SYSCALL_PRINT_STRING
	la	$a0, STR_MARGIN_VERTICAL
	syscall							#   printf(STR_MARGIN_VERTICAL);

print_game_row_lower__if_end:					# } 

print_game_row_lower__epilogue:
	pop	$s2
	pop	$s1
	pop	$s0
	pop	$ra

	jr	$ra


################################################################################
# .TEXT <print_grid_row_edge>
	.text
print_grid_row_edge:
	# Subset:   N/A - Provided Function
	#
	# Frame:    [$s0, $s1, $s2, $s3]
	# Uses:     [$a0, $a1, $a2, $a3, $s0, $s1, $s2, $s3, $t0, $t1, $v0]
	# Clobbers: [$a0, $a1, $a2, $a3, $v0, $t0, $t1]
	#
	# Locals:
	#   - $s0: int size
	#   - $s1: char *left
	#   - $s2: char *inter
	#   - $s3: char *right
	#   - $t0: int col
	#   - $t1: (size - 1)
	#
	# Structure:
	#   print_grid_row_edge
	#   -> [prologue]
	#       -> body
	#           -> loop_col__init
	#           -> loop_col__cond
	#           -> loop_col__body
	#           -> loop_col__step
	#           -> loop_col__end
	#   -> [epilogue]

print_grid_row_edge__prologue:
	push	$s0
	push	$s1
	push	$s2
	push	$s3

print_grid_row_edge__body:
	move	$s0, $a0					# int size
	move	$s1, $a1					# char *left
	move	$s2, $a2					# char *inter
	move	$s3, $a3					# char *right

	li	$v0, SYSCALL_PRINT_STRING
	move	$a0, $s1
	syscall							# printf("%s", left);

print_grid_row_edge__loop_col__init:
	li	$t0, 0						# int col = 0;
	sub	$t1, $s0, 1					# (size - 1)

print_grid_row_edge__loop_col__cond:				# while (col < size - 1) {
	bge	$t0, $t1, print_grid_row_edge__loop_col__end

print_grid_row_edge__loop_col__body:
	li	$v0, SYSCALL_PRINT_STRING
	la	$a0, STR_BORDER_HORIZONTAL
	syscall							#   printf(STR_BORDER__HORIZONTAL);

	li	$v0, SYSCALL_PRINT_STRING
	move	$a0, $s2
	syscall							#   printf("%s", inter);

print_grid_row_edge__loop_col__step:
	addi	$t0, $t0, 1					#   col++;
	b	print_grid_row_edge__loop_col__cond

print_grid_row_edge__loop_col__end:				# }

	li	$v0, SYSCALL_PRINT_STRING
	la	$a0, STR_BORDER_HORIZONTAL
	syscall							# printf(STR_BORDER__HORIZONTAL);

	li	$v0, SYSCALL_PRINT_STRING
	move	$a0, $s3
	syscall							# printf("%s", right);

print_grid_row_edge__epilogue:
	pop	$s3
	pop	$s2
	pop	$s1
	pop	$s0

	jr	$ra


################################################################################
# .TEXT <print_grid_row_edge_upper>
	.text
print_grid_row_edge_upper:
	# Subset:   N/A - Provided Function
	#
	# Frame:    [$ra]
	# Uses:     [$ra, $a0, $a1, $a2, $a3]
	# Clobbers: [$a0, $a1, $a2, $a3]
	#
	# Locals:
	#   - (none)
	#
	# Structure:
	#   print_grid_row_edge_upper
	#   -> [prologue]
	#       -> body
	#   -> [epilogue]

print_grid_row_edge_upper__prologue:
	push	$ra

print_grid_row_edge_upper__body:
						# print_grid_row_edge(
	move	$a0, $a0			#   size,
	la	$a1, STR_CORNER_TOP_LEFT	#   STR_CORNER_TOP_LEFT,
	la	$a2, STR_INTERSECT_TOP		#   STR_INTERSECT_TOP,
	la	$a3, STR_CORNER_TOP_RIGHT	#   STR_CORNER_TOP_RIGHT
	jal	print_grid_row_edge		# );

print_grid_row_edge_upper__epilogue:
	pop	$ra

	jr	$ra


################################################################################
# .TEXT <print_grid_row_edge_inner>
	.text
print_grid_row_edge_inner:
	# Subset:   N/A - Provided Function
	#
	# Frame:    [$ra]
	# Uses:     [$ra, $a0, $a1, $a2, $a3]
	# Clobbers: [$a0, $a1, $a2, $a3]
	#
	# Locals:
	#   - (none)
	#
	# Structure:
	#   print_grid_row_edge_inner
	#   -> [prologue]
	#       -> body
	#   -> [epilogue]

print_grid_row_edge_inner__prologue:
	push	$ra

print_grid_row_edge_inner__body:
						# print_grid_row_edge(
	move	$a0, $a0			#   size,
	la	$a1, STR_INTERSECT_LEFT		#   STR_INTERSECT_LEFT,
	la	$a2, STR_INTERSECT_CENTRE	#   STR_INTERSECT_CENTRE,
	la	$a3, STR_INTERSECT_RIGHT	#   STR_INTERSECT_RIGHT
	jal	print_grid_row_edge		# );

print_grid_row_edge_inner__epilogue:
	pop	$ra

	jr	$ra


################################################################################
# .TEXT <print_grid_row_edge_lower>
	.text
print_grid_row_edge_lower:
	# Subset:   N/A - Provided Function
	#
	# Frame:    [$ra]
	# Uses:     [$ra, $a0, $a1, $a2, $a3]
	# Clobbers: [$a0, $a1, $a2, $a3]
	#
	# Locals:
	#   - (none)
	#
	# Structure:
	#   print_grid_row_edge_lower
	#   -> [prologue]
	#       -> body
	#   -> [epilogue]

print_grid_row_edge_lower__prologue:
	push	$ra

print_grid_row_edge_lower__body:
						# print_grid_row_edge(
	move	$a0, $a0			#   size,
	la	$a1, STR_CORNER_BOT_LEFT	#   STR_CORNER_BOT_LEFT,
	la	$a2, STR_INTERSECT_BOT		#   STR_INTERSECT_BOT,
	la	$a3, STR_CORNER_BOT_RIGHT	#   STR_CORNER_BOT_RIGHT
	jal	print_grid_row_edge		# );

print_grid_row_edge_lower__epilogue:
	pop	$ra

	jr	$ra


################################################################################
# .TEXT <print_grid_row_cells>
	.text
print_grid_row_cells:
	# Subset:   N/A - Provided Function
	#
	# Frame:    [$ra, $s0, $s1, $s2, $s3, $s4]
	# Uses:     [$ra, $a0, $a1, $a2, $v0, $s0, $s1, $s2, $s3, $s4]
	# Clobbers: [$a0, $a1, $a2, $v0]
	#
	# Locals:
	#   - $s0: int size
	#   - $s1: int row
	#   - $s2: int start_column
	#   - $s3: int col
	#   - $s4: int end_col
	#
	# Structure:
	#   print_grid_row_cells
	#   -> prologue
	#   -> body
	#       -> col_loop__init
	#       -> col_loop__cond
	#       -> col_loop__body
	#       -> col_loop__step
	#       -> col_loop__end
	#   -> epilogue

print_grid_row_cells__prologue:
	push	$ra
	push	$s0
	push	$s1
	push	$s2
	push	$s3
	push	$s4

print_grid_row_cells__body:
	move	$s0, $a0				# int size
	move	$s1, $a1				# int row
	move	$s2, $a2				# int start_column

	li	$v0, SYSCALL_PRINT_STRING
	la	$a0, STR_BORDER_VERTICAL
	syscall						# printf(STR_BORDER_VERTICAL);

print_grid_row_cells__col_loop__init:
	move	$s3, $s2				# int col = start_column;
	add	$s4, $s0, $s2				# size + start_column

print_grid_row_cells__col_loop__cond:			# while (col < size + start_column) {
	bge	$s3, $s4, print_grid_row_cells__col_loop__end

print_grid_row_cells__col_loop__body:
	move	$a0, $s1
	move	$a1, $s3
	jal	print_cell_content			#   print_cell_content(row, col);

	li	$v0, SYSCALL_PRINT_STRING
	la	$a0, STR_BORDER_VERTICAL
	syscall						# printf(STR_BORDER_VERTICAL);

print_grid_row_cells__col_loop__step:
	addi	$s3, $s3, 1				#   col++;
	b	print_grid_row_cells__col_loop__cond

print_grid_row_cells__col_loop__end:			# }

print_grid_row_cells__epilogue:
	pop	$s4
	pop	$s3
	pop	$s2
	pop	$s1
	pop	$s0
	pop	$ra

	jr	$ra


################################################################################
# .TEXT <print_cell_content>
	.text
print_cell_content:
	# Subset:   N/A - Provided Function
	#
	# Frame:    [$ra, $s0, $s1, $s2, $s3, $s4, $s5]
	# Uses:     [$ra, $a0, $a1, $v0, $s0, $s1, $s2, $s3, $s4, $s5, $t0, $t1]
	# Clobbers: [$a0, $a1, $v0, $t0, $t1]
	#
	# Locals:
	#   - $s0: int row
	#   - $s1: int col
	#   - $s2: result of is_position_an_edge_number(row, col)
	#   - $s3: result of is_position_in_box(row, col)
	#   - $s4: result of is_position_a_path_result(row, col)
	#   - $s5: pointer for box[row][col] (address calculation)
	#   - $t0: temporary for memory loads, edge number, path state
	#   - $t1: temporary for logical/conditional tests
	#
	# Structure:
	#   print_cell_content
	#   -> prologue
	#   -> body
	#       -> if_edge_number
	#       -> elseif_in_box_guessed
	#           -> print_no_cat1
	#       -> elseif_in_box_cheating
	#           -> print_nocat_2
	#       -> elseif_path_result
	#           -> path_state_not_checked
	#           -> path_state_absorbed
	#           -> path_state_reflected
	#           -> path_state_checked
	#       -> else
	#   -> epilogue

print_cell_content__prologue:
	push	$ra
	push	$s0
	push	$s1
	push	$s2
	push	$s3
	push	$s4
	push	$s5

print_cell_content__body:
	move	$s0, $a0					# int row
	move	$s1, $a1					# int col

	move	$a0, $s0		
	move	$a1, $s1
	jal	is_position_an_edge_number
	move	$s2, $v0					# is_position_an_edge_number(row, col)

	move	$a0, $s0
	move	$a1, $s1
	jal	is_position_in_box
	move	$s3, $v0					# is_position_in_box(row, col)

	move	$a0, $s0
	move	$a1, $s1
	jal	is_position_a_path_result
	move	$s4, $v0					# is_position_a_path_result(row, col)

	move	$s5, $s0					# row
	mul	$s5, $s5, MAX_BOX_SIZE				# row * MAX_BOX_SIZE
	add	$s5, $s5, $s1					# row * MAX_BOX_SIZE + col
	mul	$s5, $s5, SIZEOF_INT				# (row * MAX_BOX_SIZE + col) * SIZEOF_INT
	add	$s5, $s5, box					# &box.contains_cat[row][col]

	beq	$s2, TRUE, print_cell_content__if_edge_number		# if (is_position_an_edge_number(row, col)) {...

	lw	$t0, OFFSET_BOX_GUESSED($s5)
	and	$t1, $s3, $t0
	beq	$t1, TRUE, print_cell_content__elseif_in_box_guessed	# } else if (is_position_in_box(row, col) && box.guessed[row][col]) {...

	lw	$t0, is_cheat_mode
	and	$t1, $s3, $t0
	beq	$t1, TRUE, print_cell_content__elseif_in_box_cheating	# } else if (is_position_in_box(row, col) && is_cheat_mode) {

	beq	$s4, TRUE, print_cell_content__elseif_path_result	# } else if (is_position_a_path_result(row, col)) {...

	b	print_cell_content__else				# } else {...

print_cell_content__if_edge_number:				# if (is_position_an_edge_number(row, col)) {
	move	$a0, $s0					#   row
	move	$a1, $s1					#   col
	jal	edge_number_from_position			#   int edge_number = edge_number_from_position(row, col);

	move	$a0, $v0
	jal	print_edge_number				#   print_edge_number(edge_number);
	
	b	print_cell_content__epilogue

print_cell_content__elseif_in_box_guessed:			# } else if (is_position_in_box(row, col) && box.guessed[row][col]) {
	lw	$t0, ($s5)
	bne	$t0, TRUE, print_cell_content__print_no_cat1	#   if (box.contains_cat[row][col]) {

	li	$v0, SYSCALL_PRINT_STRING
	la	$a0, STR_SPRITE_CAT
	syscall							#     printf(STR_SPRITE_CAT);
	b	print_cell_content__epilogue		

print_cell_content__print_no_cat1:				#   } else {
	li	$v0, SYSCALL_PRINT_STRING
	la	$a0, STR_SPRITE_NOCAT
	syscall							#     printf(STR_SPRITE_NOCAT);

	b	print_cell_content__epilogue			#   }	

print_cell_content__elseif_in_box_cheating:			# } else if (is_position_in_box(row, col) && is_cheat_mode) {
	lw	$t0, ($s5)
	bne	$t0, TRUE, print_cell_content__print_nocat_2	#   if (box.contains_cat[row][col]) {

	li	$v0, SYSCALL_PRINT_STRING
	la	$a0, STR_SPRITE_CAT
	syscall							#     printf(STR_SPRITE_CAT);

	b	print_cell_content__epilogue			

print_cell_content__print_nocat_2:				#   } else {
	li	$v0, SYSCALL_PRINT_STRING
	la	$a0, STR_SPRITE_EMPTY
	syscall							#     printf(STR_SPRITE_EMPTY);

	b	print_cell_content__epilogue			#   }

print_cell_content__elseif_path_result:				# } else if (is_position_a_path_result(row, col)) {
	move	$a0, $s0					#   row
	move	$a1, $s1					#   col
	jal	edge_number_from_position
	move	$t0, $v0					#   int edge_number = edge_number_from_position(row, col);

	sub	$t0, $t0, 1					#   edge_number - 1
	mul	$t0, $t0, SIZEOF_BALL_PATH			#   (edge_number - 1) * SIZEOF_BALL_PATH
	add	$t0, $t0, ball_paths				#   &ball_paths[edge_number - 1]

	lw	$t1, OFFSET_BALL_PATH_STATE($t0)		#   path.state

	beq	$t1, PATH_STATE_NOT_CHECKED, print_cell_content__path_state_not_checked	# if (path.state == PATH_STATE_NOT_CHECKED) {...
	beq	$t1, PATH_STATE_ABSORBED, print_cell_content__path_state_absorbed	# } else if (path.state == PATH_STATE_ABSORBED) {...
	beq	$t1, PATH_STATE_REFLECTED, print_cell_content__path_state_reflected	# } else if (path.state == PATH_STATE_REFLECTED) {...
	beq	$t1, PATH_STATE_CHECKED, print_cell_content__path_state_checked		# } else if (path.state == PATH_STATE_CHECKED) {...

print_cell_content__path_state_not_checked:			# if (path.state == PATH_STATE_NOT_CHECKED) {
	li	$v0, SYSCALL_PRINT_STRING
	la	$a0, STR_SPRITE_EMPTY
	syscall							#   printf(STR_SPRITE_EMPTY);
	b	print_cell_content__epilogue

print_cell_content__path_state_absorbed:			# } else if (path.state == PATH_STATE_ABSORBED) {
	li	$v0, SYSCALL_PRINT_STRING
	la	$a0, STR_SPRITE_ABSORBED
	syscall							#   printf(STR_SPRITE_ABSORBED);
	b	print_cell_content__epilogue

print_cell_content__path_state_reflected:			# } else if (path.state == PATH_STATE_REFLECTED) {
	li	$v0, SYSCALL_PRINT_STRING
	la	$a0, STR_SPRITE_REFLECTED
	syscall							#   printf(STR_SPRITE_REFLECTED);
	b	print_cell_content__epilogue

print_cell_content__path_state_checked:				# } else if (path.state == PATH_STATE_CHECKED) {
	lw	$a0, OFFSET_BALL_PATH_EXIT($t0)
	jal	print_edge_number				#   print_edge_number(path.exit);

	b	print_cell_content__epilogue			# }

print_cell_content__else:					# } else {
	li	$v0, SYSCALL_PRINT_STRING
	la	$a0, STR_SPRITE_EMPTY
	syscall
	b	print_cell_content__epilogue			#   printf(STR_SPRITE_EMPTY);

print_cell_content__epilogue:					# }
	pop	$s5
	pop	$s4
	pop	$s3
	pop	$s2
	pop	$s1
	pop	$s0
	pop	$ra

	jr	$ra


################################################################################
# .TEXT <is_position_in_box>
	.text
is_position_in_box:
	# Subset:   N/A - Provided Function
	#
	# Frame:    []
	# Uses:     [$a0, $a1, $v0, $t0, $t1]
	# Clobbers: [$a0, $a1, $v0, $t0, $t1]
	#
	# Locals:
	#   - $t0: copy of height
	#   - $t1: copy of width
	#
	# Structure:
	#   is_position_in_box
	#   -> [prologue]
	#       -> body
	#   -> [epilogue]
	#   -> [prologue]
	#       -> body
	#       -> true
	#       -> false
	#   -> [epilogue]

is_position_in_box__prologue:

is_position_in_box__body:
	lw	$t0, height
	lw	$t1, width

	bltz	$a0, is_position_in_box__false		# if (row < 0) {...
	bltz	$a1, is_position_in_box__false		# if (col < 0) {...
	bge	$a0, $t0, is_position_in_box__false	# if (row >= height) {...
	bge	$a1, $t1, is_position_in_box__false	# if (col >= width) {...

is_position_in_box__true:
	li	$v0, TRUE				# return TRUE;
	b	is_position_in_box__epilogue

is_position_in_box__false:
	li	$v0, FALSE				# return FALSE;

is_position_in_box__epilogue:
	jr	$ra


################################################################################
# .TEXT <is_position_an_edge_number>
	.text
is_position_an_edge_number:
	# Subset:   N/A - Provided Function
	#
	# Frame:    []
	# Uses:     [$a0, $a1, $v0, $t0, $t1, $t2, $t3, $t4, $t5, $t6, $t7, $t8]
	# Clobbers: [$a0, $a1, $v0, $t0, $t1, $t2, $t3, $t4, $t5, $t6, $t7, $t8]
	#
	# Locals:
	#   - $t0: copy of height
	#   - $t1: copy of width
	#   - $t2: comparison results (col >= 0, row >= 0)
	#   - $t3: comparison results
	#   - $t4: AND results
	#   - $t5: equality tests
	#   - $t6: equality tests
	#   - $t7: OR results
	#   - $t8: OR results
	#
# Structure:
	#   is_position_an_edge_number
	#   -> [prologue]
	#       ->body
	#       -> is_position_an_edge_number__return_false
	#       -> is_position_an_edge_number__return_true
	#   -> [epilogue]

is_position_an_edge_number__prologue:

is_position_an_edge_number__body:
	lw	$t0, height
	lw	$t1, width

	sge	$t2, $a1, 0			# col >= 0
	slt	$t3, $a1, $t1			# col < width
	and	$t4, $t2, $t3			# int col_in_range = (col >= 0 && col < width);

	seq	$t5, $a0, -1			# row == -1
	seq	$t6, $a0, $t0			# row == height
	or	$t7, $t5, $t6			# int is_edge_row = (row == -1 || row == height);

	and	$t8, $t4, $t7			# (col_in_range && is_edge_row)
	beq	$t8, TRUE, is_position_an_edge_number__return_true	# if (col_in_range && is_edge_row) {...

	sge	$t2, $a0, 0			# row >= 0
	slt	$t3, $a0, $t0			# row < height
	and	$t4, $t2, $t3			# int row_in_range = (row >= 0 && row < height);

	seq	$t5, $a1, -1			# col == -1
	seq	$t6, $a1, $t1			# col == width
	or	$t7, $t5, $t6			# int is_edge_col = (col == -1 || col == width);

	and	$t8, $t4, $t7			# (row_in_range && is_edge_col)
	beq	$t8, TRUE, is_position_an_edge_number__return_true	# if (row_in_range && is_edge_col) {...

is_position_an_edge_number__return_false:
	li	$v0, FALSE			# return FALSE;
	b	is_position_an_edge_number__epilogue

is_position_an_edge_number__return_true:
	li	$v0, TRUE			# return TRUE;

is_position_an_edge_number__epilogue:
	jr	$ra				# return ((col_in_range && is_edge_row) || (row_in_range && is_edge_col));


################################################################################
# .TEXT <is_position_a_path_result>
	.text
is_position_a_path_result:
	# Subset:   N/A - Provided Function
	#
	# Frame:    []
	# Uses:     [$a0, $a1, $v0, $t0, $t1, $t2, $t3, $t4, $t5, $t6, $t7, $t8, $t9]
	# Clobbers: [$a0, $a1, $v0, $t0, $t1, $t2, $t3, $t4, $t5, $t6, $t7, $t8, $t9]
	#
	# Locals:
	#   - $t0: copy of height
	#   - $t1: copy of width
	#   - $t2: comparisons (col >= 0, row >= 0)
	#   - $t3: comparisons (col < width, row < height)
	#   - $t4: AND tests
	#   - $t5: equality comparisons
	#   - $t6: equality comparisons
	#   - $t7: OR tests
	#   - $t8: AND tests
	#   - $t9: to compute (height+1) and (width+1)
	#
	# Structure:
	#   is_position_a_path_result
	#     -> [prologue]
	#     -> body
	#     -> return_false
	#     -> return_true
	#     -> [epilogue]

is_position_a_path_result__prologue:

is_position_a_path_result__body:
	lw	$t0, height
	lw	$t1, width

	sge	$t2, $a1, 0			# col >= 0
	slt	$t3, $a1, $t1			# col < width
	and	$t4, $t2, $t3			# int col_in_range = (col >= 0 && col < width);

	seq	$t5, $a0, -2			# row == -2
	add	$t9, $t0, 1			# height + 1
	seq	$t6, $a0, $t9			# row == height + 1
	or	$t7, $t5, $t6			# int is_path_row = (row == -2 || row == height + 1);

	and	$t8, $t4, $t7			# (col_in_range && is_path_row)
	beq	$t8, TRUE, is_position_a_path_result__return_true	# if (col_in_range && is_path_row) {...

	sge	$t2, $a0, 0			# row >= 0
	slt	$t3, $a0, $t0			# row < height
	and	$t4, $t2, $t3			# int row_in_range = (row >= 0 && row < height);

	seq	$t5, $a1, -2			# col == -2
	add	$t9, $t1, 1			# width + 1
	seq	$t6, $a1, $t9			# col == width + 1
	or	$t7, $t5, $t6			# int is_path_col = (col == -2 || col == width + 1);

	and	$t8, $t4, $t7			# (row_in_range && is_path_col)
	beq	$t8, TRUE, is_position_a_path_result__return_true	# if (row_in_range && is_path_col) {...

is_position_a_path_result__return_false:
	li	$v0, FALSE			# return FALSE;
	b	is_position_an_edge_number__epilogue

is_position_a_path_result__return_true:
	li	$v0, TRUE			# return TRUE;

is_position_a_path_result__epilogue:
	jr	$ra


################################################################################
# .TEXT <print_edge_number>
	.text
print_edge_number:
	# Subset:   N/A - Provided Function
	#
	# Frame:    []
	# Uses:     [$v0, $a0, $t0]
	# Clobbers: [$v0, $a0, $t0]
	#
	# Locals:
	#   - $t0: local copy of number
	#
	# Structure:
	# -> [prologue]
	# -> print_edge_number__body
	#    -> if_number_lt_10
	#    -> if_number_lt_100
	#    -> if_else
	# -> [epilogue]

print_edge_number__prologue:
	move	$t0, $a0			# int number

print_edge_number__body:
	blt	$a0,  10, print_edge_number__if_number_lt_10	# if (number < 10) {...
	blt	$a0, 100, print_edge_number__if_number_lt_100	# } else if (number < 100) {...
	b	print_edge_number__if_else			# } else {...

print_edge_number__if_number_lt_10:		# if (number < 10) {
	li	$v0, SYSCALL_PRINT_CHAR
	li	$a0, ' '
	syscall					#   putchar(' ');

	li	$v0, SYSCALL_PRINT_INT
	move	$a0, $t0
	syscall					#   printf(" %d ", number);

	li	$v0, SYSCALL_PRINT_CHAR
	li	$a0, ' '
	syscall					#   putchar(' ');

	b	print_edge_number__epilogue

print_edge_number__if_number_lt_100:		# } else if (number < 100) {
	li	$v0, SYSCALL_PRINT_CHAR
	li	$a0, ' '
	syscall					#   putchar(' ');

	li	$v0, SYSCALL_PRINT_INT
	move	$a0, $t0
	syscall					#   printf(" %d ", number);

	b	print_edge_number__epilogue

print_edge_number__if_else:			# } else {

	li	$v0, SYSCALL_PRINT_INT
	move	$a0, $t0
	syscall					#   printf(" %d ", number);

print_edge_number__epilogue:			# }
	jr	$ra


	.data
# ##########################################################
# #################### Global variables ####################
# ##########################################################

# !!! DO NOT ADD, REMOVE, OR MODIFY ANY OF THESE DEFINITIONS !!!

random_number:			# int random_number;
	.word	0

height:				# int height;
	.word	0

width:				# int width;
	.word	0

num_cats:			# int num_cats;
	.word	0

num_cats_found:			# int num_cats_found;
	.word	0

score:				# int score;
	.word	0

cost_per_roll:			# int cost_per_roll;
	.word	0

is_cheat_mode:			# int is_cheat_mode;
	.word	0

is_auto_print:			# int is_auto_print;
	.word	0

game_state:			# int game_state;
	.word	0

guess_x:			# int guess_x;
	.word	0

guess_y:			# int guess_y;
	.word	0

ball_of_string:			# struct ball_of_string ball_of_string;
	.space	SIZEOF_BALL

ball_paths:			# struct ball_path ball_paths[MAX_PATHS];
	.space	MAX_PATHS * SIZEOF_BALL_PATH

box:				# struct box box;
	.space	SIZEOF_BOX

game:				# struct game game
	.word	ball_of_string, ball_paths, box

game_pointer:			# struct game *game_pointer = &game;
	.word	game


cat_name:			# char cat_name[CAT_NAME_BUFFER_SIZE];
	.byte	0:CAT_NAME_BUFFER_SIZE * SIZEOF_CHAR

cat_title_0:
	.asciiz	"Admiral"
cat_title_1:
	.asciiz	"Baron"
cat_title_2:
	.asciiz	"Baroness"
cat_title_3:
	.asciiz	"Captain"
cat_title_4:
	.asciiz	"Chairman"
cat_title_5:
	.asciiz	"Count"
cat_title_6:
	.asciiz	"Countess"
cat_title_7:
	.asciiz	"Councillor"
cat_title_8:
	.asciiz	"Duchess"
cat_title_9:
	.asciiz	"Duke"
cat_title_10:
	.asciiz	"Emperor"
cat_title_11:
	.asciiz	"Empress"
cat_title_12:
	.asciiz	"Lady"
cat_title_13:
	.asciiz	"Lord"
cat_title_14:
	.asciiz	"Master"
cat_title_15:
	.asciiz	"Mistress"
cat_title_16:
	.asciiz	"Professor"
cat_title_17:
	.asciiz	"Sheriff"
	.align 2
cat_titles:			# char *cat_titles[]
	.word	cat_title_0,  cat_title_1,  cat_title_2,  cat_title_3,
	.word	cat_title_4,  cat_title_5,  cat_title_6,  cat_title_7,
	.word	cat_title_8,  cat_title_9,  cat_title_10, cat_title_11,
	.word	cat_title_12, cat_title_13, cat_title_14, cat_title_15,
	.word	cat_title_16, cat_title_17

cat_surname_0:
	.asciiz	"Biscuit"
cat_surname_1:
	.asciiz	"Blueberry"
cat_surname_2:
	.asciiz	"Chonk"
cat_surname_3:
	.asciiz	"Crumpet"
cat_surname_4:
	.asciiz	"Fluffernap"
cat_surname_5:
	.asciiz	"Fuzzington"
cat_surname_6:
	.asciiz	"Loaf"
cat_surname_7:
	.asciiz	"Macaroon"
cat_surname_8:
	.asciiz	"Marmalade"
cat_surname_9:
	.asciiz	"Marshmallow"
cat_surname_10:
	.asciiz	"Meow"
cat_surname_11:
	.asciiz	"Mittensworth"
cat_surname_12:
	.asciiz	"Moonclaw"
cat_surname_13:
	.asciiz	"Nibbleton"
cat_surname_14:
	.asciiz	"Nightwhisker"
cat_surname_15:
	.asciiz	"Parmesan"
cat_surname_16:
	.asciiz	"Peaches"
cat_surname_17:
	.asciiz	"Pickles"
cat_surname_18:
	.asciiz	"Pudding"
cat_surname_19:
	.asciiz	"Puddingtail"
cat_surname_20:
	.asciiz	"Pumpkin"
cat_surname_21:
	.asciiz	"Purrington"
cat_surname_22:
	.asciiz	"Snugglemane"
cat_surname_23:
	.asciiz	"Stardancer"
cat_surname_24:
	.asciiz	"Sugarstripe"
cat_surname_25:
	.asciiz	"Thunderpaw"
cat_surname_26:
	.asciiz	"Toebean"
cat_surname_27:
	.asciiz	"Velvetwhisker"
cat_surname_28:
	.asciiz	"von Milkthief"
cat_surname_29:
	.asciiz	"Waffles"
	.align 2
cat_surnames:			# char *cat_surnames[]
	.word	cat_surname_0,  cat_surname_1,  cat_surname_2,  cat_surname_3,
	.word	cat_surname_4,  cat_surname_5,  cat_surname_6,  cat_surname_7,
	.word	cat_surname_8,  cat_surname_9,  cat_surname_10, cat_surname_11,
	.word	cat_surname_12, cat_surname_13, cat_surname_14, cat_surname_15,
	.word	cat_surname_16, cat_surname_17, cat_surname_18, cat_surname_19,
	.word	cat_surname_20, cat_surname_21, cat_surname_22, cat_surname_23,
	.word	cat_surname_24, cat_surname_25, cat_surname_26, cat_surname_27,
	.word	cat_surname_28, cat_surname_29

# ##########################################################
# ######################### Strings ########################
# ##########################################################

# !!! DO NOT ADD, REMOVE, OR MODIFY ANY OF THESE STRINGS !!!

str_print_welcome_1:
	.asciiz	"===============================================================\n"
str_print_welcome_2:
	.asciiz	"                     Welcome to Cat Scan!\n"
str_print_welcome_3:
	.asciiz	"===============================================================\n"
str_print_welcome_4:
	.asciiz	"┌─────────┐  ┌─────────┐  ┌─────────┐  ┌─────────┐  ┌─────────┐\n"
str_print_welcome_5:
	.asciiz	"│  /\\_/\\  │  │  /\\_/\\  │  │  /\\_/\\  │  │  /\\_/\\  │  │  /\\_/\\  │\n"
str_print_welcome_6:
	.asciiz	"│ ( o.o ) │  │ ( ^_^ ) │  │ ( -.- ) │  │ ( uwu ) │  │ ( z_z ) │\n"
str_print_welcome_7:
	.asciiz	"│ /     \\ │  │ /     \\ │  │ /     \\ │  │ /     \\ │  │ /     \\ │\n"
str_print_welcome_8:
	.asciiz	"└─────────┘  └─────────┘  └─────────┘  └─────────┘  └─────────┘\n"
str_print_welcome_9:
	.asciiz	"===============================================================\n\n"

str_game_setup_1:
	.asciiz	"a random seed"
str_game_setup_2:
	.asciiz	"a height"
str_game_setup_3:
	.asciiz	"a width "

str_prompt_for_int_1:
	.asciiz	"Enter "
str_prompt_for_int_2:
	.asciiz	" (from "
str_prompt_for_int_3:
	.asciiz	" to "
str_prompt_for_int_4:
	.asciiz	"): "
str_prompt_for_int_err_1:
	.asciiz	"Bad Input: value should be between "
str_prompt_for_int_err_2:
	.asciiz	" and "
str_prompt_for_int_err_3:
	.asciiz	" (inclusive)\n"

str_game_loop_1:
	.asciiz	"All cats found.\n"
str_game_loop_2:
	.asciiz	"You win! Final Score: "
str_game_loop_3:
	.asciiz	"Game Over.\n"

str_print_stats_1:
	.asciiz "You have "
str_print_stats_2:
	.asciiz " points = "
str_print_stats_3:
	.asciiz " guess / "
str_print_stats_4:
	.asciiz " guesses / "
str_print_stats_5:
	.asciiz " roll(s) left, with "
str_print_stats_6:
	.asciiz " cat(s) remaining.\n"

str_guess_cat_location_1:
	.asciiz "a row edge number"
str_guess_cat_location_2:
	.asciiz "a col edge number"
str_guess_cat_location_3:
	.asciiz "Bad Input: This location has already been guessed. Try again!\n"
str_guess_cat_location_4:
	.asciiz "Good Guess! [+"
str_guess_cat_location_5:
	.asciiz " points]\n"
str_guess_cat_location_6:
	.asciiz "You found \""
str_guess_cat_location_7:
	.asciiz "\"\n"
str_guess_cat_location_8:
	.asciiz "Bad Guess [-"
str_guess_cat_location_9:
	.asciiz " points]\n"

str_roll_ball_of_string_1:
	.asciiz	"Ball entered "
str_roll_ball_of_string_2:
	.asciiz	" and was ABSORBED\n"
str_roll_ball_of_string_3:
	.asciiz	" and exited "
str_roll_ball_of_string_4:
	.asciiz	"Roll Cost [-"
str_roll_ball_of_string_5:
	.asciiz	" points]\n"

str_configure_ball:
	.asciiz "an edge number"

# The strings below this comment are only used by the provided functions.
str_process_command_prompt:
	.asciiz	"\nEnter Command: "
str_process_command_help:
	.asciiz	"(printing help)\n"
str_process_command_autoprint_1:
	.asciiz	"(auto-print turned "
str_process_command_autoprint_2:
	.asciiz	"OFF)\n"
str_process_command_autoprint_3:
	.asciiz	"ON)\n"
str_process_command_print_stats:
	.asciiz	"(printing game stats)\n"
str_process_command_print_game:
	.asciiz	"(printing game)\n"
str_process_command_guess:
	.asciiz	"(guessing cat location)\n"
str_process_command_roll:
	.asciiz	"(rolling ball of string from edge)\n"
str_process_command_cheat:
	.asciiz	"(cheating)\n"
str_process_command_debug:
	.asciiz	"(printing debug info)"
str_process_command_quit:
	.asciiz	"(quitting)\n"
str_process_command_bad_command:
	.asciiz	"(bad command)\n"

str_print_help_line:
	.asciiz	"\n===============================================================\n"
str_print_help_intro_1:
	.asciiz	"There are "
str_print_help_intro_2:
	.asciiz	" cats hidden in a "
str_print_help_intro_3:
	.asciiz	"-by-"
str_print_help_intro_4:
	.asciiz	" box. Your goal is to deduce\ntheir locations by rolling balls of "
str_print_help_intro_5:
	.asciiz	"string in from the edges\nand noticing where they exit the grid.\n"
str_print_help_interact_1:
	.asciiz	"\nBalls of string interact with cats as follows:\n"
str_print_help_interact_2:
	.asciiz	"- Absorbed:         when hitting a cat directly.\n"
str_print_help_interact_3:
	.asciiz	"- Deflected 90 degrees:  when passing diagonally near a cat.\n"
str_print_help_interact_4:
	.asciiz	"- Reflected:        when aimed between two cats one square apart.\n"
str_print_help_interact_5:
	.asciiz	"- Reflected:        when deflected before entering the box.\n"
str_print_help_interact_6:
	.asciiz	"- Straight-line:    otherwise (no interaction).\n"
str_print_help_score:
	.asciiz	"\nStarting Score: "
str_print_help_points_1:
	.asciiz	"\n\nPoints/Costs:\n- Correct guess   = +"
str_print_help_points_2:
	.asciiz	" points\n- Incorrect guess = -"
str_print_help_points_3:
	.asciiz	" points\n- Rolling a ball  = -"
str_print_help_cmds:
	.asciiz	" points\n\nAvailable Commands:\n "
str_print_help_cmd_help:
	.asciiz	" - Print this help message.\n "
str_print_help_cmd_print_game:
	.asciiz	" - Print the game.\n "
str_print_help_cmd_autoprint:
	.asciiz	" - Toggle auto-print ON/OFF.\n "
str_print_help_cmd_guess:
	.asciiz	" - Guess a cat location.\n "
str_print_help_cmd_roll:
	.asciiz	" - Roll a ball of string.\n "
str_print_help_cmd_print_stats:
	.asciiz	" - Print game stats.\n "
str_print_help_cmd_cheat:
	.asciiz	" - Cheat (reveal cat positions).\n "
str_print_help_cmd_debug:
	.asciiz	" - Debug info.\n "
str_print_help_cmd_quit:
	.asciiz	" - Quit the game.\n"

str_print_debug_info_header:
	.asciiz	"\n================ DEBUG INFO ================\n"
str_print_debug_info_random_number:
	.asciiz	"random_number  = "
str_print_debug_info_height:
	.asciiz	"\nheight         = "
str_print_debug_info_width:
	.asciiz	"\nwidth          = "
str_print_debug_info_num_cats:
	.asciiz	"\nnum_cats       = "
str_print_debug_info_num_cats_found:
	.asciiz	"\nnum_cats_found = "
str_print_debug_info_score:
	.asciiz	"\nscore          = "
str_print_debug_info_cost_per_roll:
	.asciiz	"\ncost_per_roll  = "
str_print_debug_info_is_cheat_mode:
	.asciiz	"\nis_cheat_mode  = "
str_print_debug_info_game_state:
	.asciiz	"\ngame_state     = "
str_print_debug_info_guess_x:
	.asciiz	"\nguess_x        = "
str_print_debug_info_guess_y:
	.asciiz	"\nguess_y        = "
str_print_debug_info_cat_name_1:
	.asciiz	"\ncat_name       = \""
str_print_debug_info_cat_name_2:
	.asciiz	"\"\n"
str_print_debug_info_box_contains_header:
	.asciiz	"\n                     "
str_print_debug_info_box_contains_1:
	.asciiz	"box.contains_cat["
str_print_debug_info_box_contains_2:
	.asciiz	"]: "
str_print_debug_info_box_guessed_header:
	.asciiz	"\n                "
str_print_debug_info_box_guessed_1:
	.asciiz	"box.guessed["
str_print_debug_info_box_guessed_2:
	.asciiz	"]: "
str_print_debug_info_ball_start:
	.asciiz	"\nball_of_string.start = "
str_print_debug_info_ball_x:
	.asciiz	"\nball_of_string.x     = "
str_print_debug_info_ball_y:
	.asciiz	"\nball_of_string.y     = "
str_print_debug_info_ball_dx:
	.asciiz	"\nball_of_string.dx    = "
str_print_debug_info_ball_dy:
	.asciiz	"\nball_of_string.dy    = "
str_print_debug_info_ball_state:
	.asciiz	"\nball_of_string.state = "
str_print_debug_info_ball_paths_1:
	.asciiz	"ball_paths["
str_print_debug_info_ball_paths_2:
	.asciiz	"]: { entry: "
str_print_debug_info_ball_paths_3:
	.asciiz	", exit: "
str_print_debug_info_ball_paths_4:
	.asciiz	", state: "
str_print_debug_info_ball_paths_5:
	.asciiz	" }\n"

str_print_smiling_cat_1:
	.asciiz	"┌─────────┐\n"
str_print_smiling_cat_2:
	.asciiz	"│  /\\_/\\  │\n"
str_print_smiling_cat_3:
	.asciiz	"│ (*^_^*) │\n"
str_print_smiling_cat_4:
	.asciiz	"│ /     \\ │\n"
str_print_smiling_cat_5:
	.asciiz	"└─────────┘\n"

str_print_crying_cat_1:
	.asciiz	"┌─────────┐\n"
str_print_crying_cat_2:
	.asciiz	"│  /\\_/\\  │\n"
str_print_crying_cat_3:
	.asciiz	"│ ( T_T ) │\n"
str_print_crying_cat_4:
	.asciiz	"│ /     \\ │\n"
str_print_crying_cat_5:
	.asciiz	"└─────────┘\n"

str_edge_number_from_position_1:
	.asciiz	"Fatal Error: edge_number_from_position(): position not on edge\n"

STR_CORNER_ROW:
	.asciiz	"         "
STR_CORNER_TOP_LEFT:
	.asciiz	"┌"
STR_CORNER_TOP_RIGHT:
	.asciiz	"┐"
STR_CORNER_BOT_LEFT:
	.asciiz	"└"
STR_CORNER_BOT_RIGHT:
	.asciiz	"┘"
STR_BORDER_HORIZONTAL:
	.asciiz	"───"
STR_BORDER_VERTICAL:
	.asciiz	"│"
STR_INTERSECT_TOP:
	.asciiz	"┬"
STR_INTERSECT_BOT:
	.asciiz	"┴"
STR_INTERSECT_LEFT:
	.asciiz	"├"
STR_INTERSECT_RIGHT:
	.asciiz	"┤"
STR_INTERSECT_CENTRE:
	.asciiz	"┼"
STR_MARGIN_HORIZONTAL:
	.asciiz	" "
STR_MARGIN_VERTICAL:
	.asciiz	"\n"
STR_SPRITE_CAT:
	.asciiz	"^_^"
STR_SPRITE_NOCAT:
	.asciiz	" X "
STR_SPRITE_EMPTY:
	.asciiz	"   "
STR_SPRITE_ABSORBED:
	.asciiz	" A "
STR_SPRITE_REFLECTED:
	.asciiz	" R "

# !!! Reminder to not not add to or modify any of the above !!!
# !!! strings or any other part of the data segment.        !!!
# !!! If you add more strings you will likely break the     !!!
# !!! autotests and automarking.                            !!!
