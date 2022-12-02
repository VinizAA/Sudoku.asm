.model small
.data
    matriz_result db 35h,33h,34h,36h,37h,38h,39h,31h,32h
                  db 36h,37h,32h,31h,39h,35h,33h,34h,38h
                  db 31h,39h,38h,33h,34h,32h,35h,36h,37h
                  db 38h,35h,39h,37h,36h,31h,34h,32h,33h
                  db 34h,32h,36h,38h,35h,33h,37h,39h,31h
                  db 37h,31h,33h,39h,32h,34h,38h,35h,36h
                  db 39h,36h,31h,35h,33h,37h,32h,38h,34h
                  db 32h,38h,37h,34h,31h,39h,36h,33h,35h
                  db 33h,34h,35h,32h,38h,36h,31h,37h,39h
.code 
    main proc 
        mov ax,@data
        mov ds,ax 
        mov si,0
        mov di,0 
        mov ah,02 
        lea bx,matriz_result
volta:
        mov dx,[si][bx]
        int 21h 
        inc bx 
        inc di 
        cmp di,9
        jne volta
        mov dx,10
        int 21h  
        inc si 
        dec bx 
        mov di,0
        cmp si,9
        jne volta
        mov ah,4ch 
        int 21h 
        main ENDP
        end main 