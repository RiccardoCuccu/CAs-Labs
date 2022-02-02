;/**************************************************************************//**
; * @file     startup_LPC17xx.s
; * @brief    CMSIS Cortex-M3 Core Device Startup File for
; *           NXP LPC17xx Device Series
; * @version  V1.10
; * @date     06. April 2011
; *
; * @note
; * Copyright (C) 2009-2011 ARM Limited. All rights reserved.
; *
; * @par
; * ARM Limited (ARM) is supplying this software for use with Cortex-M
; * processor based microcontrollers.  This file can be freely distributed
; * within development tools that are supporting such ARM based processors.
; *
; * @par
; * THIS SOFTWARE IS PROVIDED "AS IS".  NO WARRANTIES, WHETHER EXPRESS, IMPLIED
; * OR STATUTORY, INCLUDING, BUT NOT LIMITED TO, IMPLIED WARRANTIES OF
; * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE APPLY TO THIS SOFTWARE.
; * ARM SHALL NOT, IN ANY CIRCUMSTANCES, BE LIABLE FOR SPECIAL, INCIDENTAL, OR
; * CONSEQUENTIAL DAMAGES, FOR ANY REASON WHATSOEVER.
; *
; ******************************************************************************/

; *------- <<< Use Configuration Wizard in Context Menu >>> ------------------

; <h> Stack Configuration
;   <o> Stack Size (in Bytes) <0x0-0xFFFFFFFF:8>
; </h>

Stack_Size      EQU     0x00000200

                AREA    STACK, NOINIT, READWRITE, ALIGN=3
Stack_Mem       SPACE   Stack_Size
__initial_sp


; <h> Heap Configuration
;   <o>  Heap Size (in Bytes) <0x0-0xFFFFFFFF:8>
; </h>

Heap_Size       EQU     0x00000000

                AREA    HEAP, NOINIT, READWRITE, ALIGN=3
__heap_base
Heap_Mem        SPACE   Heap_Size
__heap_limit


                PRESERVE8
                THUMB


; Vector Table Mapped to Address 0 at Reset

                AREA    RESET, DATA, READONLY
                EXPORT  __Vectors

__Vectors       DCD     __initial_sp              ; Top of Stack
                DCD     Reset_Handler             ; Reset Handler
                DCD     NMI_Handler               ; NMI Handler
                DCD     HardFault_Handler         ; Hard Fault Handler
                DCD     MemManage_Handler         ; MPU Fault Handler
                DCD     BusFault_Handler          ; Bus Fault Handler
                DCD     UsageFault_Handler        ; Usage Fault Handler
                DCD     0                         ; Reserved
                DCD     0                         ; Reserved
                DCD     0                         ; Reserved
                DCD     0                         ; Reserved
                DCD     SVC_Handler               ; SVCall Handler
                DCD     DebugMon_Handler          ; Debug Monitor Handler
                DCD     0                         ; Reserved
                DCD     PendSV_Handler            ; PendSV Handler
                DCD     SysTick_Handler           ; SysTick Handler

                ; External Interrupts
                DCD     WDT_IRQHandler            ; 16: Watchdog Timer
                DCD     TIMER0_IRQHandler         ; 17: Timer0
                DCD     TIMER1_IRQHandler         ; 18: Timer1
                DCD     TIMER2_IRQHandler         ; 19: Timer2
                DCD     TIMER3_IRQHandler         ; 20: Timer3
                DCD     UART0_IRQHandler          ; 21: UART0
                DCD     UART1_IRQHandler          ; 22: UART1
                DCD     UART2_IRQHandler          ; 23: UART2
                DCD     UART3_IRQHandler          ; 24: UART3
                DCD     PWM1_IRQHandler           ; 25: PWM1
                DCD     I2C0_IRQHandler           ; 26: I2C0
                DCD     I2C1_IRQHandler           ; 27: I2C1
                DCD     I2C2_IRQHandler           ; 28: I2C2
                DCD     SPI_IRQHandler            ; 29: SPI
                DCD     SSP0_IRQHandler           ; 30: SSP0
                DCD     SSP1_IRQHandler           ; 31: SSP1
                DCD     PLL0_IRQHandler           ; 32: PLL0 Lock (Main PLL)
                DCD     RTC_IRQHandler            ; 33: Real Time Clock
                DCD     EINT0_IRQHandler          ; 34: External Interrupt 0
                DCD     EINT1_IRQHandler          ; 35: External Interrupt 1
                DCD     EINT2_IRQHandler          ; 36: External Interrupt 2
                DCD     EINT3_IRQHandler          ; 37: External Interrupt 3
                DCD     ADC_IRQHandler            ; 38: A/D Converter
                DCD     BOD_IRQHandler            ; 39: Brown-Out Detect
                DCD     USB_IRQHandler            ; 40: USB
                DCD     CAN_IRQHandler            ; 41: CAN
                DCD     DMA_IRQHandler            ; 42: General Purpose DMA
                DCD     I2S_IRQHandler            ; 43: I2S
                DCD     ENET_IRQHandler           ; 44: Ethernet
                DCD     RIT_IRQHandler            ; 45: Repetitive Interrupt Timer
                DCD     MCPWM_IRQHandler          ; 46: Motor Control PWM
                DCD     QEI_IRQHandler            ; 47: Quadrature Encoder Interface
                DCD     PLL1_IRQHandler           ; 48: PLL1 Lock (USB PLL)
                DCD     USBActivity_IRQHandler    ; 49: USB Activity interrupt to wakeup
                DCD     CANActivity_IRQHandler    ; 50: CAN Activity interrupt to wakeup


                IF      :LNOT::DEF:NO_CRP
                AREA    |.ARM.__at_0x02FC|, CODE, READONLY
CRP_Key         DCD     0xFFFFFFFF
                ENDIF


                AREA    |.text|, CODE, READONLY

word            EQU     0x00000004                          ; 4 byte = 1 word
;N               EQU     0x00000003                          ; rows of Matrix_A
;M               EQU     0x00000004                          ; columns of Matrix_A and rows of Matrix_B
;P               EQU     0x00000002                          ; columns of Matrix_B
N               EQU     0x00000004                          ; rows of Matrix_A
M               EQU     0x00000007                          ; columns of Matrix_A and rows of Matrix_B
P               EQU     0x00000005                          ; columns of Matrix_B
N_word          EQU     N*word
M_word          EQU     M*word
P_word          EQU     P*word
NM              EQU     N*M
MP              EQU     M*P
NP              EQU     N*P
NM_word         EQU     NM*word
MP_word         EQU     MP*word
NP_word         EQU     NP*word
sum_iteration   EQU     M
row_iteration   EQU     N
col_iteration   EQU     P

counter         RN       7
h_partial_sum   RN       8
l_partial_sum   RN       9
address_A       RN      10
address_B       RN      11
address_C       RN      12

                AREA    exercise, DATA, READWRITE
Matrix_C        SPACE   NM_word

                AREA    |.text|, CODE, READONLY
;Matrix_A        DCD      4, -3, 5,  1
;                DCD      3, -5, 0, 11
;                DCD     -5, 12, 4, -5

Matrix_A        DCD     0x00000BB8, 0x000036B0, 0xFFFFC568, 0x00002328, 0x00006590, 0xFFFF30F8, 0x00001388
                DCD     0x00015BA8, 0x00013498, 0x00000BB8, 0x000059D8, 0x00014820, 0xFFFFE890, 0xFFFF8AD0
                DCD     0x0000A7F8, 0xFFFFF448, 0x00014438, 0x00006978, 0xFFFFDCD8, 0x0000C350, 0x00006D60
                DCD     0xFFFEA840, 0x0000A028, 0x00017AE8, 0xFFFE6DA8, 0x00010D88, 0x00009858, 0xFFFFDCD8

;Matrix_B        DCD     -2,  3
;                DCD      5, -1
;                DCD      4,  3
;                DCD      9, -7

Matrix_B        DCD     0x00009088, 0xFFFE7578, 0x00000000, 0x0000E290, 0xFFFFB1E0
                DCD     0x00002328, 0x00012110, 0x00016F30, 0xFFFFF060, 0x0000E678
                DCD     0xFFFFA628, 0x00015F90, 0xFFFECF50, 0x00003E80, 0xFFFFF060
                DCD     0x00000000, 0xFFFF0DD0, 0x00014FF0, 0x00004E20, 0x00015BA8
                DCD     0x00002328, 0x00014FF0, 0x00006D60, 0x00000000, 0xFFFF7B30
                DCD     0x00014050, 0x00001388, 0x000084D0, 0xFFFFADF8, 0x000003E8
                DCD     0x00011170, 0xFFFEFA48, 0x00002328, 0x00014050, 0x000036B0

;Matrix_C        DCD      6,  23
;                DCD     68, -63
;                DCD     41,  20

;Matrix_C        DCD     0x80000000, 0x1B7A4D40, 0x7FFFFFFF, 0x5E3C2540, 0x2D4CAE00
;                DCD     0x7D1C32C0, 0x7FFFFFFF, 0x7FFFFFFF, 0x7FFFFFFF, 0x6164DC80
;                DCD     0x7FFFFFFF, 0xBA5279C0, 0x80000000, 0x7FFFFFFF, 0x6A372980
;                DCD     0x8D05CBC0, 0x7FFFFFFF, 0x80000000, 0x80000000, 0x80000000

; Reset Handler

Reset_Handler   PROC
                EXPORT  Reset_Handler             [WEAK]
                
                LDR     address_C, =Matrix_C                ; load address of Matrix_C
                LDR     address_A, =Matrix_A                ; load address of Matrix_A
                LDR     address_B, =Matrix_B                ; load address of Matrix_B

                ;BL      col_cycle                           ; slower/older implementation
                BL      matrixCalc                          ; faster/newer implementation

                NOP
                NOP
                NOP

stop            B       stop
                ENDP

; Faster implementation

matrixCalc      PROC
                PUSH    {r1-r9, LR}
                
                EOR     r2, r2                              ; offset Matrix_A
                EOR     r3, r3                              ; offset Matrix_B
                EOR     r4, r4                              ; offset Matrix_C
                EOR     r7, r7                              ; low partial result
                EOR     r8, r8                              ; high partial result
                MOV     r9, #M                              ; multiplication counter
                
                B       elementCalc                         ; jump to the calculation of the first destination element

initializeR     ADD     r2, r2, #word                       ; move to the next row (Matrix_A)
                EOR     r3, r3                              ; move to the first column (Matrix_B)
                MOV     r9, #M                              ; set multiplication counter
                B       elementCalc                         ; jump to the calculation of the next destination element

initializeC     SUB     r3, r3, #MP_word-P_word-word        ; move to the next column (Matrix_B)
                SUB     r2, r2, #M_word-word                ; move to the first element of the row (Matrix_A)
                MOV     r9, #M                              ; set multiplication counter

elementCalc     LDR     r0, [address_A, r2]                 ; load an element from Matrix_A
                LDR     r1, [address_B, r3]                 ; load an element from Matrix_B

                SMULL   r5, r6, r0, r1                      ; signed multiplication with 64-bit result [SMULL <RLo>, <RHi>, <Rn>, <Rm>]

                ADDS    r7, r7, r5                          ; store low partial result setting carry
                ADC     r8, r8, r6                          ; store high partial result adding carry
                
                SUBS    r9, r9, #1                          ; decrement multiplication counter
                ITTT    NE                                  ; check if it is zero
                ADDNE   r2, r2, #word                       ; if it is not zero move to the next row element (Matrix_A)
                ADDNE   r3, r3, #P_word                     ; if it is not zero move to the next column element (Matrix_B)
                BNE     elementCalc                         ; if it is not zero jump to the calculation of the next destination element
                
                TEQ     r8, #0x00000000                     ; high partial result equivalence test with all zeros (positive overflow check)
                BEQ     positiveHalf                        ; jump to the check of the sign of the low partial result
                
                TEQ     r8, #0xFFFFFFFF                     ; high partial result equivalence test with all ones (negative overflow check)
                BEQ     negativeHalf                        ; jump to the check of the sign of the low partial result
                
                TST     r8, #0x80000000                     ; check if the MSB of the high partial result is set
                ITE     EQ                                  ; if the MSB of the high partial result is set means that the result is not zero (Z=0)
                MOVEQ   r7, #0x7FFFFFFF                     ; Z=1 means MSB=0 (positive number)
                MOVNE   r7, #0x80000000                     ; Z=0 means MSB=1 (negative number)
                
                B       elementStore                        ; jump to store the element
                
positiveHalf    TST     r7, #0x80000000                     ; test the higher bit of the low partial result
                BEQ     elementStore                        ; jump to store the element if test result is zero
                MOV     r7, #0x7FFFFFFF                     ; otherwise use the highest possible value
                B       elementStore                        ; jump to store the element

negativeHalf    TST     r7, #0x80000000                     ; test the higher bit of the low partial result
                BNE     elementStore                        ; jump to store the element if test result is not zero
                MOV     r7, #0x80000000                     ; otherwise use the lowest possible value 

elementStore    STR     r7, [address_C, r4]                 ; store the element to Matrix_C
                EOR     r7, r7                              ; reset low partial result
                EOR     r8, r8                              ; reset high partial result
                ADD     r4, r4, #4                          ; move to the next element (Matrix_C)
                
                CMP     r3, #MP_word-word                   ; check if it is the last element of the last column (Matrix_B)
                BNE     initializeC                         ; if not jump to the initialization of a new column
                
                CMP     r2, #NM_word-word                   ; check if it is the last element of the last row (Matrix_A)
                BNE     initializeR                         ; if not jump to the initialization of a new row
                
                POP     {r1-r9, PC}
                ENDP

; Slower implementation

col_cycle       PROC
                PUSH    {address_A, counter, LR}
                MOV     h_partial_sum, #0                   ; reset high partial sum
                MOV     l_partial_sum, #0                   ; reset low partial sum
                MOV     counter, #row_iteration             ; load the number of rows of Marix_C
col_items       BL      row_cycle
                ADD     address_A, address_A, #M_word       ; next row of Marix_A (new row)
                SUB     counter, counter, #1                ; decrement counter
                CMP     counter, #0                         ; check if counter is #0
                BNE     col_items                           ; return to column items if count is not #0
                POP     {address_A, counter, PC}            ; return
                ENDP

row_cycle       PROC
                PUSH    {address_B, counter, LR}
                MOV     counter, #col_iteration             ; load the number of colums of Marix_C
row_items       BL      sum_elements
                ADD     address_B, address_B, #word         ; next element of Marix_B (new column)
                SUB     counter, counter, #1                ; decrement counter
                CMP     counter, #0                         ; check if counter is #0
                BNE     row_items                           ; return to row items if count is not #0
                POP     {address_B, counter, PC}            ; return
                ENDP

sum_elements    PROC
                PUSH    {address_A, address_B, h_partial_sum, l_partial_sum, counter, LR}
                MOV     counter, #sum_iteration             ; load the number of sums
sum_items       BL      mul_elements                        ; call mul_elements
                ADD     address_A, address_A, #word         ; next element of Marix_A (new column)
                ADD     address_B, address_B, #P_word       ; next element of Marix_B (new row)
                SUB     counter, counter, #1                ; decrement counter
                CMP     counter, #0                         ; check if counter is #0
                BNE     sum_items                           ; return to sum items if count is not #0
                BL      check_result                        ; check overflow
                STR     l_partial_sum, [address_C]          ; store result
                ADD     address_C, address_C, #word         ; next element of Marix_C
                POP     {address_A, address_B, h_partial_sum, l_partial_sum, counter, PC}   
                ENDP

mul_elements    PROC
                PUSH    {counter, LR}
                LDR     r0, [address_A]                     ; load value from Matrix_A
                LDR     r1, [address_B]                     ; load value from Matrix_B
                SMULL   r2, r3, r0, r1                      ; signed multiplication with 64-bit result [SMULL <RLo>, <RHi>, <Rn>, <Rm>]
                ADDS    l_partial_sum, l_partial_sum, r2    ; store low partial result setting carry
                ADCS    h_partial_sum, h_partial_sum, r3    ; store high partial result adding carry
                POP     {counter, PC}                       ; return
                ENDP

check_result    PROC
                PUSH    {LR}
pos_compare     CMP     h_partial_sum, #0x00000000          ; check direct overflow (positive)
                BNE     neg_compare
                AND     counter, l_partial_sum, #0x80000000
                CMP     counter, #0x00000000
                BEQ     end_compare                         ; right positive result                 
neg_compare     CMP     h_partial_sum, #0xFFFFFFFF          ; check direct overflow (negative)
                BNE     overflow
                AND     counter, l_partial_sum, #0x80000000
                CMP     counter, #0x80000000
                BEQ     end_compare                         ; right negative result             
overflow        AND     counter, h_partial_sum, #0x80000000 ; check indirect overflow (positive)
                CMP     counter, #0x80000000
                BNE     neg_overflow                    
pos_overflow    MOV     l_partial_sum, #0x80000000          ; positive overflow
                B       end_compare
neg_overflow    MOV     l_partial_sum, #0x7FFFFFFF          ; negative overflow 
end_compare 
                POP     {PC}                                ; return
                ENDP


; Dummy Exception Handlers (infinite loops which can be modified)

NMI_Handler     PROC
                EXPORT  NMI_Handler               [WEAK]
                B       .
                ENDP
HardFault_Handler\
                PROC
                EXPORT  HardFault_Handler         [WEAK]
                B       .
                ENDP
MemManage_Handler\
                PROC
                EXPORT  MemManage_Handler         [WEAK]
                B       .
                ENDP
BusFault_Handler\
                PROC
                EXPORT  BusFault_Handler          [WEAK]
                B       .
                ENDP
UsageFault_Handler\
                PROC
                EXPORT  UsageFault_Handler        [WEAK]
                B       .
                ENDP
SVC_Handler     PROC
                EXPORT  SVC_Handler               [WEAK]
                B       .
                ENDP
DebugMon_Handler\
                PROC
                EXPORT  DebugMon_Handler          [WEAK]
                B       .
                ENDP
PendSV_Handler  PROC
                EXPORT  PendSV_Handler            [WEAK]
                B       .
                ENDP
SysTick_Handler PROC
                EXPORT  SysTick_Handler           [WEAK]
                B       .
                ENDP

Default_Handler PROC

                EXPORT  WDT_IRQHandler            [WEAK]
                EXPORT  TIMER0_IRQHandler         [WEAK]
                EXPORT  TIMER1_IRQHandler         [WEAK]
                EXPORT  TIMER2_IRQHandler         [WEAK]
                EXPORT  TIMER3_IRQHandler         [WEAK]
                EXPORT  UART0_IRQHandler          [WEAK]
                EXPORT  UART1_IRQHandler          [WEAK]
                EXPORT  UART2_IRQHandler          [WEAK]
                EXPORT  UART3_IRQHandler          [WEAK]
                EXPORT  PWM1_IRQHandler           [WEAK]
                EXPORT  I2C0_IRQHandler           [WEAK]
                EXPORT  I2C1_IRQHandler           [WEAK]
                EXPORT  I2C2_IRQHandler           [WEAK]
                EXPORT  SPI_IRQHandler            [WEAK]
                EXPORT  SSP0_IRQHandler           [WEAK]
                EXPORT  SSP1_IRQHandler           [WEAK]
                EXPORT  PLL0_IRQHandler           [WEAK]
                EXPORT  RTC_IRQHandler            [WEAK]
                EXPORT  EINT0_IRQHandler          [WEAK]
                EXPORT  EINT1_IRQHandler          [WEAK]
                EXPORT  EINT2_IRQHandler          [WEAK]
                EXPORT  EINT3_IRQHandler          [WEAK]
                EXPORT  ADC_IRQHandler            [WEAK]
                EXPORT  BOD_IRQHandler            [WEAK]
                EXPORT  USB_IRQHandler            [WEAK]
                EXPORT  CAN_IRQHandler            [WEAK]
                EXPORT  DMA_IRQHandler            [WEAK]
                EXPORT  I2S_IRQHandler            [WEAK]
                EXPORT  ENET_IRQHandler           [WEAK]
                EXPORT  RIT_IRQHandler            [WEAK]
                EXPORT  MCPWM_IRQHandler          [WEAK]
                EXPORT  QEI_IRQHandler            [WEAK]
                EXPORT  PLL1_IRQHandler           [WEAK]
                EXPORT  USBActivity_IRQHandler    [WEAK]
                EXPORT  CANActivity_IRQHandler    [WEAK]

WDT_IRQHandler
TIMER0_IRQHandler
TIMER1_IRQHandler
TIMER2_IRQHandler
TIMER3_IRQHandler
UART0_IRQHandler
UART1_IRQHandler
UART2_IRQHandler
UART3_IRQHandler
PWM1_IRQHandler
I2C0_IRQHandler
I2C1_IRQHandler
I2C2_IRQHandler
SPI_IRQHandler
SSP0_IRQHandler
SSP1_IRQHandler
PLL0_IRQHandler
RTC_IRQHandler
EINT0_IRQHandler
EINT1_IRQHandler
EINT2_IRQHandler
EINT3_IRQHandler
ADC_IRQHandler
BOD_IRQHandler
USB_IRQHandler
CAN_IRQHandler
DMA_IRQHandler
I2S_IRQHandler
ENET_IRQHandler
RIT_IRQHandler
MCPWM_IRQHandler
QEI_IRQHandler
PLL1_IRQHandler
USBActivity_IRQHandler
CANActivity_IRQHandler

                B       .

                ENDP


                ALIGN


; User Initial Stack & Heap

                IF      :DEF:__MICROLIB

                EXPORT  __initial_sp
                EXPORT  __heap_base
                EXPORT  __heap_limit

                ELSE

                IMPORT  __use_two_region_memory
                EXPORT  __user_initial_stackheap
__user_initial_stackheap

                LDR     R0, =  Heap_Mem
                LDR     R1, =(Stack_Mem + Stack_Size)
                LDR     R2, = (Heap_Mem +  Heap_Size)
                LDR     R3, = Stack_Mem
                BX      LR

                ALIGN

                ENDIF


                END
