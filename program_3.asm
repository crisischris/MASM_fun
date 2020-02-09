TITLE program_3      (program_3.asm)

; Author: Chris Nelson	
; OSU email address: nelsonc5@oregonstate.edu
; Course number/section: CS271-400
; Project Number: 3           
; Due Date: 2.09.2020
; Description:Write a program that performs the following task:
;1) Display the program title and programmer’s name.
;2) Get the user’s name, and greet the user.
;3) Display instructions for the user.
;4) Repeatedly prompt the user to enter a number.
;	a) Validate the user input to be in [-88, -55] or [-40, -1] (inclusive).
;	b) Count and accumulate the valid user numbers until a non-negative number is entered. Detect this using the SIGN flag. (The non-negative number and any numbers not in the specified ranges are discarded.)
;	c) Notify the user of any invalid numbers (negative, but not in the ranges specified)
;5) Calculate the (rounded integer) average of the valid numbers.
;6) Display:
;	a) the number of validated numbers entered (Note: if no negative numbers were entered, display a special message and skip to f.)
;	b) the sum of negative numbers entered
;	c) the maximum (closest to 0) valid user value entered
;	d) the minimum (farthest from 0) valid user value entered
;	e) the average, rounded to the nearest integer (e.g. -20.5 rounds to -20, -20.51 rounds to -21)
;	f) a parting message (with the user’s name)



INCLUDE Irvine32.inc
newLine textEQU <call	crlf>	

.data
program_name	BYTE	"--------------------- PROGRAM 3 --------------------- by Chris Nelson", 0
greeting1		BYTE	"What is your name?", 0
userName		BYTE	30 DUP(?)

response1		BYTE	"Hello ", 0
response2		BYTE	", lets do some signed integer division", 0
instructions	BYTE	"Enter an integer x such that -89 < x < -54 OR -41 < x < 0", 0
restartString	BYTE	"Enter 1 to try again or any other key to exit", 0
sAmountNums1	BYTE	"Amount of valid integers entered:................", 0
sMaxNum			BYTE	"Maximum in-range integer entered:...............", 0
sMinNum			BYTE	"Minimum in-range integer entered:...............", 0
sSum			BYTE	"The sum of all valid integers:..................", 0
sAvrgNum		BYTE	"Rounded average of all in-range integers:.......", 0
partingSpecial	BYTE	"Hey, you didn't even enter a valid integer!  What are we even doing here?", 0
parting			BYTE	"Thus concludes the signed division calculator, thanks for coming", 0
space			BYTE	".      ", 0


error1			BYTE	"Integer out of range.  Enter an integer x such that -89 < x < -54 OR -41 < x < 0", 0

;Constants
MIN_NUMBER_1	equ -89
MAX_NUMBER_1	equ -54
MIN_NUMBER_2	equ -41
MAX_NUMBER_2	equ 0
thousand		equ	1000


average			DWORD	?
curMax			SDWORD	1
curMin			SDWORD	1
userInteger		SDWORD	?						;user entered integer.  To be validated
userIntegerSums	SDWORD	?	
remainder		DWORD	?	

EC1				BYTE	"** EC: This program numbers the user input line", 0

.code
main PROC
;------------------------ (1. INTRODUCTION AND GREETING ) -------------------------------
fullRestart:	;Whole program restart loop
mov				userIntegerSums, 0
mov				edx, OFFSET program_name
call			WriteString
newLine
newLine
mov				edx, OFFSET EC1
call			WriteString
newLine
newLine
mov				edx, OFFSET greeting1
call			WriteString
newLine
newLine
mov				edx, OFFSET userName
mov				ecx, 30
call			ReadString


;------------------------ RESPONSE OUTPUT ------------------------
mov				edx, OFFSET response1
call			WriteString
mov				edx, OFFSET	userName
call			WriteString
mov				edx, OFFSET	response2
call			WriteString
newLine
newLine
mov				ecx, 0							;set the counter to 0

;------------------------ (2. Repeatedly prompt the user to enter a number )-------------------------------
mov				edx, OFFSET instructions
call			WriteString
newLine
newLine
restart:	

;------------------------ (3. GET AND VALIDATE USER INPUT) ------------------------------
mov				eax, ecx
call			writeDec
mov				edx, OFFSET space
call			writeString
call			ReadInt
JNS				Finish							;non-negative entered detected by SIGN flag, jump to finish
mov				userInteger,eax
cmp				eax, MAX_NUMBER_1
JL				Less54
cmp				eax, MIN_NUMBER_2
JG				greater41
mov				edx, OFFSET error1
call			WriteString
newLine
JMP				restart

Less54:
cmp				eax, MIN_NUMBER_1
JG				mainLogic						;this number is within range
mov				edx, OFFSET error1
call			WriteString
newLine
JMP				restart

greater41:
cmp				eax, MAX_NUMBER_2
JL				mainLogic						;this number is within range
mov				edx, OFFSET error1
call			WriteString
newLine
JMP				restart


mainLogic:										;we have validated user integer
inc				ecx								;increment our counter
mov				eax, curMin
cmp				eax, 1							;if eq, we have found our first valid number, need to set min/max
je				setMinMax
mov				eax, userInteger
cmp				eax, curMin						;test against curMin
jl				setMin
mov				eax, userInteger
cmp				eax, curMax
ja				setMax


mainLogicReturn:
mov				eax, userIntegerSums
add				eax, userInteger
mov				userIntegerSums, eax
JMP restart

setMinMax:
mov				eax, userInteger
mov				curMin, eax
mov				curMax, eax
JMP				mainLogicReturn

setMin:
mov				eax, userInteger
mov				curMin, eax
JMP				mainLogicReturn

setMax:
mov				eax, userInteger
mov				curMax, eax
JMP				mainLogicReturn

Finish:
cmp				curMin, 1						;have we entered a valid integer?
je				specialOut
mov				eax, userIntegerSums
CDQ
IDIV			ecx								;divide our sum by count
mov				average, eax
mov				remainder, edx
mov				eax, remainder

cmp				remainder, 0					;remainder is good to go
JE				skip
mov				eax, remainder 		
mov				ebx, 1000
MUL				ebx
mov				remainder, eax
CDQ
IDIV			ecx
mov				remainder, eax
cmp				remainder, -501
JLE				addOne							;need to round up
jmp				skip							;skip add one

addOne:
mov				eax, average
sub				eax, 1
mov				average, eax
jmp				skip

specialOut:										;Handles the event of NO valid integers entered
mov				edx, OFFSET partingSpecial
call			WriteString
newLine
jmp				partingFinish

;------------------------ FINAL OUTPUT ------------------------
skip:
newLine
newLine
mov				edx, OFFSET sAmountNums1
call			WriteString
mov				eax, ecx
call			WriteDec
newLine

mov				edx, OFFSET sMaxNum
call			WriteString
mov				eax, curMax
call			WriteInt
newLine

mov				edx, OFFSET sMinNum
call			WriteString
mov				eax, curMin
call			WriteInt
newLine

mov				edx, OFFSET sSum
call			WriteString
mov				eax, userIntegerSums
call			WriteInt
newLine

mov				edx, OFFSET sAvrgNum
call			WriteString
mov				eax, average
call			WriteInt
newLine
newLine

partingFinish:
mov				edx, OFFSET parting
call			WriteString
newLine

;------------------------ PROGRAM RESTART BLOCK ------------------------
mov				edx, OFFSET restartString
call			WriteString
newLine
newLine
call			ReadInt
cmp				eax, 1
JE				fullRestart

exit											; exit to operating system
main ENDP
END main