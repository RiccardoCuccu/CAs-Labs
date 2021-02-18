; Exam of 03.02.2021

        .model small
        .stack

        LEN         EQU 4
        SIZE        EQU LEN*LEN

        LF          EQU 10      ; line feed
        CR          EQU 13      ; carriage return
        PLUS        EQU 43      ; plus sign
        MINUS       EQU 45      ; minus sign

        .data

        MSG         DB "Enter a value between -80 and +120:", CR, LF, "> ", "$"

        SOURCE      DW 'A','B','C','D'
                    DW 'E','F','G','H'
                    DW 'I','J','K','L'
                    DW 'M','N','O','P'
                    
        DESTINATION DW SIZE DUP(0)

        N           DW  ?

        .code

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


ROTATE  PROC                    ; ROTATE MATRIX
        PUSHA

        MOV     CX, LEN         ; set counter to LEN

ROW:
        MOV     DX, SOURCE[SI]
        MOV     DESTINATION[DI], DX

        ADD     SI, 2           ; increment source
        ADD     DI, 2           ; increment destination

        CMP     DI, 2*SIZE      ; check if the destination index has exceeded the size of the matrix
        JE      RESETROT

        LOOP    ROW
        JMP     ENDROT

RESETROT:
        MOV     DI, 0           ; reset destination index
        LOOP    ROW

ENDROT:
        POPA
        RET
ROTATE  ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


INNUM   PROC                    ; INPUT NUMBER
        PUSHA

        MOV     N, 0            ; set N to 0
        MOV     CH, 0

NEXTNUM:
        MOV     AH, 1           ; reading code
        INT     21H             ; interrupt

        CMP     AL, MINUS       ; check if the character is the minus sign
        JE      NEGNUM 

        CMP     AL, PLUS        ; check if the character is the plus sign
        JE      NEXTNUM

        CMP     AL, CR          ; check if the character is ENTER
        JE      ENDSAVE

        SUB     AL, 48          ; difference between ASCII and number
        MOV     BL, AL          ; copy the number to BL
        MOV     BH, 0           ; reset BH to have BX=BL

        MOV     AX, N           ; copy the previously entered value into AX
        MOV     CL, 10          ; prepare multiplication by 10
        MUL     CL              ; multiply
        ADD     AX, BX          ; add the value multiplied with the one just entered
        MOV     N, AX           ; load the value to N
        JMP     NEXTNUM

ENDSAVE:
        CMP     CH, 1           ; check if it is a negative number
        JE      INCR            ; if it is it is necessary to remove the sign and add LEN/2
        CMP     N, LEN          ; check if it is a number greater than LEN
        JGE     REDUCE          ; if it is it is necessary to reduce it
        JMP     ENDIN

NEGNUM: 
        MOV     CH, 1           ; flag negative number
        JMP     NEXTNUM

REDUCE: 
        SUB     N, LEN          ; decrement N of LEN
        JMP     ENDSAVE

INCR:
        MOV     CH, 0           ; removing the sign and incrementing by LEN/2 gives the same result as a positive number
        ADD     N, SIZE/2
        JMP     ENDSAVE

ENDIN:
        POPA
        RET
INNUM   ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

        .startup

        LEA     DX, MSG         ; "Enter a value between -80 and +120:"
        MOV     AH, 09H         ; printing code
        INT     21H             ; interrupt

        CALL    INNUM           ; get value N from user
        MOV     AX, N           ; move value N to AX
        MOV     SI, 0           ; set the source index to 0
        MOV     DL, 2*LEN       ; prepare multiplication by 2*LEN
        MUL     DL              ; multiply
        MOV     DI, AX          ; move the destination index into DI
        MOV     CX, LEN         ; set counter to LEN

NEXT:   
        CALL    ROTATE
        ADD     SI, 2*LEN       ; increment source
        ADD     DI, 2*LEN       ; increment destination
        CMP     DI, 2*SIZE      ; check if the destination index has exceeded the size of the matrix
        JE      RESNEXT

        LOOP    NEXT
        JMP     END

RESNEXT:
        MOV     DI, 0           ; reset destination index
        LOOP    NEXT

END:
        .exit
        end
