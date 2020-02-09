TITLE program_3      (program_3.asm)

; Author: Chris Nelson	
; OSU email address: nelsonc5@oregonstate.edu
; Course number/section: CS271-400
; Project Number: 4           
; Due Date: 2.16.2020
; Description:Write a program that performs the following task:
;1) The programmer’s name must appear in the output.
;2) The counting loop (1 to n) must be implemented using the MASM loop instruction.
;3) The main procedure must consist (mostly) of procedure calls. It should be a readable 
;	“list” of what the program will do.
;4) Each procedure will implement a section of the program logic, i.e., each procedure will 
;	specify how the logic of its section is implemented. The program must be modularized into
;	at least the following procedures and sub-procedures :
;		a) introduction
;		b) getUserData
;			1) validate
;		c) showComposites
;			1) isComposite
;		d) farewell

;5) The upper limit should be defined and used as a constant.
;6) Data validation is required. If the user enters a number outside the range [1 .. 400] an
;	error message should be displayed and the user should be prompted to re-enter the number of composites.
;7) The usual requirements regarding documentation, readability, user-friendliness, etc., apply.
;8) Submit your text code file (.asm) to Canvas by the due date.


INCLUDE Irvine32.inc
newLine textEQU <call	crlf>	

.data
program_name	BYTE	"--------------------- PROGRAM 4 --------------------- by Chris Nelson", 0
instructions	BYTE	"Enter an integer x such that 1 <= x <= 400 to coount composite numbers up to x", 0
restartString	BYTE	"Enter 1 to try again or any other key to exit", 0

partingSpecial	BYTE	"Hey, you didn't even enter a valid integer!  What are we even doing here?", 0
parting			BYTE	"You did it - great job!  ...Well actually I did it, but great job anyway!", 0
space			BYTE	"   ", 0
space1			BYTE	" ", 0
space2			BYTE	"  ", 0
error1			BYTE	"Integer out of range.  Enter an integer x such that 1 <= x <= 400", 0

MIN_NUMBER		equ 1
MAX_NUMBER		equ 400

userInteger		DWORD	?						;user entered integer.  To be validated
currNum			DWORD	?						;temp number to be used in calculations
compFlag		DWORD	1						;temp number to be used to determine composite


EC1				BYTE	"** EC: This program aligns the output columns", 0
EC2				BYTE	"** EC: This program efficiently checks composites using only 5 primes", 0

.code
main PROC
fullRestart:									;Whole program restart loop
call	greeting
call	getUserInput	
call	showComposites
call	restartCheck

cmp				esi, 1							;jump to beginning if user chooses
JE				fullRestart
call	partingMessage
exit
main	ENDP


;------------------------ (PARTING) -------------------------------
;Description:  This procedure prints a parting message to the console
;pre-conditions: The user has succesfully made it to the end of the program
;post-conditions: None
;registers changed: edx
partingMessage PROC
mov				edx, OFFSET parting
call			WriteString
newLine
ret
partingMessage ENDP

;------------------------ (GREETINGS) -------------------------------
;Description: This procedure prints a greeting to the console
;pre-conditions: None
;post-conditions: None
;registers changed: edx
greeting PROC
mov		esi, 0								;this is for our restart
mov				edx, OFFSET program_name
call			WriteString
newLine
newLine
mov				edx, OFFSET EC1
call			WriteString
newLine
mov				edx, OFFSET EC2
call			WriteString
newLine
newLine
ret
greeting ENDP

;------------------------ (SHOW COMPOSITE OUTPUT) -------------------------------
;Description: This procedure calls "isComposite" and prints numbers to the console
;pre-conditions: User has entered a valid integer to check for composites
;post-conditions: all composites from 1-X have been printed to the console
;registers changed: ecx, esi, eax, edx, 
showComposites PROC
mov		ecx, userInteger					;move the user integer into the loop counter
inc		userInteger							;for calculations to start at 1
mainLoop:
call	isComposite
cmp		compFlag, 0							;did we flag this as composite?
jne		skipRound
mov		compFlag, 1							;reset our composite flag

cmp		esi, 10
je		addNewLine
back:
mov		eax, currNum
call	WriteDec

cmp		currNum, 10
jl		extraSpace2

cmp		currNum, 100
jl		extraSpace1


spaceAligned:
mov		edx, OFFSET space
call	WriteString
inc		esi
skipRound:
loop	mainLoop
ret

extraSpace1:
mov		edx, OFFSET space1
call	WriteString
jmp		spaceAligned

extraSpace2:
mov		edx, OFFSET space2
call	WriteString
jmp		spaceAligned

addNewLine:
newLine
mov		esi, 0
jmp		back

showComposites ENDP

;------------------------ (DETERMINE IF COMPOSITE) -------------------------------
;Description:  Determines if the current number is a composite number
;pre-conditions: Valid user integer entered
;post-conditions: Flag compositeTrue change or not
;registers changed: eax, edx.  Note: ecx is preserved using the stack

isComposite PROC
push	ecx									;save our loop counter
mov		eax, userInteger
sub		eax, ecx
mov		currNum, eax

;------------------------ (COMPOSITE NUMBER VALIDATION HERE) -------------------------------
mov		eax, currNum						;test against 2,3,5,7,11 and 13
cmp		eax, 2
je		next1								;we need to make sure we aren't testing against ourselves
cmp		eax, 2
jl		next1
mov		ecx, 2
xor		edx, edx							;set edx to 0
div		ecx			
cmp		edx, 0
je		compositeTrue

next1:
mov		eax, currNum						
cmp		eax, 3
je		next2								;we need to make sure we aren't testing against ourselves
cmp		eax, 3
jl		next2
mov		ecx, 3
xor		edx, edx							;set edx to 0
div		ecx			
cmp		edx, 0
je		compositeTrue

next2:
mov		eax, currNum						
cmp		eax, 5
je		next3								;we need to make sure we aren't testing against ourselves
cmp		eax, 5
jl		next3
mov		ecx, 5
xor		edx, edx							;set edx to 0
div		ecx			
cmp		edx, 0
je		compositeTrue

next3:
mov		eax, currNum						
cmp		eax, 7
je		next4								;we need to make sure we aren't testing against ourselves
cmp		eax, 7
jl		next4
mov		ecx, 7
xor		edx, edx							;set edx to 0
div		ecx		
cmp		edx, 0
je		compositeTrue

next4:
mov		eax, currNum						
cmp		eax, 11
je		next5								;we need to make sure we aren't testing against ourselves
cmp		eax, 11
jl		next5
mov		ecx, 11
xor		edx, edx							;set edx to 0
div		ecx		
cmp		edx, 0
je		compositeTrue

next5:
mov		eax, currNum						
cmp		eax, 13
je		next6								;we need to make sure we aren't testing against ourselves
cmp		eax, 13								
jl		next6
mov		ecx, 13
xor		edx, edx							;set edx to 0
div		ecx			
cmp		edx, 0
je		compositeTrue

next6:
pop		ecx
ret

compositeTrue:
mov		compFlag, 0
jmp		next6								;skip the rest of the comparisions

isComposite ENDP

;------------------------ (GET USER INPUT PROCEDURE) -------------------------------
;Description: Get user input using getInt and call "validate" procedure
;pre-conditions: None
;post-conditions: User input is validated or loop restarted until valid int entered
;registers changed: edx, eax, ebx
getUserInput PROC
mov				edx, OFFSET instructions
call			WriteString
newLine
newLine
restart:
call	readDec
mov		userInteger, eax
call	validate
cmp		ebx, 0
jne		restart							;not valid, restart
newLine
ret
getUserInput ENDP

;------------------------ (VALIDATION PROCEDURE) -------------------------------
;Description: Validate user entered integer against allowed integers
;pre-conditions: User has entered integer
;post-conditions: if valid, integer stored. If not - loop repeated
;registers changed:ebx, edx,
validate PROC
mov		ebx, 1					;flag to notify if valid or not, default not valid
cmp		userInteger, MIN_NUMBER
jl		nope
cmp		userInteger, MAX_NUMBER
jg		nope
jmp		yup						;this is valid, jump over not valid

nope:
mov		edx, OFFSET error1
call	WriteString
newLine
newLine
jmp		skip

yup:
mov		ebx, 0					;integer is valid
skip:
ret
validate ENDP

;------------------------ PROGRAM RESTART BLOCK ------------------------
;Description: Logic for restarting the program if user chooses
;pre-conditions: All procedures called and user is at end of program
;post-conditions: User restarts main logic loop OR user exits program
;registers changed: edx, eax, esi
restartCheck PROC
newLine
newLine
mov				edx, OFFSET restartString
call			WriteString
newLine
newLine
call			ReadInt
cmp				eax, 1
JE				equal
mov				esi, 0
jmp				skip1
equal:
mov		esi, 1
skip1:
ret
restartCheck ENDP
END main