;Write a program in 8086 assembly for multiplying two matrices whose elements are signed numbers expressed with one byte.

        .MODEL small
        .STACK

LF      EQU     10              	; line feed
CR      EQU     13              	; carriage return
POINT   EQU     '.'	

;N       EQU     3              	 ; rows MAT_A
;M       EQU     4              	 ; columns MAT_A and rows MAT_B
;P       EQU     2              	 ; columns MAT_B
N       EQU     4               	; rows MAT_A
M       EQU     7               	; columns MAT_A and rows MAT_B
P       EQU     5               	; columns MAT_B
NM      EQU     N*M
MP      EQU     M*P
NP      EQU     N*P

        .DATA
                
MSGS    DB      "Programma avviato", CR, LF, "$"
MSGE    DB      "Programma terminato", CR, LF, "$"
MSG1    DB      CR, LF, "$"
MSG2    DB      "Calcolo della matrice C in corso", "$"
MSGA    DB      "Matrice A:", CR, LF, "$"
MSGB    DB      "Matrice B:", CR, LF, "$"
MSGC    DB      "Matrice C:", CR, LF, "$"
    
;MAT_A   DB       4,  -3,  5,   1     	; matrix A
;        DB       3,  -5,  0,  11
;        DB      -5,  12,  4,  -5
                
;MAT_B   DB      -2,   3              	; matrix B
;        DB       5,  -1  
;        DB       4,   3
;        DB       9,  -7

MAT_A   DB          3, 14, -15,    9, 26, -53,  5     ; matrix A
        DB         89, 79,   3,   23, 84,  -6, 26
        DB         43, -3,  83,   27, -9,  50, 28
        DB        -88, 41,  97, -103, 69,  39, -9
                
MAT_B   DB        37, -101,   0,  58, -20              ; matrix B
        DB         9,   74,  94,  -4,  59  
        DB       -23,   90, -78,  16,  -4
        DB         0,  -62,  86,  20,  89
        DB         9,   86,  28,   0, -34
        DB        82,    5,  34, -21,   1
        DB        70,  -67,   9,  82,  14

MAT_C   DW      NP DUP(?)

TEMP    DW      ?
              
        .CODE       
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

MUL_MAT PROC
        PUSH    AX					; push
        PUSH    CX					; push
        PUSH    DI					; push
        PUSH    SI					; push
        	
        XOR     SI, SI          	; erase SI
        XOR     DI, DI          	; erase DI
        MOV     CX, N           	; move into CX the number of rows in MAT_A
        	
MATRIX: CALL    MUL_ROW         	; calculate the value of the single row
        INC     SI 					; increment index
        	
        PUSH    DX					; push
        MOV     AH, 2           	; reading DL
        MOV     DL, POINT       	; move carriage return
        INT     21H             	; interrupt
        POP     DX					; pop
        	
        LOOP    MATRIX 				; loop until the matrix ends
        	
        POP     DI					; pop 
        POP     SI					; pop  
        POP     CX					; pop
        POP     AX					; pop 
        RET
MUL_MAT ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

MUL_ROW PROC
        PUSH 	AX					; push
        PUSH 	CX					; push
        PUSH 	DX					; push
        PUSH 	DI					; push
        	
        MOV 	CX, P          		; move into CX the number of columns in MAT_B
ROW:    CALL 	MUL_ELE        		; calculate the value of the single element
        	
        PUSH 	AX					; push
        PUSH 	BX					; push
        PUSH 	CX					; push
        PUSH 	DX					; push
                               		   
        MOV 	CX, TEMP       		; move in CX the result
        MOV 	AX, DI         		; move in AX the column selector
        MOV 	DL, 2				; move in DL the number 2
        MUL 	DL             		; multiply the column selector by 2
        MOV 	BX, AX         		; move in BX the result
        	
        PUSH 	SI					; push
        MOV 	AX, SI         		; move in AX the row selector
        MOV 	DL, P*2				; move in DL the number P*2
        MUL 	DL             		; multiply the row selector by P*2
        MOV 	SI, AX         		; move in AX the result
        MOV 	MAT_C[BX][SI], CX   ; store the result in MAT_C
        POP 	SI					; pop 
        	
        POP 	DX					; pop  
        POP 	CX					; pop 
        POP 	BX					; pop 
        POP 	AX					; pop 
        	
        INC 	DI 					; increment index
        LOOP 	ROW 				; loop until the row ends
        	
        POP 	DI					; pop   
        POP 	DX					; pop  
        POP 	CX					; pop  
        POP 	AX					; pop 
        RET
MUL_ROW ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

MUL_ELE PROC                        ; MULTIPLY SINGLE ELEMENT
        PUSH 	AX					; push
        PUSH 	BX					; push
        PUSH 	CX					; push
        PUSH 	DX					; push
        PUSH 	SI					; push
        PUSH 	DI					; push
        
        MOV 	TEMP, 0             ; erase the content of TEMP
        MOV 	CX, M               ; move in CX the number of columns into MAT_A and the number of rows into MAT_B
        MOV 	AX, SI              ; move in AX the row selector
        MOV 	DL, M               ; move in DL the number of columns into MAT_A and the number of rows into MAT_B
        MUL 	DL                  ; multiply the row selector by M
        MOV 	SI, AX              ; move in AX the result
ELEMENT:
        MOV 	AL, MAT_A[SI]       ; first element from MAT_A
        MOV 	BL, MAT_B[DI]       ; second element from MAT_B
        IMUL 	BL                  ; AX=AL*multiplier
        
        ADD 	TEMP, AX            ; add partial result to TEMP
        JO      OVERFLOW            ; if OF=1 go to "OVERFLOW"
        
        INC 	SI                  ; increment column index (MAT_A)
        ADD 	DI, P               ; increment row index (MAT_B)
        LOOP 	ELEMENT             ; loop until the elements end
        JMP     ELEMENT_END         ; jump to "ELEMENT_END" 

OVERFLOW:
        MOV     AX, TEMP
        SHL     AX, 1               ; shift logic left
        JC      NEG_OVF             ; if CF=1 go to "NEG_OVF"
        MOV     TEMP, -32768        ; load lower limit
        JMP     ELEMENT_END         ; jump to "ELEMENT_END"
        
NEG_OVF:
        MOV     TEMP, 32767         ; load upper limit      
        
ELEMENT_END:        
        POP 	DI					; pop  
        POP 	SI					; pop  
        POP 	DX					; pop  
        POP 	CX					; pop  
        POP 	BX					; pop  
        POP 	AX					; pop  
        RET
MUL_ELE ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PRINTN  PROC                    	; PRINT NUMBERS
        PUSH    AX					; push
        PUSH    BX					; push
        PUSH    CX					; push
        PUSH    DX					; push
        	
        CMP     AX, 0           	; check if the number is positive
        JGE     MAX             	; if AX is positive go to "MAX"
        PUSH    AX					; push
        MOV     AH, 2           	; reading DL
        MOV     DL, '-'         	; move digit to DL
        INT     21H             	; interrupt
        POP     AX					; pop
        NEG     AX              	; complement AX
	
MAX:    CMP     AX, 25600       	; check if the number to print is greater than 25600 (25600/100=2560=>OVERFLOW)
        JB      BIG	
        MOV     BX, 1000        	; divisor
        XOR     DX, DX          	; erase DX
        DIV     BX              	; AX=DX:AX/divisor (DX=rest)
        PUSH    AX              	; push
        CALL    PRINTN          	; recursive iteration
        POP     AX              	; pop
        MOV     AX, DX          	; move the rest
        CMP     AX, 10          	; check if the number to print is less than 100
        JAE     POS             	; if AX is greater than 100 go to "BIG"
        PUSH    AX					; push
        MOV     AH, 2           	; reading DL
        MOV     DL, '0'         	; move '0' to DL
        INT     21H             	; interrupt
        POP     AX					; pop
	
BIG:    CMP     AX, 2560        	; check if the number to print is greater than 2560 (2560/10=256=>OVERFLOW)
        JB      POS	
        MOV     BL, 100         	; divisor
        DIV     BL              	; AL=AX/divisor (AH=rest)
        PUSH    AX              	; push
        XOR     AH, AH          	; erase the rest
        CALL    PRINTN          	; recursive iteration
        POP     AX              	; pop
        MOV     AL, AH          	; move the rest
        CBW	
        CMP     AX, 10          	; check if the number to print is less than 10
        JAE     POS             	; if AX is greater than 10 go to "POS"
        PUSH    AX					; push
        MOV     AH, 2           	; reading DL
        MOV     DL, '0'         	; move '0' to DL
        INT     21H             	; interrupt
        POP     AX					; pop
        	
POS:    CMP     AX, 10          	; check if the number to print is less than 10
        JB      DIGIT           	; if AX is less than 10 go to "DIGIT"
        MOV     BL, 10          	; divisor
        DIV     BL              	; AL=AX/divisor (AH=rest)
        PUSH    AX              	; push
        XOR     AH, AH          	; erase the rest
        CALL    PRINTN          	; recursive iteration
        POP     AX              	; pop
        MOV     AL, AH          	; move the rest
        CBW                     	; convert the rest in AL to word in AX
              	
DIGIT:  PUSH    AX					; push
        MOV     AH, 2           	; reading DL
        MOV     DL, AL          	; move digit to DL
        ADD     DL, 30H         	; convert to ASCII
        INT     21H             	; interrupt
        POP     AX					; pop
                	
        POP     DX					; pop
        POP     CX					; pop
        POP     BX					; pop
        POP     AX					; pop
        RET
PRINTN  ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PRINTS  PROC                    	; PRINT STRING
        PUSH    AX	
             	
        MOV     AH, 09H         	; show string
        INT     21H             	; interrupt
	
        POP     AX					; pop
        RET
PRINTS  ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PRINTMW PROC                    	; PRINT MATRIX (WORD)
        PUSH    SI	
        PUSH    AX	
        PUSH    CX	
        	
        XOR     SI, SI          	; erase SI
         	
ROWPW:  MOV     AX, [BX][SI]    	; move the number to print
        CALL    PRINTN          	; print number
        	
        PUSH    DX	
        MOV     AH, 2           	; reading DL
        MOV     DL, 09H         	; 09H=TAB
        INT     21H             	; interrupt
        POP     DX					; pop 
        	
        DEC     DX              	; decrement counter of elements
        JZ      MATRIX_ENDW     	; if DX is 0 go to "MATRIX_ENDW"
        	
        ADD     SI, 2           	; increment index (word)
        LOOP    ROWPW           	; loop until the row ends
        	
        POP     CX					; pop
        PUSH    CX	
        	
        PUSH    DX	
        LEA     DX, MSG1        	; new line
        CALL    PRINTS          	; print string
        POP     DX					; pop
        	
        JMP     ROWPW	
                    	
MATRIX_ENDW:	
        	
        POP     CX					; pop
        POP     AX					; pop
        POP     SI					; pop   
        RET
PRINTMW ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PRINTMB PROC                    	; PRINT MATRIX (BYTE)
        PUSH    SI	
        PUSH    AX	
        PUSH    CX	
        	
        XOR     SI, SI          	; erase SI
         	
ROWPB:  MOV     AL, [BX][SI]    	; move the number to print
        CBW	
        CALL    PRINTN          	; print number
        	
        PUSH    DX	
        MOV     AH, 2           	; reading DL
        MOV     DL, 09H         	; 09H=TAB
        INT     21H             	; interrupt
        POP     DX 	
        	
        DEC     DX              	; decrement counter of elements
        JZ      MATRIX_ENDB     	; if DX is 0 go to "MATRIX_ENDW"
        	
        INC     SI              	; increment index (byte)
        LOOP    ROWPB           	; loop until the row ends
        	
        POP     CX	
        PUSH    CX	
        	
        PUSH    DX	
        LEA     DX, MSG1        	; new line
        CALL    PRINTS          	; print string
        POP     DX					; pop
        	
        JMP     ROWPB	
                    	
MATRIX_ENDB:	
        	
        POP     CX					; pop
        POP     AX					; pop
        POP     SI					; pop
        RET
PRINTMB ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    
        .STARTUP
        
        LEA 	DX, MSGS        	; "Programma avviato"
        CALL 	PRINTS         		; print string
        		
        LEA 	DX, MSG1        	; CR + LF
        CALL 	PRINTS         		; print string
        		
        LEA 	DX, MSGA        	; "Matrice A:"
        CALL 	PRINTS         		; print string
        LEA 	BX, MAT_A       	; load effective address of MAT_A
        MOV 	CX, M           	; columns
        MOV 	DX, NM          	; elements
        CALL 	PRINTMB				; print matrix (byte)
        		
        LEA 	DX, MSG1        	; CR + LF
        CALL 	PRINTS         		; print string
        CALL 	PRINTS         		; print string
        		
        LEA 	DX, MSGB        	; "Matrice B:"
        CALL 	PRINTS         		; print string
        LEA 	BX, MAT_B       	; load effective address of MAT_B
        MOV 	CX, P           	; columns
        MOV 	DX, MP          	; elements
        CALL 	PRINTMB				; print matrix (byte)
        		
        LEA 	DX, MSG1        	; CR + LF
        CALL 	PRINTS         		; print string
        CALL 	PRINTS         		; print string
        		
        LEA 	DX, MSG2        	; "Calcolo della matrice C in corso"
        CALL 	PRINTS         		; print string
        		
        CALL 	MUL_MAT        		; calculate MAT_C
        		
        LEA 	DX, MSG1        	; CR + LF
        CALL 	PRINTS         		; print string
        CALL 	PRINTS         		; print string
        		
        LEA 	DX, MSGC        	; "Matrice C:"
        CALL 	PRINTS         		; print string
        LEA 	BX, MAT_C       	; load effective address of MAT_C
        MOV 	CX, P           	; columns
        MOV 	DX, NP          	; elements
        CALL 	PRINTMW				; print matrix (word)

        LEA 	DX, MSG1        	; CR + LF
        CALL 	PRINTS         		; print string
        CALL 	PRINTS         		; print string
        LEA 	DX, MSGE        	; "Programma terminato"
        CALL 	PRINTS         		; print string
        .EXIT
        END