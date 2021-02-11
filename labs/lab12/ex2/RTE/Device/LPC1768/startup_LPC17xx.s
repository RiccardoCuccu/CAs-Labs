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

                AREA inputData, DATA, READONLY
N               EQU     0x0000001E                ; 30 elements
M               EQU     0x00000004                ; 4 elements

i               RN       3
middle          RN       4
first           RN       5
last            RN       6
temp_price_list RN       7
temp_item_list  RN       8
partial_cost    RN       9
total_cost      RN      10
value_catalogue RN      11
value_list      RN      12

Price_list      DCD 0x004, 20, 0x006, 15, 0x007, 10, 0x00A, 5, 0x010, 8
                DCD 0x012, 7, 0x016, 22, 0x017, 17, 0x018, 38, 0x01A, 22
                DCD 0x01B, 34, 0x01E, 11, 0x022, 3, 0x023, 9, 0x025, 40
                DCD 0x027, 12, 0x028, 11, 0x02C, 45, 0x02D, 10, 0x031, 40
                DCD 0x033, 45, 0x035, 9, 0x036, 11, 0x039, 12, 0x03C, 19
                DCD 0x03E, 1, 0x041, 20, 0x042, 30, 0x045, 12, 0x047, 7

Item_list       DCD 0x022, 4, 0x006, 1, 0x03E, 10, 0x017, 2     ; total cost is 71 (0x47)


                AREA    |.text|, CODE, READONLY

; Reset Handler

Reset_Handler   PROC
                EXPORT  Reset_Handler             [WEAK]
                
                ; item 1
                ;EXTERN  sequentialSearch
                ;LDR     r0, =Price_list
                ;LDR     r1, =Item_list
                ;BL      sequentialSearch
                
                ; item 2
                ;EXTERN  binarySearch
                LDR     r0, =Price_list
                LDR     r1, =Item_list 
                BL      binarySearch
                
                ; remove comments to solve item 3
                ;IMPORT  SystemInit
                ;IMPORT  __main
                ;LDR     R0, =SystemInit
                ;BLX     R0
                ;LDR     R0, =__main
                ;BX      R0

stop            B       stop
                ENDP

;/******************** Sequential Search ********************/

sequentialSearch PROC
                PUSH    {LR}               
                MOV     temp_price_list, r0                     ; copy the address of Price_list
                MOV     temp_item_list, r1                      ; copy the address of Item_list
                MOV     i, #0                                   ; initialize i
                MOV     partial_cost, #0                        ; initialize partial_cost
                MOV     total_cost, #0                          ; initialize total_cost
                BL      outside_seq_while                       ; call the ouside while
                MOV     r0, total_cost                          ; store the result into r0
                POP     {PC}
                ENDP


outside_seq_while PROC
                PUSH    {LR}
new_item_seq    
                CMP     i, #M                                   ; check if the loop has ended
                BEQ     end_outside_seq
                LDR     value_list, [temp_item_list]            ; load the code of an item from Item_list
                BL      inside_seq_while                        ; call the inside while
                MOV     temp_price_list, r0                     ; reset the address of Price_list
                ADD     temp_item_list, temp_item_list, #8      ; updates the address for the new item
                ADD     i, i, #1                                ; increment index i
                B       new_item_seq
end_outside_seq
                POP     {PC}
                ENDP


inside_seq_while PROC
                PUSH    {LR}
compare_element
                LDR     value_catalogue, [temp_price_list]      ; load the code of an item from Price_list
                CMP     value_catalogue, value_list             ; compare the codes of the two elements
                BNE     increment_element
                LDR     partial_cost, [temp_price_list, #4]     ; load the cost of the single item
                LDR     r4, [temp_item_list, #4]                ; load the number of items required
                MUL     partial_cost, partial_cost, r4          ; computes the partial cost
                ADD     total_cost, total_cost, partial_cost    ; update total cost
                B       end_inside_seq
increment_element
                ADD     temp_price_list, temp_price_list, #8    ; updates the address for the new item
                B       compare_element
end_inside_seq
                POP     {PC}
                ENDP

;/******************** Binary Search ********************/

binarySearch PROC
                PUSH    {LR}
                MOV     temp_price_list, r0                     ; copy the address of Price_list
                MOV     temp_item_list, r1                      ; copy the address of Item_list
                MOV     i, #0                                   ; initialize i
                MOV     partial_cost, #0                        ; initialize partial_cost
                MOV     total_cost, #0                          ; initialize total_cost
                BL      outside_bin_while                       ; call the outside while
                MOV     r0, total_cost                          ; store the result into r0
                POP     {PC}
                ENDP


outside_bin_while PROC
                PUSH    {LR}
new_item_bin
                CMP     i, #M                                   ; check if the loop has ended
                BEQ     end_outside_bin
                MOV     first, #0                               ; reset first to zero
                MOV     last, #N                                ; reset last to N-1
                SUB     last, last, #1
                LDR     value_list, [temp_item_list]            ; load the code of an item from Item_list
                BL      inside_bin_while                        ; call the inside while
                ADD     temp_item_list, temp_item_list, #8      ; updates the address for the new item
                ADD     i, i, #1                                ; increment index i
                B       new_item_bin
end_outside_bin
                POP     {PC}
                ENDP


inside_bin_while PROC
                PUSH    {r3, LR}
compare_middle
                ADD     middle, first, last                     ; updates the middle value
                MOV     r3, #2                                  ; middle = (first + last) / 2
                UDIV    middle, middle, r3
                MOV     r3, #8                                  ; convert middle value to an offset
                MUL     r3, middle, r3
                LDR     value_catalogue, [r0, r3]               ; load the code of an item from Price_list
                CMP     value_catalogue, value_list             ; compare the codes of the two elements
                BNE     shift_middle
                ADD     r3, r3, #4                              ; add to the middle offset the value #4 to extract the cost of the single item
                LDR     partial_cost, [r0, r3]                  ; load the cost of the single item
                LDR     r3, [temp_item_list, #4]                ; load the number of items required
                MUL     partial_cost, partial_cost, r3          ; computes the partial cost
                ADD     total_cost, total_cost, partial_cost    ; update total cost
                MOV     partial_cost, #0                        ; reset partial cost
                B       end_inside_bin            
shift_middle
                CMP     value_catalogue, value_list             ; compare again the codes of the two elements
                ITE     GE                                      ; if-then-else
                SUBGE   last, middle, #1                        ; if value_catalogue > value_list than last = middle - 1
                ADDLT   first, middle, #1                       ; if value_catalogue < value_list than first = middle + 1
                B       compare_middle
end_inside_bin
                POP     {r3, PC}
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
