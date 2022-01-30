; Exam of 23.06.2021

	.model small
	.stack

	LEN	EQU 5
	SIZE	EQU LEN*LEN		; matrix size
	
	.data

	SOURCE	DB 1, 2, 3, 4, 5
		DB 6, 7, 8, 9, 0
		DB 9, 8, 7, 6, 5
		DB 4, 3, 2, 1, 0
		DB 7, 7, 7, 7, 7

	DEST	DW DUP(0)

	.code
	.startup

	MOV	AX, 0			; set AX to 0
	MOV	BX, 0			; set BX to 0
	MOV	CX, LEN			; set counter to LEN
	MOV	DX, 0			; set DX to 0
	MOV	SI, 0			; set source index to 0

SUMS:
	INC	SI			; increment source index
	MOV	DL, SOURCE[SI]		; extract a value from the SOURCE matrix
	ADD	AX, DX			; add the values that are not on the diagonal 
	LOOP	SUMS

	INC	SI			; increment source index again to avoid values along the diagonal
	CMP	SI, SIZE-1		; check if it is the last value
	JE	SUBS
	MOV	CX, LEN			; set counter to LEN again
	JMP	SUMS

SUBS:
	MOV	DL, SOURCE[SI]		; extract the value from the SOURCE matrix
	ADD	BX, DX			; add the values that are on the diagonal
	CMP	SI, 0			; check if it is the first value
	JE	TOTAL
	SUB	SI, LEN+1		; go to the next element of the diagonal
	JMP	SUBS

TOTAL:
	SUB	AX, BX			; subtract the elements of the diagonal
	MOV	DEST, AX		; store result

	.exit
	end
