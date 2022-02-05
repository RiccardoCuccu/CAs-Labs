; Exam of 04.02.2022

	.model small
	.stack

	LEN	EQU 4
	SIZE	EQU LEN*LEN		; matrix size
	
	.data

	SOURCE 	DW 10,   20,    100,  10000
		DW 0,    7000,  1,    2
		DW 9000, 12345, 999,  30000
		DW 200,  210,   7,    65000
		
;	SOURCE 	DW 255,  255,   255,  255
;		DW 255,  255,   255,  255
;		DW 255,  255,   255,  255
;		DW 255,  255,   255,  255

	MAPP	DB SIZE DUP(0)

	CROSS	DW 0

	.code
	.startup

	XOR	SI, SI			; set source index to 0
	XOR	DI, DI			; set destination index to 0
	XOR	BX, BX			; set BX to 0
	MOV	CX, SIZE		; set counter to SIZE

CHECK:
	MOV	AX, SOURCE[SI]		; extract a value from the SOURCE matrix
	CMP	AH, 0			; check if the 8 MSBs are equal to zero
	JNE	NEXT			; if they are all zeros it means that the value can be represented in 8 bits

	MOV	MAPP[DI], 1		; enter the value 1 in the MAPP matrix
	ADD	BX, SOURCE[SI]		; sum with previous valid values

NEXT:	
	ADD	SI, 2			; increment source index (word)
	ADD	DI, 1			; increment destination index (byte)
	LOOP	CHECK			; loop for 16 times

	MOV	CROSS, BX		; store the result in CROSS

	.exit
	end
