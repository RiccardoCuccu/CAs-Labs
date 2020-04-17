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

word			EQU		0x00000004					; 4 byte = 1 word
N		   		EQU     0x00000004					; rows of Matrix_A
M		   		EQU     0x00000007					; columns of Matrix_A and rows of Matrix_B
P				EQU     0x00000005					; columns of Matrix_B
N_word		   	EQU     N*word
M_word		   	EQU     M*word	
P_word			EQU     P*word	
NM				EQU     N*M
MP				EQU     M*P
NP				EQU     N*P
NM_word			EQU     NM*word
MP_word			EQU     MP*word
NP_word			EQU     NP*word
sum_iteration	EQU		M
row_iteration	EQU		N
col_iteration	EQU		P

counter			RN		 7
h_partial_sum	RN		 8
l_partial_sum	RN		 9
element_A		RN		10
element_B		RN		11
element_C		RN		12

                AREA    exercise, DATA, READWRITE
Matrix_C	    SPACE   NM_word

                AREA    |.text|, CODE, READONLY
;Matrix_A		DCD		 4, -3, 5,  1
;				DCD		 3, -5, 0, 11
;				DCD		-5, 12, 4, -5

Matrix_A		DCD		 0x00000BB8, 0x000036B0, 0xFFFFC568, 0x00002328, 0x00006590, 0xFFFF30F8, 0x00001388
				DCD		 0x00015BA8, 0x00013498, 0x00000BB8, 0x000059D8, 0x00014820, 0xFFFFE890, 0xFFFF8AD0
				DCD		 0x0000A7F8, 0xFFFFF448, 0x00014438, 0x00006978, 0xFFFFDCD8, 0x0000C350, 0x00006D60
				DCD		 0xFFFEA840, 0x0000A028, 0x00017AE8, 0xFFFE6DA8, 0x00010D88, 0x00009858, 0xFFFFDCD8

;Matrix_B		DCD		 -2,  3
;				DCD		  5, -1
;				DCD		  4,  3
;				DCD		  9, -7

Matrix_B		DCD		0x00009088, 0xFFFE7578, 0x00000000, 0x0000E290, 0xFFFFB1E0
				DCD		0x00002328, 0x00012110, 0x00016F30, 0xFFFFF060, 0x0000E678
				DCD		0xFFFFA628, 0x00015F90, 0xFFFECF50, 0x00003E80, 0xFFFFF060
				DCD		0x00000000, 0xFFFF0DD0, 0x00014FF0, 0x00004E20, 0x00015BA8
				DCD		0x00002328, 0x00014FF0, 0x00006D60, 0x00000000, 0xFFFF7B30
				DCD		0x00014050, 0x00001388, 0x000084D0, 0xFFFFADF8, 0x000003E8
				DCD		0x00011170, 0xFFFEFA48, 0x00002328, 0x00014050, 0x000036B0

; Reset Handler

Reset_Handler   PROC
                EXPORT  Reset_Handler             [WEAK]
				LDR element_C, =Matrix_C				; Address of Matrix_C
				LDR element_A, =Matrix_A				; Address of Matrix_A
				LDR element_B, =Matrix_B				; Address of Matrix_B
				
				BL col_cycle
				
				NOP
				NOP
				NOP

stop			B stop
                ENDP

col_cycle		PROC
				PUSH {element_A, counter, LR}
				MOV h_partial_sum, #0					; reset high partial sum
				MOV l_partial_sum, #0					; reset low partial sum
				MOV counter, #row_iteration				; load the number of rows of Marix_C
col_items		BL row_cycle
				ADD element_A, element_A, #M_word		; next row of Marix_A (new row)
				SUB	counter, counter, #1				; decrement counter
				CMP counter, #0							; check if counter is #0
				BNE	col_items							; return to column items if count is not #0
				POP {element_A, counter, PC}			; return
				ENDP

row_cycle		PROC
				PUSH {element_B, counter, LR}
				MOV counter, #col_iteration				; load the number of colums of Marix_C
row_items		BL sum_elements
				ADD element_B, element_B, #word			; next element of Marix_B (new column)
				SUB	counter, counter, #1				; decrement counter
				CMP counter, #0							; check if counter is #0
				BNE	row_items							; return to row items if count is not #0
				POP {element_B, counter, PC}			; return
				ENDP

sum_elements	PROC
				PUSH {element_A, element_B, h_partial_sum, l_partial_sum, counter, LR}
				MOV counter, #sum_iteration				; load the number of sums
sum_items		BL mul_elements							; call mul_elements
				ADD element_A, element_A, #word			; next element of Marix_A (new column)
				ADD element_B, element_B, #P_word		; next element of Marix_B (new row)
				SUB	counter, counter, #1				; decrement counter
				CMP counter, #0							; check if counter is #0
				BNE	sum_items							; return to sum items if count is not #0
				BL check_result							; check overflow
				STR	l_partial_sum, [element_C]			; store result
				ADD element_C, element_C, #word			; next element of Marix_C
				POP {element_A, element_B, h_partial_sum, l_partial_sum, counter, PC}	
				ENDP

mul_elements	PROC
				PUSH {counter, LR}
				LDR r0, [element_A]						; load value from Matrix_A
				LDR r1, [element_B]						; load value from Matrix_B
				SMULL r2, r3, r0, r1					; signed multiplication with 64-bit result [SMULL <RLo>, <RHi>, <Rn>, <Rm>]
				ADDS l_partial_sum, l_partial_sum, r2	; store low partial result setting carry
				ADCS h_partial_sum, h_partial_sum, r3	; store high partial result adding carry
				POP {counter, PC}						; return
				ENDP
					
check_result	PROC
				PUSH {LR}
pos_compare		CMP h_partial_sum, #0x00000000			; check direct overflow (positive)
				BNE neg_compare
				AND counter, l_partial_sum, #0x80000000
				CMP counter, #0x00000000
				BEQ end_compare							; right positive result					
neg_compare		CMP h_partial_sum, #0xFFFFFFFF			; check direct overflow (negative)
				BNE overflow
				AND counter, l_partial_sum, #0x80000000
				CMP counter, #0x80000000
				BEQ end_compare							; right negative result				
overflow		AND counter, h_partial_sum, #0x80000000	; check indirect overflow (positive)
				CMP counter, #0x80000000
				BNE neg_overflow					
pos_overflow	MOV l_partial_sum, #0x80000000			; positive overflow
				B end_compare
neg_overflow	MOV l_partial_sum, #0x7FFFFFFF			; negative overflow	
end_compare	
				POP {PC}								; return
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
