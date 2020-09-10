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


; Reset Handler

Reset_Handler   PROC
                EXPORT  Reset_Handler             [WEAK]
				
				EXTERN	main
				BL		main
				
                ;MOV		r0, #4					; x
				;MOV		r1, #8					; y
				;BL		binaryExtendedGCD
				
stop			B		stop
                ENDP

; binaryGCD subroutine

binaryGCD		PROC
				PUSH	{r4-r11, LR}
				EXPORT	binaryGCD
				
				MOV		r4, #0					; set g to 0
				MOV		r5, r0					; copy of x
				MOV		r6, r1					; copy of y
				
comparez		CBZ		r5, endloopz			; if x is 0 branch
				AND		r7, r5, #0x00000001		; extract the LSB from x
				AND		r8, r6, #0x00000001		; extract the LSB from y
				AND		r9, r7, r8
				CMP		r9, #0x00000001			; check if they are both odd
				BEQ		oddoddz
				CMP		r7, #0x00000001			; check if x is odd and y is even
				BEQ		oddevenz
				CMP		r8, #0x00000001			; check if x is even and y is odd
				BEQ		evenoddz
				
evenevenz		LSR		r5, r5, #1				; right shift (division)
				LSR		r6, r6, #1				; right shift (division)
				ADD		r4, r4, #1
				B		comparez

evenoddz		LSR		r5, r5, #1				; right shift (division) of x
				B		comparez

oddevenz		LSR		r6, r6, #1				; right shift (division) of y
				B		comparez

oddoddz			CMP		r5, r6
				ITE		HS
				SUBHS	r5, r5, r6				; if (x >= y) x = x - y
				SUBLO	r6, r6, r5				; if (x < y) y = y - x
				B		comparez
				
endloopz		LSL		r4, r6, r4				; result = y << g
				MOV		r0, r4
				
				POP		{r4-r11, PC}
				ENDP

; binaryExtendedGCD subroutine

binaryExtendedGCD PROC
				PUSH	{r4-r11, LR}
				EXPORT	binaryExtendedGCD
	
				MOV		r5, r0					; copy of x (u)
				MOV		r6, r1					; copy of y (v)
				MOV		r7, #0					; set g to 0
				MOV		r8, #1					; set A to 1
				MOV		r9, #0					; set B to 0
				MOV		r10, #0					; set C to 0
				MOV		r11, #1					; set D to 1
				
compare			CMP		r5, #0
				BEQ		endloop					; if x is 0 branch
				CMP		r6, #0
				BEQ		endloop					; if y is 0 branch
				AND		r2, r5, #0x00000001		; extract the LSB from x
				AND		r3, r6, #0x00000001		; extract the LSB from y
				AND		r4, r2, r3
				CMP		r4, #0x00000001			; check if they are both odd
				BEQ		oddodd
				CMP		r2, #0x00000001			; check if x is odd and y is even
				BEQ		oddeven
				CMP		r3, #0x00000001			; check if x is even and y is odd
				BEQ		evenodd
				
eveneven		LSR		r5, r5, #1				; right shift of x (division)
				LSR		r6, r6, #1				; right shift of y (division)
				ADD		r7, r7, #1
				B		compare

evenodd			LSR		r5, r5, #1				; right shift (division) of x
				AND		r2, r8, #0x00000001		; extract the LSB from A
				AND		r3, r9, #0x00000001		; extract the LSB from B
				ORR		r4, r2, r3
				CBZ		r4, evenoddeven			; if A & B are even branch
				ADD		r8, r8, r1				; A = A + v
				LSR		r8, r8, #1				; right shift of A (division)
				SUB		r9, r9, r0				; B = B - u
				LSR		r9, r9, #1				; right shift of B (division)
				B		compare
				
evenoddeven		LSR		r8, r8, #1				; right shift of A (division)
				LSR		r9, r9, #1				; right shift of B (division)
				B		compare

oddeven			LSR		r6, r6, #1				; right shift (division) of y
				AND		r2, r10, #0x00000001	; extract the LSB from C
				AND		r3, r11, #0x00000001	; extract the LSB from D
				ORR		r4, r2, r3
				CBZ		r4, oddeveneven			; if C & D are even branch
				ADD		r10, r10, r1			; C = C + v
				LSR		r10, r10, #1			; right shift of C (division)
				SUB		r11, r11, r0			; D = D - u
				LSR		r11, r11, #1			; right shift of D (division)
				B		compare
				
oddeveneven		LSR		r10, r10, #1			; right shift of C (division)
				LSR		r11, r11, #1			; right shift of D (division)
				B		compare

oddodd			CMP		r5, r6
				BHI		oddoddxy				; if (x > y)
				BLS		oddoddyx				; if (x <= y)

oddoddxy		SUB		r5, r5, r6				; x = x - y
				SUB		r8, r8, r10				; A = A - C
				SUB		r9, r9, r11				; B = B - D
				B		compare

oddoddyx		SUB		r6, r6, r5				; y = y - x
				SUB		r10, r10, r8			; C = C - A
				SUB		r11, r11, r9			; D = D - B
				B		compare

endloop			MOV		r0, r10					; return C
				
				POP		{r4-r11, PC}
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
