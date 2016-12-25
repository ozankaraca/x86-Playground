
name "Sorting Char Array"


org  100h


print_new_line macro	;A macro for creating a new line
    mov dl, 13
    mov ah, 2
    int 21h   
    mov dl, 10
    mov ah, 2
    int 21h      
endm

wait_for_1s macro		;A macro to provide delay
    pusha
    MOV     CX, 0FH
    MOV     DX, 4240H
    MOV     AH, 86H
    INT     15H
    popa
endm   


    mov dx, offset msg1 ;Output: Give an input
    mov ah, 9
    int 21h
    ; input the array:
    mov dx, offset s1
    mov ah, 0ah
    int 21h
    
    print_new_line
    
    mov dx, offset msg2  ;Output: Sorted
    mov ah, 9
    int 21h
    
    
    
    xor ax, ax
    mov al, s1[1]		;Gettin actual string size
    mov di, offset s1[2]

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
    
    ; sizeofarray:
    xor cx, cx
    mov cl, s1[1]
    mov bx, offset s1[2]
print_char:
    mov dl, [bx]
    mov ah, 2
    int 21h      
    wait_for_1s
    inc bx
    loop print_char


    ; wait for any key...
    mov ax, 0 
    int 16h
    
    ret




msg1    db  "Give an Input: $"
msg2    db  "Sorted: $"
s1      db 100,?, 100 dup(' ') 


end
