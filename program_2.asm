TITLE program_2      (program_2.asm)

; Author: Chris Nelson	
; OSU email address: nelsonc5@oregonstate.edu
; Course number/section: CS271-400
; Project Number: 2             
; Due Date: 1.26.2020
; Description:Write a program to calculate Fibonacci numbers:
; 1. Display the program title and programmer’s name. Then get the user’s name, and greet the user
; 2. Prompt the user to enter the number of Fibonacci terms to be displayed. Advise the user to enter-
;    an integer in the range [1 .. 46]
; 3. Get and validate the user input (n)
; 4. Calculate and display all of the Fibonacci numbers up to and including the nth term. The results 
;    should be displayed 5 terms per line with at least 5 spaces between terms.
; 5. Display a parting message that includes the user’s name, and terminate the program.

INCLUDE Irvine32.inc
newLine textEQU <call	crlf>	

.data
program_name	BYTE	"---------------------PROGRAM 2--------------------- by Chris Nelson", 0
greeting1		BYTE	"What is your name?", 0
response1		BYTE	"Hello ", 0
response2		BYTE	", lets calculate some numbers!", 0
instructions	BYTE	"Enter the number of Fibonacci terms to be displayed.  Number should be 0 < x < 47", 0
parting1		BYTE	"Thank you ", 0
parting2		BYTE	" for testing out the program.  Come back anytime.", 0
restartString	BYTE	"Enter 1 to try again or any other key to exit", 0
space			BYTE	"               ", 0
space1			BYTE	" ", 0
error1			BYTE	"your name is too large!", 0
error2			BYTE	"your Fib integer is too large.  Remember, 0 < x < 47", 0
error3			BYTE	"your Fib integer is too small.  Remember, 0 < x < 47", 0

MAX	equ 30
MAX_NUMBER equ 46

userInteger		DWORD	?	;user entered integer.  To be validated
inputSizeValid	DWORD	?	;this checks if the input size is valid
userName		DWORD	MAX+1 DUP(?)	
fibn1			DWORD	0
fibn2			DWORD	0
countHold		DWORD	0
countHoldMain	DWORD	0

EC1				BYTE	"** EC: This program output is in aligned colunms", 0

.code
main PROC
;------------------------ (1. INTRODUCTION AND GREETING ) -------------------------------
mov			edx, OFFSET program_name
call		WriteString
newLine
newLine
mov			edx, OFFSET EC1
call		WriteString
newLine
newLine
mov			edx, OFFSET greeting1
call		WriteString
newLine
newLine
mov			edx, OFFSET userName
mov			ecx, MAX
call		ReadString
mov			inputSizeValid, eax
mov			eax, MAX

;------------------------ RESPONSE OUTPUT ------------------------
mov			edx, OFFSET response1
call		WriteString
mov			edx, OFFSET	userName
call		WriteString
mov			edx, OFFSET	response2
call		WriteString
newLine
newLine

;------------------------ (2. PROMPT USER FOR FIB NUMBER )-------------------------------
restart:									;Whole program restart loop
validNumber:								;Input validation failed, start over

mov			edx, OFFSET instructions
call		WriteString
newLine
newLine

;------------------------ (3. GET AND VALIDATE USER INPUT) ------------------------------
call		ReadInt
mov			userInteger,eax
cmp			eax, MAX_NUMBER
JNLE		badInputGreater
cmp			eax, 1
JL			badInputLess

;------------------------ (4. CALCULATE AND DISPLAY FIB NUMBERS) ------------------------
newLine
newLine
mov			eax, userInteger
sub			eax, 2							;This handles the case of user entering 1 & 2 using flags instead of immediates
JS			number1							;this will jump to the main logic loop to implement the corner case of 1
JZ			number2							;this handles the case of user entering 2
mov			fibn1, 1						;We need to start somewhere...
mov			fibn2, 1						;We need to start somewhere...
mov			eax, 1							;If user interger > 2, print 1, 1 and start the loop
call		WriteDec
mov			edx, OFFSET space
call		WriteString
call		WriteDec
mov			edx, OFFSET space
call		WriteString
mov			ebp, 2							;this is our simple modulo 5 counter, compensate for fib(1) and fib(2)
mov			ecx, userInteger				;loop counter, compensate for fib(1) and fib(2)
sub			ecx, 2

top:
cmp			ebp, 5
JE mod5										;if our modulo counter is mod 5, go into mod5

returnM:
mov			eax, fibn1
add			eax, fibn2
call		WriteDec
jmp			spaceNeeded

return:
call		WriteString
mov			edi,fibn2						;copy our values correctly
mov			fibn1, edi
mov			fibn2,eax
inc ebp
loop top
newLine
newLine
jmp skip									;jump past the 1 corner case

;------------------------ CORNER CASE OF USERNUM = 1 OR 2 ----------------------------------
number1:
mov			eax,1
call		WriteDec
newLine
jmp skip									;skip past number2

number2:
mov			eax,1
call		WriteDec
mov			edx, OFFSET space
call		WriteString
call		WriteDec
newLine
skip:

;------------------------ (5. DISPLAY PARTING MESSAGE) ----------------------------------
mov			edx, OFFSET parting1
call		WriteString
mov			edx, OFFSET userName
call		WriteString
mov			edx, OFFSET parting2
call		WriteString
newLine
newLine
mov			edx, OFFSET restartString
call		WriteString
newLine
newLine
call		ReadInt
cmp			eax, 1
JE			restart
jmp			goodInput

;------------------------ Error handling and jump block ------------------------
spaceNeeded:								;This is all formating depending on size of fib(n)				
cmp			eax, 9
mov			countHold, 14
JBE			spaces

cmp			eax, 99
mov			countHold, 13
JBE			spaces

cmp			eax, 999
mov			countHold, 12
JBE			spaces

cmp			eax, 9999
mov			countHold, 11
JBE			spaces

cmp			eax, 99999
mov			countHold, 10
JBE			spaces

cmp			eax, 999999
mov			countHold, 9
JBE			spaces

cmp			eax, 9999999
mov			countHold, 8
JBE			spaces

cmp			eax, 99999999
mov			countHold, 7
JBE			spaces

cmp			eax, 999999999
mov			countHold, 6
JBE			spaces

cmp			eax, 2000000000
mov			countHold, 5
JBE			spaces

spaces:
mov			countHoldMain, ecx				;save our ecx counter
mov			ecx, countHold
topTwo:
mov			edx, OFFSET space1
call		WriteString
loop		topTwo
mov			ecx, countHoldMain				;return ecx to keep current loop counter
jmp			return

;------------------------ modulo 5 printing ------------------------
mod5:
newLine
mov			ebp, 0							;reset mod counter
jmp returnM

badInputGreater: 
mov			edx, OFFSET error2
call		WriteString
newLine
jmp validNumber

;------------------------ input validation ------------------------
badInputLess: 
mov			edx, OFFSET error3
call		WriteString
newLine
jmp validNumber

goodInput:						; if all good input, jump past error handling
exit							; exit to operating system
main ENDP
END main