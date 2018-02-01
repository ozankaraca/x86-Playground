#start=led_display.exe#

name "FinalProject"


org  100h



print_new_line macro	;A macro for creating a new line
    mov dl, 13
    mov ah, 2
    int 21h   
    mov dl, 10
    mov ah, 2
    int 21h      
endm


xor ax, ax
out 199, ax ; clear the timer

pusha
mov dx, offset welcome  ;Print welcome message
call display
popa
print_new_line


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
        

call timer

pusha
mov dx, offset StartMSG ;Status: Timer has been started
call display
popa
print_new_line

GO:
call timer

mov ax, bool[0]
cmp ax, 1               ;If it's the first time, skip the failed message
jz First 

call timer              

pusha
mov dx, offset lfailed  ;Process has been failed, display the status
call display
popa
print_new_line
print_new_line        

call timer        

First:
call isFirst
mov ax, countdown[0]    ;Check if we have time
cmp ax, 0
jg mainProcess
mov dx, offset notime   ;if we have no time, display time out msg
call display
print_new_line
ret
mainProcess:
call timer
call randomnumber
xor ax,ax               ;clear ax
mov ax, randomkey[0]    ;load R to ax
and ax,5                ;ax=key=R and 5
mov key[0], ax          ;store R and 5 to the key
mov bx, randomkey[0]    ;bx=R
mul bx                  ;ax=key*r
add ax, 5               ;ax=key*r+5
mov bx, 5               
div bx
mov ax, dx              ;ax=key1=(key*r+5) mod 5
xor dx,dx               ;clear dx
cmp ax, 0
jnz GO                  ;if key1==0 continue
pusha
mov dx, offset l1success
call display            ;Display 1st lock success msg
print_new_line
popa
call timer

xor ax,ax
xor bx,bx               ;clear ax and bx
mov bx, randomkey[0]    ;bx=R
mov ax, key[0]          ;ax=key
OR ax, bx               ;key2=ax or bx
cmp ax, 0
je GO                   ;if key2!=0 continue
pusha
mov dx, offset l2success
call display            ;Display 2nd lock success msg
print_new_line
popa                    
call timer
xor ax, ax
xor bx, bx              ;clear ax and bx
mov bx, randomkey[0]    ;bx=R
mov ax, key[0]          ;ax=key
add ax, bx              ;ax=key+r
SAR ax, 2               ;sar(key+R), 2
cmp ax, 0
je GO                   ;if key3!=0 continue
pusha
mov dx, offset l3success
call display            ;Display 3rd lock success msg
print_new_line
popa
call timer
xor ax, ax
xor bx, bx              ;clear ax and bx
mov bx, randomkey[0]    ;bx=R
mov ax, key[0]          ;ax=key
XOR ax, bx              ;key4=ax= xor key R
cmp ax, 0               
je GO                   ;if key4!=0 continue
pusha
mov dx, offset l4success
call display            ;Display 4th lock success msg
print_new_line
popa
call timer
xor ax, ax              ;clear ax and bx
xor bx, bx
mov bx, randomkey[0]    ;bx=R
mov ax, key[0]          ;ax=key
mul bx                  ;ax=key5=key*r
cmp ax, 0
jne GO                  ;if key5==0 continue
pusha
mov dx, offset l5success
call display            ;display the 5th lock success msg
print_new_line
ret






isFirst PROC
    pusha
    mov ax, bool[0]       ;at the first round of process, it will decrease the bool value
    dec ax
    mov bool[0], ax
    popa
isFirst ENDP    





TIMER PROC
pusha
mov ax, countdown[0]
out 199, ax
dec ax
mov countdown[0], ax
pusha
MOV CX, 0FFH
WAIT:
LOOP WAIT
popa
popa
ret
TIMER ENDP
 
DISPLAY proc
 MOV AH,09
 INT 21h
 RET
DISPLAY ENDP

RANDOMNUMBER PROC
pusha
MOV AH, 00h ; interrupts to get system time
INT 1AH; CX:DX now hold number of clock ticks since midnight
 mov ax, dx
 xor dx, dx
 mov cx, 10
 div cx
 mov RANDOMKEY[0], ax
popa
RET
RANDOMNUMBER ENDP  


welcome      db  "Welcome... $"
StartMSG     db  "Timer has been started... $"
LFAILED      db  "Process has been failed, starting over..! $"
L1SUCCESS    db  "Lock1 was opened! $"
L2SUCCESS    db  "Lock2 was opened! $"
L3SUCCESS    db  "Lock3 was opened! $"
L4SUCCESS    db  "Lock4 was opened! $"
L5SUCCESS    db  "Lock5 was opened and I'm out! $"
RANDOMKEY    dw  0
countdown    dw  180
notime       db  "Time out...! $"
KEY          dw  0
bool         dw  1

end
