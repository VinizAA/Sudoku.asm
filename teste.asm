.model small
.data
    matriz_result DB 35h,33h,34h,36h,37h,38h,39h,31h,32h
                  DB 36h,37h,32h,31h,39h,35h,33h,34h,38h
                  DB 31h,39h,38h,33h,34h,32h,35h,36h,37h
                  DB 38h,35h,39h,37h,36h,31h,34h,32h,33h
                  DB 34h,32h,36h,38h,35h,33h,37h,39h,31h
                  DB 37h,31h,33h,39h,32h,34h,38h,35h,36h
                  DB 39h,36h,31h,35h,33h,37h,32h,38h,34h
                  DB 32h,38h,37h,34h,31h,39h,36h,33h,35h
                  DB 33h,34h,35h,32h,38h,36h,31h,37h,39h

    XZ DB 10, "X (linha): $"
    YP DB 10, "Y (coluna): $"
.code

    IMPRIME MACRO msg
        LEA DX, msg
        MOV AH, 09h
        INT 21h
    ENDM

main PROC 
    MOV AX,@data
    MOV DS,AX

    MOV AX, 06h
    INT 10h
    MOV AH, 0Bh   
    MOV BH, 0
    MOV BL, 15 ;cor de fundo
    INT 10h 

volta:
    mov ax, 3
    int 33h 

    cmp bx, 0   
    je volta    
    
    PUSH DX
    MOV DX, CX
    MOV AH, 02h
    INT 21h
    POP DX
    MOV AH, 02h
    INT 21h

    MOV AH, 4Ch
    INT 21h
main ENDP
end main 