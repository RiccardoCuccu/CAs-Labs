; Write a program in 8086 assembly to
; 1) Read in input a short text of 4 lines, each of these lines long from 20 to 50 characters
; 2) Count number of occurrences of the letters
; 3) Apply a cryptographic algorithm

	.model small
	.stack
	
	dim1	EQU		20
	dim2	EQU		30
	dim3	EQU		50
	k1		EQU		1
	k2		EQU		2
	k3		EQU		3
	k4		EQU		4
	
	LF		EQU		10		; line feed
	CR 		EQU		13		; carriage return
	
	.data
	
	MSG0    DB      CR, LF, "$"        
	MSGS    DB      "Programma avviato", CR, LF, "$"
	MSGE    DB      "Programma terminato", CR, LF, "$"
	MSG1    DB      "Inserire la riga numero uno, deve contenere tra i 20 e i 50 caratteri:", CR, LF, "> ", "$"
	MSG2    DB      "Inserire la riga numero due, deve contenere tra i 20 e i 50 caratteri:", CR, LF, "> ", "$"
	MSG3    DB      "Inserire la riga numero tre, deve contenere tra i 20 e i 50 caratteri:", CR, LF, "> ", "$"
	MSG4    DB      "Inserire la riga numero quattro, deve contenere tra i 20 e i 50 caratteri:", CR, LF, "> ", "$"  
	MSG5    DB      "Calcolo delle occorrenze in corso", CR, LF, "$"
	MSG6    DB      "Carattere con il maggior numero di occorrenze", CR, LF, "> ", "$"
	MSG7    DB      "Caratteri con un numero di occorrenze >= a MAX/2", CR, LF, "> ", "$"
	MSGK1   DB      "Cifratura di Cesare con k=1", CR, LF, "> ", "$"
	MSGK2   DB      "Cifratura di Cesare con k=2", CR, LF, "> ", "$"
	MSGK3   DB      "Cifratura di Cesare con k=3", CR, LF, "> ", "$"
	MSGK4   DB      "Cifratura di Cesare con k=4", CR, LF, "> ", "$"
	
	first_line	DB 50 DUP(0)
	second_line	DB 50 DUP(0)
	third_line	DB 50 DUP(0)
	fourth_line	DB 50 DUP(0)
	upper_char	DB 26 DUP(0)		; A-Z (65-90)
	lower_char	DB 26 DUP(0)		; a-z (97-122)
	
	.code	

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		
store_char proc near		        ; STORE CHARACTERS
		push DI
		mov CX, dim1                ; store in CX 20
		mov BX, dim2                ; store in BX 30
		mov AH, 1                   ; reading
store1: 
		int 21H                     ; interrupt
		mov [DI], AL                ; save character
		inc DI                      ; increment index
		dec CX                      ; decrement CX
		cmp CX, 0                   ; check if it is the 20th character
		jne store1                  ; if CX is not zero go to "store1"
		mov CL, 13                  ; store in CL the ascii code of ENTER
		cmp [DI-1], CL              ; check if the twentieth character is ENTER
		je store3                   ; if the character is ENTER go to "store3"
store2: 
		int 21H                     ; interrupt
		mov [DI], AL                ; save character
		inc DI                      ; increment index
		dec BX                      ; decrement BX
		cmp [DI-1], CL              ; check if the character is ENTER
		je store3                   ; if the character is ENTER go to "store3"
		cmp BX, 0                   ; check if it is the 50th character
		jne store2	                ; if BX is not zero go to "store2"
store3:	
		call back
		pop DI
		ret
store_char endp	

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

print_char proc near                ; PRINT CHARACTERS
		push DI
		mov CX, dim3                ; store in BX 50
		sub CX, BX                  ; calculates the number of characters entered
		mov AH, 2                   ; writing
printl2:
		mov DL, [DI]                ; load character
		int 21H                     ; interrupt
		inc DI                      ; increment index
		dec CX                      ; decrement CX
		cmp CX, 0                   ; check if it is the last character
		jne printl2	                ; if CX is not zero go to "printl2"
		call back                   ; new line
		pop DI
		ret
print_char endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

count proc near                     ; COUNT CHARACTERS
		push DI
		push BX
		push CX
		push DX
		
		lea DX, MSG5            	; "Calcolo delle occorrenze in corso"
		call prints         		; print string
		
		mov BH, 0
		mov CX, dim3                ; store in CX 50
		sub CX, BX                  ; calculates the number of characters entered
		
count0:
		cmp [DI], 65                ; check if the ASCII code is greater than 65
		jl count99                  ; if it is lower go to "count99"
		cmp [DI], 122               ; check if the ASCII code is lower than 122
		jg count99                  ; if it is greater go to "count99"
		cmp [DI], 90                ; check if the ASCII code is lower than 90
		jle count1                  ; if it is lower go to "count1" because it is an uppercase
		cmp [DI], 97                ; check if the ASCII code is greater than 97
		jge count2                  ; if it is greater go to "count2" because it is a lowercase
		jmp count99                 ; in any other case it is not a letter, than go to "count99"
count1:	
		mov BL, [DI]
		sub BL, 65                  ; convert the ASCII code of the uppercase to the position within the vector
		inc upper_char[BX]
		jmp count99
count2: 
		mov BL, [DI]
		sub BL, 97                  ; convert the ASCII code of the lowercase to the position within the vector 
		inc lower_char[BX]
		;jmp count99
				
count99:
		inc DI                      ; increment index
		dec CX                      ; decrement counter
		cmp CX, 0                   ; check if it is the last character
		jne count0	                ; if CX is not zero go to "count0" 
		
		pop DX
		pop CX
		pop BX	    
		pop DI
		ret
count endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

print_max proc near                 ; PRINT MAX CHARACTER
		push AX
		push BX
		push DX
		push DI
		
		call max_char               ; AL=number of occurrence ; BX=index of character
		
		lea DX, MSG6            	; "Carattere con MAX numero di occorrenze"
		call prints         		; print string

upper_test:
		lea DI, upper_char          ; load effective address of upper_char
		cmp BX, DI                  ; check if the character is out of the vector
		jl lower_test               ; if BX is lower than DI go to "lower_test"
		add DI, 26                  ; add the dimension of the vector to DI
		cmp BX, DI                  ; check if the character is out of the vector
		jge lower_test              ; if BX is greater than DI go to "lower_test"
		lea DI, upper_char          ; load effective address of upper_char
		sub BX, DI                  ; calculate the position in the vector
		add BX, 41H                 ; convert to ASCII
		mov DL, BL                  ; move digit to DL
		mov BL, AL                  ; copy the number of occurrence to BL
		mov AH, 2                   ; writing
		int 21H                     ; interrupt
		mov DL, 3DH                 ; move "=" to DL
		int 21H                     ; interrupt
		mov AL, BL                  ; move the number of occurrence to DL
		call print_num
		jmp end_test

lower_test:        
		lea DI, lower_char
		cmp BX, DI                  ; check if the character is out of the vector
		jl end_test                 ; if BX is lower than DI go to "lower_test"
		add DI, 26                  ; add the dimension of the vector to DI
		cmp BX, DI                  ; check if the character is out of the vector
		jg end_test                 ; if BX is greater than DI go to "lower_test"
		lea DI, lower_char          ; load effective address of lower_char
		sub BX, DI                  ; calculate the position in the vector
		add BX, 61H                 ; convert to ASCII
		mov DL, BL                  ; move digit to DL
		mov BL, AL                  ; copy the number of occurrence to BL
		mov AH, 2                   ; writing
		int 21H                     ; interrupt
		mov DL, 3DH                 ; move "=" to DL
		int 21H                     ; interrupt
		mov AL, BL                  ; move the number of occurrence to AL
		call print_num
			 
end_test:
		call back
		call print_submax
			   
		pop DI
		pop DX
		pop BX        
		pop AX
		ret
print_max endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

print_submax proc near              ; PRINT MAX/2 CHARACTERS
		push AX
		push BX
		push CX
		push DI
		
		lea DX, MSG7            	; "Caratteri con un numero di occorrenze >= a MAX/2"
		call prints         		; print string
		
		mov AL, BL                  ; move the maximum occurrences in to AL
		xor AH, AH                  ; clean AH
		mov BL, 2                   ; move the divisor in to BL
		div BL                      ; division by 2
		mov BL, AL                  ; move the result in to BL
		
		cmp AH, 0                   ; check if there is rest
		je start_comp               ; if the rest is zero it is an even number 
		add BL, 1                   ; adds one to the odd number
		
start_comp:
		mov CL, 0                   ; set counter
		lea DI, lower_char
compare_lower:
		cmp CL, 26                  ; check if the vector is ended
		je end_lower                ; if CX is zero than go to "end_lower"
		cmp [DI], BL
		jl check_lower
		mov DL, CL                  ; move digit to DL
		add DL, 61H                 ; convert to ASCII
		mov AH, 2                   ; writing
		int 21H                     ; interrupt
		mov DL, 3DH                 ; move "=" to DL
		int 21H                     ; interrupt
		mov AL, [DI]                ; move the number of occurrence to DL
		call print_num
		mov DL, 09H                 ; move "\TAB" to DL
		int 21H                     ; interrupt
		
check_lower:  
		inc DI                      ; increment index
		inc CL                      ; decrement CL
		jmp compare_lower           ; go to "compare_lower"

end_lower:
		mov CL, 0
		lea DI, upper_char
compare_upper:
		cmp CL, 26                  ; check if the vector is ended
		je end_upper                ; if CX is zero than go to "end_upper"
		cmp [DI], BL
		jl check_upper
		mov DL, CL                  ; move digit to DL
		add DL, 41H                 ; convert to ASCII
		mov AH, 2                   ; writing
		int 21H                     ; interrupt
		mov DL, 3DH                 ; move "=" to DL
		int 21H                     ; interrupt
		mov AL, [DI]                ; move the number of occurrence to DL
		call print_num
		mov DL, 09H                 ; move "\TAB" to DL
		int 21H                     ; interrupt
		
check_upper:  
		inc DI                      ; increment index
		inc CL                      ; decrement CL
		jmp compare_upper           ; go to "compare_upper"
			 
end_upper:        
		call back                   ; new line

		pop DI
		pop CX
		pop BX        
		pop AX
		ret
print_submax endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

max_char proc near
		push DI
		
		lea DI, upper_char          ; load effective address of upper_char
		mov AL, [DI]                ; move the first value into AL
		call max_char_single        ; analyze the uppercase vector
		
		lea DI, lower_char          ; load effective address of lower_char
		call max_char_single        ; analyze the lowercase vector
		
		pop DI
		ret
max_char endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

max_char_single proc near
		push DI
		push CX
		
		mov CX, 26                   ; load the dimension of the vector
		
start_compare:
		cmp CX, 0                    ; check if the vector is ended
		je end_compare               ; if CX is zero than go to "end_compare"
		cmp AL, [DI]                 ; check if the value in AL is grater than the value in [DI]
		jg up_compare                ; if value in AL is grater than the value in [DI] go to "up_compare"
		mov AL, [DI]                 ; substitute the character
		mov BX, DI                   ; save the index of the character
		
up_compare:
		inc DI                       ; increment index
		dec CX                       ; decrement CX
		jmp start_compare            ; go to "start_compare"
		
end_compare:        
		pop CX
		pop DI
		ret
max_char_single endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

print_num proc near                 ; PRINT NUMBERS
		push AX
		push BX
		push DX
		
		cmp AL, 10                  ; check if the number to print is less than 10
		jb digit                    ; if AL is less than 10 go to "digit"
		xor AH, AH                  ; reset the register
		mov BL, 10                  ; divisor
		div BL                      ; AL=AX/divisor (AH=rest)
		call print_num              ; recursive iteration
		mov AL, AH                  ; move the rest
			  
digit:  push AX
		mov AH, 2                   ; writing
		mov DL, AL                  ; move digit to DL
		add DL, 30H                 ; convert to ASCII
		int 21H                     ; interrupt
		pop AX
				
		pop DX
		pop BX
		pop AX
		ret
print_num endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

prints  proc                    	; PRINT STRING
		push    AX	
				
		mov     AH, 09H         	; show string
		int     21H             	; interrupt
	
		pop     AX					; pop
		ret
prints  endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

crypto proc near                    ; CAESAR CIPHER
		push DI
		push AX
		push BX
		push DX
		
		mov BL, dim3
		mov BH, 0     

start: 
		cmp [DI], 65                ; check if the ASCII code is greater than 65
		jl skip                     ; if it is lower go to "skip"
		cmp [DI], 122               ; check if the ASCII code is lower than 122
		jg skip                     ; if it is greater go to "skip"
		cmp [DI], 90                ; check if the ASCII code is lower than 90
		jle upp_cipher              ; if it is lower go to "count1" because it is an uppercase
		cmp [DI], 97                ; check if the ASCII code is greater than 97
		jge low_cipher              ; if it is greater go to "count2" because it is a lowercase
		jmp skip                    ; in any other case it is not a letter, than go to "skip"
		
upp_cipher:                         ; 65-90
		mov DL, [DI]
		add DL, CL                  ; add the parameter k
		cmp DL, 90                  ; check if the ASCII code is still an uppercase
		jle print                   ; if it is still an uppercase go to "print"
		add DL, 6                   ; move to lowercase
		jmp print                   ; go to "print"
		
low_cipher:                         ; 97-122
		mov DL, [DI]
		add DL, CL                  ; add the parameter k
		cmp DL, 122                 ; check if the ASCII code is still a lowercase
		jle print                   ; if it is still a lowercase go to "print"
		sub DL, 58                  ; move to uppercase
		jmp print                   ; go to "print"

print:  mov AH, 2                   ; writing
		int 21H                     ; interrupt
		
skip:   inc DI                      ; increment index
		inc DH                      ; increment counter
		cmp DH, DL
		jl start
		call back                   ; new line

		pop DX
		pop BX
		pop AX
		pop DI
		ret
crypto endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

back proc near                      ; NEW LINE
		push AX
		push DX
		
		mov AH, 2                   ; writing
		mov DL, 13                  ; carriage return
		int 21H                     ; interrupt
		mov DL, 10                  ; line feed
		int 21H                     ; interrupt
		
		pop DX
		pop AX
		ret
back endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

clean proc near                     ; CLEAN VECTORS
		push AX
		push DI
		
		lea DI, upper_char          ; load effective address of upper_char
		mov AL, 0                   ; set counter
clean_up:
		mov [DI], 0                 ; set to 0 the vector
		inc DI                      ; increment index
		inc AL                      ; increment counter
		cmp AL, 26                  ; check if the vector is ended
		jl clean_up                 ; if it is not ended go to "clean_up"
		
		mov AL, 0                   ; set counter
		lea DI, lower_char          ; load effective address of lower_char
clean_low:
		mov [DI], 0                 ; set to 0 the vector
		inc DI                      ; increment index
		inc AL                      ; increment counter
		cmp AL, 26                  ; check if the vector is ended
		jl clean_low                ; if it is not ended go to "clean_up"
		
		pop DI
		pop AX
		ret
clean endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	 
   
	.startup
	
	lea DX, MSGS            	; "Programma avviato"
	call prints         		; print string
	call back                   ; new line
	
	lea DX, MSG1            	; "Inserire stringa 1"
	call prints         		; print string
	lea DI, first_line          ; load effective address of first_line
	call store_char             ; store characters
	call count                  ; count occurrences
	call print_max              ; print max and max/2 characters
	mov CL, k1                  ; store in CL 1
	lea DI, first_line          ; load effective address of first_line
	lea DX, MSGK1            	; "Cifratura di Cesare con k=1"
	call prints         		; print string
	call crypto                 ; caesar cipher
	
	call clean                  ; clean the vectors
	call back                   ; new line
	lea DX, MSG2            	; "Inserire stringa 2"
	call prints         		; print string	
	lea DI, second_line         ; load effective address of second_line
	call store_char             ; store characters
	call count                  ; count occurrences
	call print_max              ; print max and max/2 characters
	mov CL, k2                  ; store in CL 2
	lea DI, second_line         ; load effective address of second_line
	lea DX, MSGK2            	; "Cifratura di Cesare con k=2"
	call prints         		; print string
	call crypto                 ; caesar cipher

	call clean                  ; clean the vectors    
	call back                   ; new line
	lea DX, MSG3            	; "Inserire stringa 3"
	call prints         		; print string
	lea DI, third_line          ; load effective address of third_line
	call store_char             ; store characters
	call count                  ; count occurrences
	call print_max              ; print max and max/2 characters
	mov CL, k3                  ; store in CL 3
	lea DI, third_line          ; load effective address of third_line
	lea DX, MSGK3            	; "Cifratura di Cesare con k=3"
	call prints         		; print string
	call crypto                 ; caesar cipher         

	call clean                  ; clean the vectors	
	call back                   ; new line
	lea DX, MSG4            	; "Inserire stringa 4"
	call prints         		; print string
	lea DI, fourth_line         ; load effective address of fourth_line
	call store_char             ; store characters
	call count                  ; count occurrences
	call print_max              ; print max and max/2 characters
	mov CL, k4                  ; store in CL 4
	lea DI, fourth_line         ; load effective address of fourth_line
	lea DX, MSGK4            	; "Cifratura di Cesare con k=4"
	call prints         		; print string
	call crypto                 ; caesar cipher
	
	call back                   ; new line
	lea DX, MSGE            	; "Programma terminato"
	call prints         		; print string
	
	.exit
	end