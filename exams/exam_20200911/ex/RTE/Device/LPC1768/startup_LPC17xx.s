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


				AREA	variableDeclaration, DATA, READWRITE
mySpace			SPACE	128


				AREA	stringDefinition, DATA, READONLY
string1			DCB		"computer architectures", 0
;string2			DCB		"spectrometer", 0
string2			DCB		"accurate search", 0
;string1			DCB		"a teacher of computer architectures", 0
;string2			DCB		"accurate search or prefetch timeout", 0


                AREA    |.text|, CODE, READONLY

count1			RN		4						; counter string1
count2			RN		5						; counter string2
char1			RN		6						; character string1
char2			RN		7						; character string2
addr1			RN		8						; address string1
addr2			RN		9						; address string2

; Reset Handler

Reset_Handler   PROC
                EXPORT  Reset_Handler             [WEAK]
				
				;EXTERN	main
				;BL		main
				
                LDR		r0, =string1
				LDR		r1, =string2
				;BL		isContained
				;BL		isAnagram
				BL		longestSubstring
				
stop			B		stop
                ENDP

; isContained subroutine

isContained		PROC
				PUSH	{r4-r11, LR}
				
				MOV		count1, #0				; set to 0 counter string1
				MOV		count2, #0				; set to 0 counter string2
				LDRB	char1, [r0]				; first character string1
				LDRB	char2, [r1]				; first character string2
				MOV		addr1, r0				; copy address string1
				MOV		addr2, r1				; copy address string2
				MOV		r10, char2				; again first character string2

checkNumber		CMP		r10, #0					; check if string2 is finished
				BEQ		outerLoop
				CMP		char2, r10				; checks if the characters are equal
				BEQ		incCounter
continueCheck	LDRB	r10, [addr2, #1]!		; load the next character of string2
				B		checkNumber
				
incCounter		ADD		count2, count2, #1		; increment counter2
				B		continueCheck

outerLoop		CMP		char2, #0				; check if string2 is finished
				BEQ		endString2
innerLoop		CMP		char1, #0				; check if string1 is finished
				BEQ		endString1
				CMP		char1, char2			; checks if the characters are equal
				BEQ		charPresent
				LDRB	char1, [addr1, #1]!		; load the next character of string1
				B		innerLoop

charPresent		ADD		count1, count1, #1		; increment counter1
				LDRB	char1, [addr1, #1]!		; load the next character of string1
				B		innerLoop

endString1		CMP		count1, #0				; check if there is at least one occurrence
				BEQ		notSufficient
				CMP		count1, count2			; compare the two counters
				BLT		notSufficient
				
				MOV		count1, #0				; reset counter1
				MOV		count2, #0				; reset counter2
				
				MOV		addr1, r0				; reset string1 address
				LDRB	char1, [addr1]			; load the first character of string1
				
				LDRB	char2, [r1, #1]!		; load the next character of string2
				MOV		addr2, r1				; align string2 address
				MOV		r10, char2				; load the next character of string2 again in r10
				B		checkNumber

endString2		MOV		r0, #1					; return 1
				B		endContained

notSufficient	MOV		r0, #0					; return 0

endContained	POP		{r4-r11, PC}
				ENDP

; isAnagram subroutine

isAnagram		PROC
				PUSH	{r4-r11, LR}
				
				MOV		addr1, r0				; copy address string1
				MOV		addr2, r1				; copy address string2
				BL		isContained
				CMP		r0, #0					; check if isContained returned a 0
				BEQ		notAnagram
				
				MOV		r1, addr1				; assign the address of string1 to the second input (r1)
				MOV		r0, addr2				; assign the address of string2 to the first input (r0)
				BL		isContained
				CMP		r0, #1					; check if isContained returned a 1
				BEQ		isSufficient
				
notAnagram		MOV		r0, #0					; return 0
				B		endAnagram
				
isSufficient	MOV		r0, #1					; return 1

endAnagram		POP		{r4-r11, PC}
				ENDP

; longestSubstring subroutine

longestSubstring PROC
				PUSH	{r4-r11, LR}

				MOV		count1, #0				; set to 0 counter1
				MOV		count2, #0				; set to 0 counter2
				LDRB	char1, [r0]				; first character string1
				LDRB	char2, [r1]				; first character string2
				MOV		addr1, r0				; copy address string1
				MOV		addr2, r1				; copy address string2

loop			CMP		char2, #0				; check if string2 is finished
				BEQ		endString
				CMP		char1, #0				; check if string1 is finished
				BEQ		endString
				CMP		char1, char2			; checks if the characters are equal
				BEQ		charMatch
				LDRB	char1, [addr1, #1]!		; load the next character of string1
				B		loop

charMatch		ADD		count1, count1, #1		; increment counter1
				LDRB	char1, [addr1, #1]!		; load the next character of string1
				LDRB	char2, [addr2, #1]!		; load the next character of string1
				B		loop

endString		CMP		count1, count2			; compare the counters
				IT		HI
				MOVHI	count2, count1			; save the highest value
				MOV		count1, #0				; reset counter1
				
				LDRB	char2, [r1, #1]!		; load the next character of string2
				CMP		char2, #0				; check if string2 is finished
				BEQ		endLongestSub
				MOV		addr2, r1				; align string2 address
				
				MOV		addr1, r0				; reset string1 address
				LDRB	char1, [addr1]			; load the first character of string1
				B		loop

endLongestSub	MOV		r0, count2				; return count2

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
