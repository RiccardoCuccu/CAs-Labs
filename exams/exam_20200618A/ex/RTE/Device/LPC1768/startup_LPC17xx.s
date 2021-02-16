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

                AREA    matrixDeclaration, DATA, READWRITE
matrix          SPACE   2000

                AREA    arrayInitialization, DATA, READONLY
array           DCD     4, 30, 120, 340, 780

                AREA    |.text|, CODE, READONLY

count1          RN      3                       ; counter1
count2          RN      4                       ; counter2
offset          RN      5                       ; offset
temp1           RN      6                       ; temp1 var
temp2           RN      7                       ; temp2 var
address1        RN      8                       ; address of the first element
address2        RN      9                       ; address of the second element
M               RN      10                      ; address of M
inc             RN      11                      ; incrementer

; Reset Handler

Reset_Handler   PROC
                EXPORT  Reset_Handler             [WEAK]

                LDR     r0, =matrix
                LDR     r1, =array
                MOV     r2, #5                      ; number of values in the array (the grade of the polynomial is r2 - 1)
                BL      initializeMatrix

                LDR     r0, =matrix
                MOV     r1, #5
                BL      computeDifferences

                LDR     r0, =matrix
                MOV     r1, #5
                MOV     r2, #9                      ; return value will be p(r2)
                BL      getPolynomialValue

stop            B       stop
                ENDP

; initializeMatrix subroutine

initializeMatrix PROC
                PUSH    {r4-r11, LR}

                MOV     count1, #0                  ; initialize the counter1 to 0 (will be used to count rows)
                MOV     address1, r0                ; take the address of the matrix
                MOV     address2, r1                ; take the address of the array
                MOV     offset, r2                  ; number of values in the array
                LSL     offset, #2                  ; multiply by 4 to get the offset

initRow         LDR     temp1, [address2]           ; take the value from the array
                STR     temp1, [address1]           ; put the value in the matrix

                ADD     count1, #1                  ; increment counter1 (new row)
                CMP     count1, r2                  ; check if it is the last row
                BEQ     initEnd

                ADD     address1, offset            ; increment the address of "n" columns
                ADD     address2, #4                ; increment the address of a word

                B       initRow
initEnd
                POP     {r4-r11, PC}
                ENDP

; computeDifferences subroutine

computeDifferences PROC
                PUSH    {r4-r11, LR}

                MOV     count2, r1                  ; initialize the counter2 to r1 (n+1)
                MOV     inc, #0                     ; initialize the incrementer to 0
                MOV     offset, r1                  ; number of values in the array
                LSL     offset, #2                  ; multiply by 4 to get the offset

compRow         SUB     count2, count2, #1          ; decrease counter2 because the next column needs one less element
                CMP     count2, #0                  ; if there are no elements to process the subroutine is finished
                BEQ     compEnd
                MOV     count1, #0                  ; initialize the counter1 to 0 (will be used to count rows)
                ADD     M, r0, inc                  ; move the address of the first element of the column to M
                ADD     inc, inc, #4                ; increment the incrementer for the next cycle

compCol         MOV     address1, M                 ; address of M[i][j]
                ADD     address2, address1, offset  ; address of M[i+1][j]

                LDR     temp1, [address1]           ; value of M[i][j]
                LDR     temp2, [address2]           ; value of M[i+1][j]
                SUB     temp1, temp2, temp1         ; M[i][j+1] = M[i+1][j] - M[i][j]
                BVC     compStr                     ; check if there is no overflow
                BMI     compPosOver                 ; positive overflow
                B       compNegOver                 ; negative overflow

compStr         STR     temp1, [address1, #4]       ; put the value in M[i][j+1]

                ADD     M, offset                   ; increment the address of M by one row

                ADD     count1, #1                  ; increment counter1 (new row)
                CMP     count1, count2              ; check if it was the last row of this column
                BEQ     compRow
                B       compCol

compPosOver     MOV     temp1, #0x7FFFFFFF          ; minimum number that can be represented
                B       compStr 
                
compNegOver     MOV     temp1, #0x80000000          ; maximum number that can be represented
                B       compStr 

compEnd
                POP     {r4-r11, PC}
                ENDP

; getPolynomialValue subroutine

getPolynomialValue PROC
                PUSH    {r3-r11, LR}
                
                MOV     offset, r1                  ; number of values in the array
                LSL     offset, #2                  ; multiply by 4 to get the offset
                MOV     count1, #1                  ; initialize the counter to 1
                MOV     count2, r1                  ; initialize the counter to r1 (m)
                MOV     inc, offset                 ; sets the incrementer equal to the offset less one word
                SUB     inc, inc, #4
                
                ADD     M, r0, inc                  ; address of M[0][n-1] (last element of the first row)
                LDR     temp1, [M]                  ; value of M[0][n-1]
                
getLastCol      ADD     M, M, offset                ; increment the address of M by one row
                STR     temp1, [M]                  ; put the value in the matrix
                ADD     count1, count1, #1          ; increment counter1 (new row)
                CMP     count1, r1                  ; check if it was the last row of the last column 
                BNE     getLastCol

getRow          CMP     count2, r2                  ; if the matrix is complete the subroutine is finished
                BEQ     getEnd
                
                MOV     count1, #0                  ; initialize the counter1 to 0
                ADD     count2, count2, #1          ; increment counter2
                ADD     M, r0, offset               ; new row
                ADD     M, r0, inc                  ; correct column
                
                ADD     inc, inc, offset            ; sets the incrementer for the next iteration
                SUB     inc, inc, #4

getCol          MOV     address1, M                 ; address of M[i-1][j]
                SUB     address2, address1, #4      ; address of M[i-1][j+1]
                
                LDR     temp1, [address1]           ; value of M[i-1][j]
                LDR     temp2, [address2]           ; value of M[i-1][j+1]
                ADD     temp2, temp2, temp1         ; M[i][j] = M[i-1][j] + M[i-1][j+1]
                BVC     getStr                      ; check if there is no overflow
                BMI     getPosOver                  ; positive overflow
                B       getNegOver                  ; negative overflow

getStr          STR     temp2, [address2, offset]   ; put the value in M[i][j]

                ADD     M, offset                   ; increment the address of M by one row

                ADD     count1, #1                  ; increment counter1 (new row)
                CMP     count1, r1                  ; check if it was the last row of this column
                BEQ     getRow
                B       getCol

getPosOver      MOV     temp1, #0x7FFFFFFF          ; minimum number that can be represented
                B       getStr 
                
getNegOver      MOV     temp1, #0x80000000          ; maximum number that can be represented
                B       getStr      
getEnd
                POP     {r3-r11, PC}
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
