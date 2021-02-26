; Exam of 22.02.2021

        .model small
        .stack

        LEN         EQU 3
        SIZE        EQU LEN*LEN     ; matrix size
        
        .data

        SOURCE      DB 1, 2, 3
                    DB 4, 5, 6
                    DB 7, 8, 9
 
        DESTINATION DW SIZE DUP(0)

        .code
        .startup

        MOV     CX, SIZE            ; set counter to LEN
        MOV     SI, 0               ; set source index to 0
        MOV     DI, 0               ; set destination index to 0

SUMS:
        MOV     DL, SOURCE[SI]      ; extract the first value from the SOURCE matrix
        MOV     DH, 0               ; set DH to 0
        ADD     SI, LEN             ; increment source index by a row
        CMP     SI, SIZE            ; check if source index still points to an element of the SOURCE matrix
        JL      SKIP1               ; jump if less
        SUB     SI, SIZE            ; otherwise decrement the source index to point to the correct element of the SOURCE matrix

SKIP1:
        ADD     DL, SOURCE[SI]      ; extract and sum the second value of the SOURCE matrix
        ADC     DH, 0               ; adds any carry bit
        MOV     DESTINATION[DI], DX ; put the sum in the DESTINATION matrix

        CMP     SI, LEN             ; checks if the source index points to an element of the first row of the SOURCE matrix
        JGE     SKIP2               ; jump if greater or equal
        ADD     SI, SIZE            ; otherwise increment the source index to point to the correct element of the SOURCE matrix

SKIP2:
        SUB     SI, LEN-1           ; get the next element of the SOURCE matrix
        ADD     DI, 2               ; get the next element of the DESTINATION matrix

        LOOP    SUMS

        .exit
        end
