section .data               
;Change Name and Surname with your data.
developer db "Pablo Apausa",0

;Constant that is also defined in C.
DIMMATRIX equ 5		

section .text

;Variables defined in Assembly language.
global developer                        

;Assembly language subroutines called from C.
global posCurScreenP2, updateColP2, updateMatrixBoardP2, getSecretPlayP2
global printSecretP2, checkSecretP2, printHitsP2, checkPlayP2, printMessageP2, playP2

;Global variables defined in C.
;None.

;C functions that are called from assembly code.
extern clearScreen_C,  gotoxyP2_C, printchP2_C, getchP2_C
extern printBoardP2_C, printMessageP2_C


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ATTENTION: Remember that in assembly language the variables and parameters 
;; of type 'char' must be assigned to records of type
;; BYTE (1 byte): al, ah, bl, bh, cl, ch, dl, dh, sil, dil, ..., r15b
;; those of type 'short' must be assigned to records of type
;; WORD (2 bytes): ax, bx, cx, dx, si, di, ...., r15w
;; those of type 'int' must be assigned to records of type
;; DWORD (4 bytes): eax, ebx, ecx, edx, esi, edi, ...., r15d
;; those of type 'long' must be assigned to records of type
;; QWORD (8 bytes): rax, rbx, rcx, rdx, rsi, rdi, ...., r15
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; a; ;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; The assembly subroutines you need to modify to implement pass parameter are:
;;   posCurScreenP2, updateColP2, updateMatrixBoardP2, getSecretPlayP2
;;   printSecretP2, checkSecretP2, printHitsP2.
;; The subroutine that must be modified:
;;   checkPlayP2.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; This subroutine is already done. YOU CANNOT MODIFY IT.
; Place the cursor at a position on the screen.  
; 
; Global variables :	
; None
; 
; Input parameters : 
; (rowScreen) : rdi(edi): Row of the screen where the cursor is placed.
; (colScreen) : rsi(esi): Column of the screen where the cursor is placed.
; 
; Output parameters: 
; None
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
gotoxyP2:
   push rbp
   mov  rbp, rsp
   ; We save the processor's registers' state because 
   ; the C functions do not keep the registers' state.
   push rax
   push rbx
   push rcx
   push rdx
   push rsi
   push rdi
   push r8
   push r9
   push r10
   push r11
   push r12
   push r13
   push r14
   push r15

   ; When we call the gotoxyP2_C function (int rowScreen, int colScreen) from assembly language
   ; the first parameter (rowScreen) must be passed through the rdi (edi) register, and
   ; the second parameter (colScreen) must be passed through the rsi (esi) register.
   call gotoxyP2_C
 
   ;restore the register's state that have been saved in the stack.
   pop r15
   pop r14
   pop r13
   pop r12
   pop r11
   pop r10
   pop r9
   pop r8
   pop rdi
   pop rsi
   pop rdx
   pop rcx
   pop rbx
   pop rax

   mov rsp, rbp
   pop rbp
   ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; This subroutine is already done. YOU CANNOT MODIFY IT.
; Show a character on the screen at the cursor position.
; 
; Global variables :	
; None
; 
; Input parameters : 
; (c): rdi(dil): Character to show.
; 
; Output parameters: 
; None
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
printchP2:
   push rbp
   mov  rbp, rsp
   ; We save the processor's registers' state because 
   ; the C functions do not keep the registers' state.
   push rax
   push rbx
   push rcx
   push rdx
   push rsi
   push rdi
   push r8
   push r9
   push r10
   push r11
   push r12
   push r13
   push r14
   push r15

   ; When we call the printchP2_C (char c) function from assembly language,
   ; parameter (c) must be passed through the rdi (dil) register.
   call printchP2_C
 
   ;restore the register's state that have been saved in the stack.
   pop r15
   pop r14
   pop r13
   pop r12
   pop r11
   pop r10
   pop r9
   pop r8
   pop rdi
   pop rsi
   pop rdx
   pop rcx
   pop rbx
   pop rax

   mov rsp, rbp
   pop rbp
   ret
   

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; This subroutine is already done. YOU CANNOT MODIFY IT.
; Read a character from the keyboard without displaying it 
; on the screen and return it.
; 
; Global variables :	
; None
; 
; Input parameters : 
; None
; 
; Output parameters: 
; (c): rax(al): Character read from the keyboard.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
getchP2:
   push rbp
   mov  rbp, rsp
   ; We save the processor's registers' state because 
   ; the C functions do not keep the registers' state.
   push rbx
   push rcx
   push rdx
   push rsi
   push rdi
   push r8
   push r9
   push r10
   push r11
   push r12
   push r13
   push r14
   push r15
   push rbp
   
   mov rax, 0
   ; When we call the getchP2_C function from assembly language
   ; return over the rax(al) register the read character.
   call getchP2_C
 
   ;restore the register's state that have been saved in the stack.
   pop rbp
   pop r15
   pop r14
   pop r13
   pop r12
   pop r11
   pop r10
   pop r9
   pop r8
   pop rdi
   pop rsi
   pop rdx
   pop rcx
   pop rbx
   
   mov rsp, rbp
   pop rbp
   ret 


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Place the cursor inside the board according to the position of the
; cursor (col), the remaining tries (tries) and the game state (state).
; If we are typing the secret code (state==0) we will place 
; the cursor in row 3 (rowScreen=3), if we are typing a try (state==1) 
; the row is calculated with the formula: (rowScreen=9+(DIMMATRIX-tries)*2).
; The column is calculated with the formula (colScreen= 8+(pos*2)).
; Place the cursor calling the gotoxyP2 subroutine.
; 
; Global variables :	
; None
; 
; Input parameters : 
; (state):rdi(edi):  State of the game.
; (tries):rsi(rsi):  Remaining tries.
; (col)  :rdx(edx):  Column where the cursor is.
; 
; Output parameters: 
; None
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
posCurScreenP2:
   push rbp
   mov  rbp, rsp

			push rdi ; store processor's register state
			push rsi 
   
			cmp edi, 0 ; if state == 0 then
			jne else
			mov rdi, 3 ; rowScreen = 3
			jmp endif
  
  else:	mov rdi, DIMMATRIX
			sub rdi, rsi
			shl rdi, 1
			add rdi, 9 ; else rowScreen = 9 + (DIMMATRIX - tries) * 2
			
  endif:	mov rsi, 0
			mov esi, edx
			shl esi, 1
			add esi, 8 ; colScreen = 8 + (col * 2);
			call gotoxyP2
			
   		pop rsi ; restore processor's register state
			pop rdi


   mov rsp, rbp
   pop rbp
   ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Update the column (col) where the cursor is.
; If we read (charac=='j') move left or (charac=='k') right
; update cursor position (col +/- 1)
; checking that it does not leave the array [0..DIMMATRIX-1].
; Return the updated value of (col).
;  
; Global variables :	
; None
; 
; Input parameters : 
; (charac): rdi(dil): Character read from the keyboard.
; (col)   : rsi(esi): Column where the cursor is.
; 
; Output parameters: 
; (col)   : rax(eax): Column where the cursor is.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
updateColP2:
   push rbp
   mov  rbp, rsp

			mov eax, esi
			cmp dil, 'j' ; if charac == 'j'
			jne tag1
			cmp esi, 0 ; and col > 0 then
			jle tag1
			dec eax ; col--
			
   tag1:	cmp dil, 'k' ; if charac == 'k'
			jne tag2
			cmp esi, DIMMATRIX - 1 ; and col < DIMMATRIX - 1 then
			jge tag2
			inc eax; col++
	
   tag2:
   
   
   mov rsp, rbp
   pop rbp
   ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Store the read character ['0' - '9'] (charac) in the matrix 
; (mSecretPlay) in the row indicated by the variable (state) and
; the column indicated by the variable (col).
; If (state==0) we will change the character read by a '*' 
; (charac = '*') for which the secret code we write is not seen.
; Finally, we show the character (charac) on the screen at the position 
; where the cursor is by calling the printchP2 subroutine.
; 
; Global variables :	
; None
; 
; Input parameters : 
; (charac)    : rdi(dil): Character to show.
; (mSecrePlay): rsi(rsi): Address of the matrix where we store the secret code and the try.
; (col)       : rdx(edx): Column where the cursor is.
; (state)     : rcx(ecx): State of the game.
; 
; Output parameters: 
; None
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
updateMatrixBoardP2:
   push rbp
   mov  rbp, rsp
   
   			push rdi ; store processor's register state
			push r15 
			
			mov r15, DIMMATRIX 
			imul r15d, ecx
			add r15d, edx 
			mov BYTE[rsi+r15], dil ; mSecretPlay[state][col] = charac
			cmp ecx, 0 ; if state state == 0 then
			jne tag3
			mov dil, '*' ; charac = '*'
			
  tag3: 	call printchP2 ; printchP2_C(charac)
			
			pop r15 ; restore processor's register state
			pop rdi


   mov rsp, rbp
   pop rbp
   ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Read the characters of the secret code or the try.
; While ENTER(10) or ESC(27) is not pressed do the following:
; · Place the cursor on the screen by calling the posCurScreenP2 subroutine,
; according to the value of the variables (col, tries and state).
; · Read a keyboard character by calling the getchP2 subroutine 
; which returns to (charac) the ASCII code of the character read.
; - If a 'j' (left) or a 'k' (right) has been read, move the
; cursor through the 5 positions of combination updating 
; the value of the variable (col) by calling the updateColP2 subroutine 
; depending on the variables (col, tries and state).
; - If a number ['0'-'9'] has been read we store it in the array
; (mSecretPlay) and we display it by calling the updateMatrixBoardP2 subroutine
; depending on the variables (charac, mSecretPlay, col and state).
; If ESC(27) has been pressed, set (state=-1) to indicate that we must exit.
; Pressing ENTER(10) will accept the combination as is.
; NOTE: Please note that if ENTER is pressed without having been assigned
; values in all positions of the combination, there will be positions
; which will be a space (value used to initialise the array).
; 
; Global variables :	
; None
; 
; Input parameters : 
; (mSecretPlay): rdi(rdi): Address of the matrix where we store the secret code and the try.
; (state)      : rsi(esi): State of the game.
; (tries)      : rdx(rdx): Remaining tries.
; 
; Output parameters: 
; (state)      : rax(eax): State of the game.
 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
getSecretPlayP2
   push rbp
   mov  rbp, rsp
   
			push rdi ; store processor's register state
			push rsi
			push rdx
			push rcx
			
			push r15
			push r14
			push r13
			push r12
			push r11
			
			mov r15, 0
			mov r14, rdx
			mov r13d, esi
			mov r12, 0
			mov r11, rdi

    tag4:	mov edi, r13d
			mov rsi, r14
			mov edx, r15d
			call posCurScreenP2 ; posCurScreenP2_C(state, tries, col);
			call getchP2
			mov r12b, al ; charac = getchP2_C();
			cmp r12b, 'j' ; if charac == 'j'
			je tag5
			cmp r12b, 'k' ; or charac == 'k' then
			jne tag6

   tag5:	mov dil, r12b
			mov esi, r15d
			call updateColP2
			mov r15d, eax ; col = updateColP2_C(charac, col);
			jmp tag7

   tag6:	cmp r12b, '0' ; else if charac >= '0'
			jl tag7
			cmp r12b, '9' ; and charac <= '9' then
			jg tag7
			mov dil, r12b
			mov edx, r15d
			mov ecx, r13d
			mov rsi, r11
			call updateMatrixBoardP2 ; updateMatrixBoardP2_C(charac, mSecretPlay, col, state);
	
   tag7:	cmp r12b, 10 ; while charac != 10
			je tag8
			cmp r12b, 27 ; and charac != 27 do
			je tag8 
			jmp tag4

   tag8:	mov eax, r13d
			cmp r12b, 27 ; if charac == 27 then
			jne tag9
			dec eax ; state--

   tag9:
			
			pop r11 ; restore processor's register state
			pop r12
			pop r13
			pop r14
			pop r15
			
			pop rcx
			pop rdx
			pop rsi
			pop rdi
			

   mov rsp, rbp
   pop rbp
   ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Verify that the secret code does not have the initial value (' '), 
; or repeated numbers.
; For each element of the row [0] of the matrix (mSecretPlay) check 
; that there is no space (' ') and that it is not repeated in the
; (from the next position to the current one until the end). 
; To indicate that the secret code is not correct we set (secretError=1).
; If the secret code is incorrect, set (state = 2) to request it again.
; else, the secret code is correct, set (state = 1) to read tries.
; Return the actual state of the game (state).
; 
; Global variables :
; None	
; 
; Input parameters : 
; (mSecretPlay): rdi(rdi): Address of the matrix where we store the secret code and the try.
; 
; Output parameters: 
; (state)      : rax(eax): State of the game.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  
checkSecretP2:
   push rbp
   mov  rbp, rsp
   
			push r15 ; store processor's register state
			push r14
			push r13
			push r12
			
			mov r15, 0
			mov r14, 0
			mov r13, 0
			mov r12, 0
			
   tag10:	cmp r15d, DIMMATRIX ; while i < DIMMATRIX do
			jge tag11
			cmp BYTE[rdi+r15], ' ' ; if mSecretPlay[0][i] == ' ' then
			jne tag12
			mov r14d, 1 ; secretError = 1;

   tag12:	mov r13d, r15d
			inc r13d ; j = i + 1
			
   tag13:	cmp r13d, DIMMATRIX ; while j < DIMMATRIX do
			jge tag14
			mov r12b, BYTE[rdi+r13]
			cmp BYTE[rdi+r15], r12b ; if mSecretPlay[0][i] == mSecretPlay[0][j]
			jne tag15
			mov r14d, 1 ; secretError = 1;

   tag15:	inc r13d ; j++
			jmp tag13
   
   tag14:	inc r15d ; i++
			jmp tag10
			
   tag11:	cmp r14d, 1 ; if secretError == 1 then
			jne tag16
			mov eax, 2 ; state = 2
			jmp tag17

   tag16:	mov eax, 1 ; else state = 1
   
   tag17:
			
			pop r12 ; restore processor's register state
			pop r13
			pop r14
			pop r15
	

   mov rsp, rbp
   pop rbp
   ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Show the secret code.
; Show the secret code (row 0 of the mSecretPlay matrix)
; at the top of the board when the game ends.
; To show the values, the gotoxyP2 subroutine must be called to
; place cursor, in row 3 (rowScreen=3) and from 
; column 8 (colScreen=8) and printchP2 to display each character.
; Increase the column (colScreen) by 2.
; 
; Global variables :	
; None
; 
; Input parameters : 
; (mSecretPlay): rdi(rdi): Address of the matrix where we store the secret code and the try.
; 
; Output parameters: 
; None
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  
printSecretP2:
   push rbp
   mov  rbp, rsp
   
			push rdi ; store processor's register state
			push rsi 
			
			push r15
			push r14
			push r13
			push r12
			
			mov r15, 0
			mov r14, 3
			mov r13, 8
			mov r12, rdi
			
   tag18:	cmp r15d, DIMMATRIX	; while i < DIMMATRIX do
			jge tag19
			mov edi, r14d
			mov esi, r13d
			call gotoxyP2 ; gotoxyP2_C(rowScreen, colScreen);
			mov dil, BYTE[r12+r15] ; charac = mSecretPlay[0][i];
			call printchP2 ; printchP2_C(charac);
			add r13d, 2 ; colScreen += 2; 
			inc r15d ; i++
			jmp tag18
			
   tag19:	
			
			pop r12 ; restore processor's register state
			pop r13
			pop r14
			pop r15
			
			pop rsi
			pop rdi
			

   mov rsp, rbp
   pop rbp
   ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Show the hits in place and out of place.
; Place the cursor in the row (rowScreen=9+(DIMMATRIX-tries)*2) and 
; column (colScreen=22) (right side of the board) to show 
; the hits on the game board.
; First, the hits in place (hX) are shown, as many 'X' as hits in place,
; and then, as many 'O' as hits out of place (hO) are shown.
; To display the hits, the gotoxyP2 subroutine must be called to 
; place the cursor and printchP2 to display the characters.
; Each time a hit is displayed, the column (colScreen) 
; must be incremented by 2.
; NOTE: (hX + hO must always be smaller or equal than DIMMATRIX).
; 
; Global variables :	
; None
; 
; Input parameters : 
; (hX)   : rdi(di) : Hits in place.
; (hO)   : rsi(si) : Hits out of place.
; (tries): rdx(rdx): Remaining tries.
; 
; Output parameters: 
; None
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
printHitsP2:
   push rbp
   mov  rbp, rsp

			push rdi ; store processor's register state
			push rsi 
			
			push r15
			push r14
			push r13
			push r12
			
			mov r15, 0
			mov r15w, di
			
			mov r14, 0
			mov r14w, si
			
			mov r13, DIMMATRIX
			sub r13, rdx
			shl r13, 1
			add r13, 9 ; rowScreen = 9 + (DIMMATRIX - tries) * 2;
			
			mov r12, 22 ; colScreen = 22;
	
   tag20:	cmp r15d, 0 ; while i > 0 do
			jle tag21
			mov edi, r13d
			mov esi, r12d
			call gotoxyP2 ; gotoxyP2_C(rowScreen,colScreen);
			mov dil, 'X'
			call printchP2 ; printchP2_C('X');
			add r12d, 2 ; colScreen += 2;
			dec r15d ; i--
			jmp tag20
			
   tag21:	mov r15, 0
			mov r15w, r14w
			
   tag22:	cmp r15d, 0 ; while i > 0 do
			jle tag23
			mov edi, r13d
			mov esi, r12d
			call gotoxyP2 ; gotoxyP2_C(rowScreen,colScreen);
			mov dil, 'O'
			call printchP2 ; printchP2_C('O');
			add r12d, 2 ; colScreen += 2;
			dec r15d ; i--
			jmp tag22
			
   tag23:	
   
			pop r12 ; restore processor's register state
			pop r13
			pop r14
			pop r15
			pop rsi
			pop rdi
			

   mov rsp, rbp
   pop rbp
   ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Count hits in place and out of place of the try with 
; respect to the secret code.
; To do the comparison you must do:
; For each element of the secret code (row 0 of the mSecretPlay matrix)
; (used as reference because it has no repeated values).
; Compare it to all elements of the play (row 1 of the mSecretPlay matrix).
; If an element of the secret code (mSecretPlay[0][i]) is equal to 
; the element of the same position in the play (mSecretPlay[1][i]) 
; it will be a hit in place 'X' and the hits in place variable must 
; be increased (hX++), otherwise, it will be a hit out of place 'O'  
; if an element of the secret combination (mSecretPlay[0][i]) is 
; equal to an element of the try mSecretPlay[1][j]), but they occupy 
; different positions (i !=j), the hits out of place variable must be
; increased (hO++) and stop going through the try positions to count
; each hit only once.
; If all the positions of the secret code and the try are the same 
; (hX=DIMMATRIX) we have won and the game state must be modified 
; to indicate this (state=3), otherwise, check if the attempts are
; over (tries==1), if attempts are over modify the state of the game
; to indicate this (state=4).
; Show the hits in place in the game board calling the printHitsP2 subroutine.
; Return the actual state of the game (state).
; 
; Global variables :	
; None
; 
; Input parameters : 
; (mSecretPlay): rdi(rdi): Address of the matrix where we store the secret code and the try.
; (state)      : rsi(esi): State of the game.
; (tries)      : rdx(rdx): Hits in place.
; 
; Output parameters: 
; (state)      : rax(eax): State of the game.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  
checkPlayP2:
   push rbp
   mov  rbp, rsp
   
			push rdi ; store processor's register state
			push rsi 
			
			push r15
			push r14
			push r13
			push r12
			push r11
			
			mov r15, 0
			mov r14, 0
			mov r13, 0
			mov r12, 0
			mov r11, 0
			
   tag24:	cmp r15d, DIMMATRIX ; while i < DIMMATRIX
			jge tag25
			mov r13b, BYTE[rdi+DIMMATRIX+r15]
			cmp BYTE[rdi+r15], r13b ; if mSecretPlay[0][i]==mSecretPlay[1][i] then
			jne tag26
			inc r11w ; hX++
			jmp tag27
	
   tag26:	mov r14, 0 ; else j = 0
   
   tag28:	cmp r14d, DIMMATRIX ; while j < DIMMATRIX do
			jge tag27
			mov r13b, BYTE[rdi+DIMMATRIX+r14]
			cmp BYTE[rdi+r15], r13b ; if mSecretPlay[0][i] == mSecretPlay[1][j] then
			jne tag29
			inc r12w ; hO++
			mov r14d, DIMMATRIX ; j = DIMMATRIX

   tag29:	inc r14d ; j++
			jmp tag28

   tag27:	inc r15d ; i++
			jmp tag24
	
   tag25:	mov eax, esi
			cmp r11w, DIMMATRIX ; if hX == DIMMATRIX then
			jne tag30
			mov eax, 3 ; state = 3;
			jmp tag31
			
   tag30:	cmp rdx, 1 ; if tries == 1 then
			jne tag31
			mov eax, 4 ; state = 4;
		
   tag31:	mov di, r11w
			mov si, r12w
			call printHitsP2
   
			pop r11 ; restore processor's register state
			pop r12
			pop r13
			pop r14
			pop r15
			
			pop rsi
			pop rdi
			
			
   mov rsp, rbp
   pop rbp
   ret



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Show a message at the bottom right of the game board according to 
; the value of the variable (state). 
; (state) -1: ESC was pressed to exit.
;          0: We are typing the secret code. 
;          1: We are typing a tray.
;          2: The secret code has spaces or repeated numbers.
;          3: Won, try = secret code.
;          4: The tries have run out.
;          
; Is expected to press a key to continue. 
; Show a message below on the  game board to indicate this, 
; and pressing a key, it is deleted.
; 
; Global variables :	
; None
; 
; Input parameters : 
; (state): rdi(edi): State of the game.
; 
; Output parameters: 
; None
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
printMessageP2:
   push rbp
   mov  rbp, rsp
   ;We save the processor's registers state that are modified in this
   ;subroutine and that are not use to return values.
   push rax
   push rbx
   push rcx
   push rdx
   push rsi
   push rdi
   push r8
   push r9
   push r10
   push r11
   push r12
   push r13
   push r14
   push r15

   ; When we call the printMessageP2_C(int state) function from assembly language,
   ; parameter (state) must be passed through the rdi (edi) register.
   call printMessageP2_C
 
   ;restore the register's state that have been saved in the stack.
   pop r15
   pop r14
   pop r13
   pop r12
   pop r11
   pop r10
   pop r9
   pop r8
   pop rdi
   pop rsi
   pop rdx
   pop rcx
   pop rbx
   pop rax

   mov rsp, rbp
   pop rbp
   ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; This subroutine is done. YOU CANNOT MODIFY IT.
; Main game subroutine.
; Read the secret code and verify that it is correct.
; Then a try is read, compare the try with 
; the secret code to check hits.
; Repeat the process until the secret code is guessed or 
; while there aren't tries left. If 'ESC' key is pressed while reading
; the secret code or a try, exit.
; 
; Pseudo-code:
; The player has 5 tries (tries=5) to guess the secret code, 
; the initial state of the game is 0 (state=0) and the cursor is set 
; to column 0 (col=0).
; Show the game board by calling the printBoardP2_C function.
; 
; While (state == 0) read the secret code or (state == 1) read
; the try:
;   - Show the remaining tries (tries) to guess the secret code, 
;     place the cursor in row 21, column 5 calling the gotoxyP2 
;     subroutine and show the character associated with the value of the 
;     variable (tries) adding '0' and calling the printchP2 subroutine.
;   - Show a message according to the state of the game (state) calling
;     the  printMessageP2 subroutine.
;   - Place the cursor on the game board calling the posCurBoardP2 subroutine.
;   - Read the characters of the secret combination or the try
;     and update the game state by calling the getSecretPlayP2 subroutine.
;   - If we are typing the secret code (state==0), verify
;     that is correct by calling the checkSecretP2 subroutine.
;     Else, if we are typing a try (state==1) check
;     hits of the try calling the checkPlayP2 subroutine,
;     decrease tries (tries). Initialize the try that we have saved 
;     in row 1 of the array mSecretPlay with spaces (' ') 
;     to be able to enter a new try.
; 
; Finally, show the remaining tries (tries) to guess the 
; secret code, place the cursor in row 21, column 5 by calling the 
; gotoxyP2 subroutine and show the character associated with the 
; value of the variable (tries) by adding '0' and calling the 
; printchP2 subroutine, show the secret code by calling the
; printSecretP2 subroutine and finally show the message indicating the 
; reason calling the printMessageP2 subroutine.
; Game is over.
; 
; Global variables :	
; None
; 
; Input parameters : 
; (mSecretPlay): rdi(rdi): Address of the matrix where we store the secret code and the try.
; 
; Output parameters: 
; None
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  
playP2:
   push rbp
   mov  rbp, rsp 
   ;We save the processor's registers state that are modified in this
   ;subroutine and that are not use to return values.
   push rax
   push rbx
   push rcx
   push rdx
   push rsi
   push rdi
   push r8
   push r9
   push r10
   push r11
   push r12
   
   push rdi
   mov  edi, 5
   call printBoardP2_C        ;printBoardP2_C(tries);
   pop  rdi

   mov  rbx, rdi              ;mSecretPlay
   mov  r10d, 0               ;col = 0;    //Column where the cursor is placed.
   mov  r11d, 0               ;state=0;    //State of the game.
   mov  r12 , 5               ;tries=5;    //Remaining tries.
   
   p2_while:
   cmp r11d, 0                ;while (state == 0 
   je  p2_whileOk
   cmp r11d, 1                ;|| state==1) {
   jne p2_endwhile
     p2_whileOk:
     
     mov edi, 21
     mov esi, 5
     call gotoxyP2            ;gotoxyP2_C(21,5);
     mov rdi, r12
     add dil, '0' 
     call printchP2           ;printchP2_C(tries + '0');
     mov edi, r11d
     call printMessageP2      ;printMessageP2_C(state);
     mov rsi, r12
     mov edx, r10d
     
     mov  edi, r11d
     mov  rsi, r12
     mov  edx , r10d
     call posCurScreenP2       ;posCurScreenP2_C(state, tries, col);
     
     mov rdi, rbx
     mov esi, r11d
     mov rdx, r12    
     call getSecretPlayP2     ;state = getSecretPlayP2_C(mSecretPlay, state, tries);
	 mov r11d, eax
	 
	 p2_if1:
	 cmp r11d, 0              ;if (state==0) {
	 jne p2_else1
	   mov  rdi, rbx
       call checkSecretP2     ;state = checkSecretP2_C(mSecretPlay);
       mov r11d, eax
       jmp p2_endif1          ;}
     p2_else1:                ;} else {
       p2_if2:
       cmp r11d, 1            ;if (state==1) {
	   jne p2_endif2
	     mov rdi, rbx
	     mov esi, r11d
	     mov rdx, r12
         call checkPlayP2     ;state = checkPlayP2_C(mSecretPlay, state, tries);
         mov r11d, eax
         dec r12              ;tries --;
       p2_endif2:             ;}
       mov rcx, 0             ;i=0;
       p2_for:                ;for (
       cmp rcx, DIMMATRIX
       jge p2_endfor          ;i<DIMMATRIX;i++) {
		 mov BYTE[rbx+DIMMATRIX+rcx], ' '  ;mSecretPlay[1][i]=' ';
		 inc rcx              ;i++;
		 jmp p2_for
	   p2_endfor:             ;}
     p2_endif1:               ;}
     jmp p2_while
   p2_endwhile:               ;}
     
   mov  edi, 21
   mov  esi, 5
   call gotoxyP2              ;gotoxyP2_C(21,5);
   mov  rdi, r12
   add  dil, '0'
   call printchP2             ;printchP2_C(tries + '0');
   mov  rdi, rbx
   call printSecretP2         ;printSecretP2_C(mSecretPlay);
   mov  edi, r11d
   call printMessageP2        ;printMessage_C(state);
   
   p2_end:
   ;restore the register's state that have been saved in the stack.
   pop r12
   pop r11
   pop r10
   pop r9
   pop r8
   pop rdi
   pop rsi
   pop rdx
   pop rcx
   pop rbx
   pop rax

   mov rsp, rbp
   pop rbp
   ret
