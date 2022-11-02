;=====================================================================
;
;Name: Tobias Wondwossen
;E-mail: twond799@mtroyal.ca
;Course: COMP 2655 - 001
;Assignment: 3, part 2
;Due Date: Ocotber 31, 2022 - 11:59pm
;File name: FIRST.S
;Instructor: Pual Pospisil
;
;=====================================================================
;Program Purpose:
;=====================================================================
; 
;For y = (4x^2 + (23x + 136) / 3) % 1000, reads a 3-digit decimal 
;value for x and computes corresponding y value, writes 3-digit 
;result to screen.
;
;=====================================================================
;Program Details:
;=====================================================================
;
;Input:	3 characters from keyboard (converted 3-digit decimal value
;       before use)
;
;Output: 3 characters on a new line (converted 3-digit
;	     decimal value before use)
;
;Assumption(s): i) User input must be exactly 3 characters in the 
;		   0-9 range
;	       ii) Designed for only unsigned integers
;
;Note(s): - When computing the result for 4x^2, repeated addition is
;	    used to accompish the multiplcation since the x value may 
;	    be a long word.
;
;=====================================================================
;Program Status:
;=====================================================================  
;
;Program correctly reads input for x from keyboard and correctly 
;outputs and computes y for, y = (4x^2 + ((23x + 136) / 3)) % 1000
;
;
;Test Cases (Black Box): 
;---------------------------------------------------------------------
;       1) Test: x = 000 
;---------------------------------------------------------------------         
;	   Reason - input: Lowest input value possible
;                 - output: leading zero
;	   Expected: 045
;	   Ouput:    045
;---------------------------------------------------------------------         
;       2) Test: x = 291
;---------------------------------------------------------------------         
;	   Reason - input: no digits = 0
;                 - output: Lowest output possible / all zero
;          Expected: 000
;          Output:   000
;---------------------------------------------------------------------          
;       3) Test: x = 999
;---------------------------------------------------------------------
;          Reason - input: Highest input value possible
;  		  - output: digit 2 is zero	        
;	   Expected: 708
;	   Ouput:    708
;---------------------------------------------------------------------
;       4) Test: x = 476
;---------------------------------------------------------------------
;          Reason: - input: no digits = zero
;                  - output: highest output value possible
;          Expected: 998
;          Output:   998
;---------------------------------------------------------------------
;       5) Test: x = 255
;--------------------------------------------------------------------- 
;          Reason - input: highest value whose size is <= byte
;                 - output: 2 trailing zero's
;	   Excpected: 100 
;	   Output:    100
;---------------------------------------------------------------------
;       6) Test: x = 256
;--------------------------------------------------------------------- 
;          Reason - input: first value whose size is > byte
;		  - output: no digits = zero    	 
;	   Expected: 152
;	   Output:   152 
;---------------------------------------------------------------------
;	 *** Not special ***
;---------------------------------------------------------------------
;       7) Test: x = 005
;--------------------------------------------------------------------- 
;          Reason - input: 2 leading zero's
;                 - output: no digits = zero 
;	   Expected: 183 
;          Output:   183
;---------------------------------------------------------------------          
;       8) Test: x = 099
;--------------------------------------------------------------------- 
;          Reason - intput: 1 leading zero 
;                 - output: 2 leading zero's
;          Expected: 008
;          Output:   008
;---------------------------------------------------------------------	
;	9) Test: x = 040
;--------------------------------------------------------------------- 
;          Reason - input: digit 1 and 3 are zero
;	          - output: 1 trailing zero
;	   Expected: 140
;          Output:   140
;---------------------------------------------------------------------	
;      10) Test: x = 500
;--------------------------------------------------------------------- 
;          Reason - input: 2 trailing zero's
;                 - output: no digits = zero
;	   Expected: 878
;          Output:   878
;---------------------------------------------------------------------	
;      11) Test: x = 304
;--------------------------------------------------------------------- 
;          Reason - input: digit 2 is zero
;	          - output: digit 1 and 3 are zero
;	   Expected: 040
;          Output:   040 
;---------------------------------------------------------------------
;      12) Test: x = 440
;---------------------------------------------------------------------
;	   Reason - input: 1 trailing zero
;                 - output: no digits = zero  			
;          Excpected: 818  
;          Output:    818
;  
;=====================================================================
;Register Table:
;=====================================================================
;
;d0 - Input:  holds the character read from the keyboard
;     Output: holds the character being written to screen
;
;d1 - holds first character from keyboard
;   - holds first digit of result
;
;d2 - holds second character from keyboard
;   - holds second digit of result
;
;d3 - holds second character from keyboard
;   - holds second digit of result
;
;d4 - holds decimal value for x in equation
;
;d5 - holds final decimal result of equation
;
;d6 - holds digit decimal result of sub-equation: 23x + 136 / 3 
;
;---------------------------------------------------------------------
CR:		equ	13		;Carriage Return
LF:		equ	10		;Line Feed

start:		jsr	read_char	;read input
		move.l	d0,d1           ;save character
		jsr	read_char
		move.l	d0,d2
		jsr	read_char
		move.l	d0,d3
		
		move.b	#CR,d0		;advance to new line
		jsr	write_char
		move.b	#LF,d0		
		jsr	write_char
			
		and.l	#$FF,d1		;convert char to decimal
		and.l	#$FF,d2
		and.l	#$FF,d3	
		sub.b	#'0',d1		
		sub.b	#'0',d2
		sub.b	#'0',d3
		
		move.l	d1,d4		;build 3 digit integer via horners rule
		mulu.w	#10,d4
		add.w	d2,d4
		mulu.w	#10,d4
		add.w	d3,d4	
		
		move.l	d4,d5		;compute sub-equation A: 4x^2	     
		mulu.w	d5,d5
		add.l 	d5,d5
		add.l	d5,d5			
				
		move.l	#23,d6		;compute sub equation B: 23x + 136
		mulu.w	d4,d6		
		add.w	#136,d6		

		divu.w	#3,d6		;compute sub equation C: B/3
		
		and.l	#$FFFF,d6	;clear to avoid addition with 
                                        ;unwanted remainder

		add.l	d6,d5		;compute sub equation D: C + A	
		
		divu.w	#1000,d5	;compute final equation D % 1000
		swap	d5		;get remainder
		
		move.w	d5,d3		;get 3rd digit of final value	
		divu.w	#10,d3
		swap	d3		

		move.w	d5,d2		;get 2nd digit of final value
		divu.w	#10,d2
		and.l	#$FFFF,d2
		divu.w	#10,d2
		swap	d2		
		
		move.w	d5,d1		;get first digit final value
		divu.w	#100,d1
		and.l	#$FFFF,d1
		divu.w	#10,d1
		swap	d1	

		add.b	#'0',d3		;convert decimal to char	
		add.b	#'0',d2		
		add.b	#'0',d1
		
		move.b	d1,d0		;write characters (Final value)
		jsr	write_char
		move.b	d2,d0
		jsr	write_char	
		move.b	d3,d0
		jsr	write_char
		
		move.b  #CR,d0		;advance to new line
		jsr 	write_char
		move.b  #LF,d0
		jsr     write_char
		
		jsr	exit

;----- SUBROUTINE: read_char -----
;
; PURPOSE: waits for and reads a single keystroke from the keyboard.
;
; CALLER OUTPUT: returns the ASCII value of the key in the low byte
;                of D0.
;
; IMPORTANT: NOTE THAT THE HIGHER_ORDER BYTES OF D0 ARE UNDEFINED.
;            DON'T ASSUME THEY ARE ZEROED OUT!
;
; E.G. CALL:	jsr	read_char
;		... now use D0.b ...

read_char:	movem.l	d1-d2/a0-a2,-(sp)
		move.w	#1,-(sp)
		trap	#1
		addq.l	#2,sp	
		movem.l	(sp)+,d1-d2/a0-a2
		rts


;----- SUBROUTINE: write_char -----
;
; PURPOSE: writes a single character to the screen.
;
; CALLER INPUT: takes the ASCII value of the character in the low byte
;               of D0.
;
; E.G. CALL:	move.b	#'a',d0
;		jsr	write_char

write_char:	movem.l	d0-d2/a0-a2,-(sp)
		and.w	#$00FF,d0
		move.w	d0,-(sp)
		move.w	#2,-(sp)
		trap	#1
		addq.l	#4,sp
		movem.l	(sp)+,d0-d2/a0-a2
		rts


;----- SUBROUTINE: exit -----
;
; PURPOSE: terminates the program.  This routine never returns.

exit:		clr.w	-(sp)
		trap	#1
