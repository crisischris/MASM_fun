TITLE program_1     (program_1.asm)

; Author: Chris Nelson	
; OSU email address: nelsonc5@oregonstate.edu
; Course number/section: CS271-400
; Project Number: 1             
; Due Date: 1.19.2020
; Description: Write and test a MASM rogram to perform the following tasks:
; 1. Display your name and program title on the output screen.
; 2. Display instructions for the user.
; 3. Prompt the user to enter three numbers (A, B, C) in descending order.
; 4. Calculate and display the sum and differences: (A+B, A-B, A+C, A-C, B+C, B-C, A+B+C).
; 5. Display a terminating message.

INCLUDE Irvine32.inc
newLine textEQU <call	crlf>	;testing macros

.data
program_name	BYTE	"---------------------PROGRAM 1--------------------- by Chris Nelson", 0
instruction		BYTE	"Enter 3 numbers A > B > C and I'll caluclate the sums and differences", 0
number_1_out	BYTE	"FIRST NUMBER: ", 0
number_2_out	BYTE	"SECOND NUMBER: ", 0
number_3_out	BYTE	"THIRD NUMBER: ", 0
check			BYTE	"You have entered: ", 0
plus			BYTE	" + ", 0
minus			BYTE	" - ", 0
equals			BYTE	" = ", 0
goodbye			BYTE	"Alright, we're done here - goodbye", 0
results			BYTE	"***** RESULTS *****", 0
continue		BYTE	"Would you like to try again?  Enter 1 for yes", 0
error			BYTE	"Error: numbers entered in non-descending order - fix that ;)", 0
EC1				BYTE	"** EC: This program ensures user enters descending integers", 0
EC2				BYTE	"** EC: This program loops until user chooses to stop", 0



number_1	DWORD	?	;user input for number
number_2	DWORD	?	;user input for number
number_3	DWORD	?	;user input for number
userInput	DWORD	?	;user continue input

addition_1_2	DWORD	?	;calculation
addition_1_3	DWORD	?	;calculation
addition_2_3	DWORD	?	;calculation
addition_all	DWORD	?	;calculation

subtraction_2_1	DWORD	?	;calculation  should be read as subtract num1 - num2
subtraction_3_1	DWORD	?	;calculation
subtraction_3_2	DWORD	?	;calculation


.code
main PROC

;------------------------ this is intro (1. INTRODUCTION ) ------------------------
mov		edx, offset program_name
call	writeString
newLine
newLine
mov		edx, offset EC1
call	writeString
newLine
mov		edx, offset EC2
call	writeString
newLine
newLine

restart: 
mov		edx, offset instruction
call	writeString
newLine
newLine

;------------------------ this is I/O beginning logic (2. GET THE DATA) ------------------------
mov		edx, offset number_1_out
call	writeString
newLine
call	readInt
mov		number_1,eax
mov		edx, offset check
call	writeString
mov		eax, number_1
call	writeDec
newLine
newLine
mov		edx, offset number_2_out
call	writeString
newLine
call	readInt
mov		number_2,eax
mov		edx, offset check
call	writeString
mov		eax, number_2
call	writeDec
newLine
newLine
mov		edx, offset number_3_out
call	writeString
newLine
call	readInt
mov		number_3,eax
mov		edx, offset check
call	writeString
mov		eax, number_3
call	writeDec
newLine
newLine

;------------------------ conditional check to make sure descending ------------------------
mov		eax, number_1
cmp		eax, number_2
jl		noteq
je		noteq

	
mov		eax, number_2
cmp		eax, number_3
jl		noteq
je		noteq

;------------------------ this is the addition / subtraction logic (3. CALCULATE THE REQUIRED VALUES) ------------------------
mov		eax, number_1
add		eax, number_2
mov		addition_1_2, eax		;store num1+num2
mov		eax, number_1
add		eax, number_3
mov		addition_1_3, eax		;store num1+num3
mov		eax, number_2
add		eax, number_3
mov		addition_2_3, eax		;store num2+num3
mov		eax, addition_1_2
add		eax, number_3
mov		addition_all, eax		;store all addition

mov		eax, number_1
sub		eax, number_2
mov		subtraction_2_1, eax	;store num1-num2

mov		eax, number_1
sub		eax, number_3
mov		subtraction_3_1, eax	;store num1-num3

mov		eax, number_2
sub		eax, number_3
mov		subtraction_3_2, eax	;store num2-num3

;------------------------ this is the final output (4. DISPLAY THE RESULTS) ------------------------
mov		edx, offset results
call	writeString
newLine
newLine

;this block displays number_1 + number_2
mov		eax, number_1
call	writeDec
mov		edx, offset plus
call	writeString
mov		eax, number_2
call	writeDec
mov		edx, offset equals
call	writeString
mov		eax, addition_1_2
call	writeDec
newLine

;this block displays number_1 - number_2
mov		eax, number_1
call	writeDec
mov		edx, offset minus
call	writeString
mov		eax, number_2
call	writeDec
mov		edx, offset equals
call	writeString
mov		eax, subtraction_2_1
call	writeDec
newLine

;this block displays number_1 + number_3
mov		eax, number_1
call	writeDec
mov		edx, offset plus
call	writeString
mov		eax, number_3
call	writeDec
mov		edx, offset equals
call	writeString
mov		eax, addition_1_3
call	writeDec
newLine

;this block displays number_1 - number_3
mov		eax, number_1
call	writeDec
mov		edx, offset minus
call	writeString
mov		eax, number_3
call	writeDec
mov		edx, offset equals
call	writeString
mov		eax, subtraction_3_1
call	writeDec
newLine

;this block displays number_2 + number_3
mov		eax, number_2
call	writeDec
mov		edx, offset plus
call	writeString
mov		eax, number_3
call	writeDec
mov		edx, offset equals
call	writeString
mov		eax, addition_2_3
call	writeDec
newLine

;this block displays number_2 - number_3
mov		eax, number_2
call	writeDec
mov		edx, offset minus
call	writeString
mov		eax, number_3
call	writeDec
mov		edx, offset equals
call	writeString
mov		eax, subtraction_3_2
call	writeDec
newLine

;this block displays the sum of all numbers
mov		eax, number_1
call	writeDec
mov		edx, offset plus
call	writeString
mov		eax, number_2
call	writeDec
mov		edx, offset plus
call	writeString
mov		eax, number_3
call	writeDec
mov		edx, offset equals
call	writeString
mov		eax, addition_all
call	writeDec
newLine
newLine

;------------------------ JUMP TO BEGINNING ------------------------

mov		edx, offset continue
call	writeString
newLine
newLine
call	readInt
mov		userInput, eax
dec		userInput
cmp		userInput, 0
jz		restart

;------------------------ GOODBYE (5. SAY GOODBYE) ------------------------
mov		edx, offset goodbye
call	writeString
newLine
exit							; exit to operating system

;------------------------ jump if less than flag ------------------------
noteq:
mov		edx, offset error
call	writeString
newLine
newLine
jmp		restart

main ENDP

END main