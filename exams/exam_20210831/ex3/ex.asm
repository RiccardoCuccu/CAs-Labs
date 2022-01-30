; Exam of 31.08.2021

	.model small
	.stack

	M	EQU 5			; comumns
	N	EQU 8			; rows
	SIZE	EQU N*M			; matrix size
	HSIZE	EQU SIZE/2		; matrix size / 2
	
	.data

	SOURCE	DB 1, 2, 3, 4, 5
		DB 6, 7, 8, 9, 0
		DB 9, 8, 7, 6, 5
		DB 4, 3, 2, 1, 0
		DB 7, 7, 7, 7, 7
		DB 3, 5, 7, 9, 0
		DB 8, 7, 6, 5, 4
		DB 9, 9, 9, 3, 2

	DEST	DW DUP(0)

	.code
	.startup

	XOR	AX, AX			; set AX to 0
	XOR	BX, BX			; set BX to 0
	MOV	CX, HSIZE		; set counter to HSIZE
	XOR	DX, DX			; set DX to 0
	XOR	SI, SI			; set source index to 0

ADDS:
	MOV	DL, SOURCE[SI]		; take the elements that have even index
	ADD	AX, DX			; sum the elements that have even index
	ADD	SI, 2			; increment to reach the next element that have an even index
	LOOP	ADDS

	MOV	CX, HSIZE		; set counter to HSIZE
	MOV	SI, 1			; set source index to 1

SUBS:
	MOV	DL, SOURCE[SI]		; take the elements that have odd index	
	ADD	BX, DX			; sum the elements that have odd index
	ADD	SI, 2			; increment to reach the next element that have an odd index
	LOOP	SUBS

	SUB	AX, BX			; subtract the elements that have odd index
	MOV	DEST, AX		; store result

	.exit
	end
