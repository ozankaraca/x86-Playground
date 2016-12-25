
name "Operations&Sorting on Array Regarding Parity"

org 100h


mov di, 1000h			;Get the string size
mov ds:[di], 12



mov cx ,ds:[di] 
mov di, 2000h

         mov ax, 50
    
    writeArray:
        
        mov ds:[di], ax
        inc di
        dec ax
        
        Loop writeArray:    ;Write the numbers on DS:2000h

mov ax, 0

mov di, 1000h
mov cx, ds:[di]
        
mov di, 2000h
mov bp, 3000h
    
	checkParity:	
        mov al, ds:[di]
                   
        test ax, 1		;Check the last bit
						;If odd write the same, if even write the half of it to the 3000h
        JNP Final 		
        
        mov bx, 2
        div bx
    
		Final:
        
        mov ds:[bp], ax
        inc di
        inc bp
        
        Loop checkParity
        
        
        
mov di, 1000h        
mov cx, ds:[1000h]
mov di, 3000h
mov bp, 4000h
mov ax, 0

copyArray:			;Copy same array on 4000h to sort
      
      mov al, ds:[di]
      
      mov ds:[bp], al
      
      inc di
      inc bp
    Loop copyArray    


mov di, 1000h
mov ax, ds:[di]
mov di, 4000h

bsort:  pusha
        xchg    cx, ax          ;get size of array N
        dec     cx              ;for J:= N-1 downto 0
bs10:   xor     bx, bx          ;for I:= 0 to J-1
bs20:   mov     ax, [bx+di]
        cmp     al, ah          ;if A(I) > A(I+1) then
        jbe     bs30
         xchg   al, ah          ; swap bytes
         mov    [bx+di], ax
bs30:   inc     bx              ;next I
        cmp     bx, cx
        jb      bs20
        loop    bs10
        popa
        





