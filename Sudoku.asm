TITLE VINICIUS AFONSO ALVAREZ - RA:22006181
TITLE PLINIO ZANCHETTA DE SOUZA FERNANDES FILHO - RA:22023003

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

    LIMPATELA MACRO 
        MOV AX, 06h
        INT 10h
    ENDM

    IMPRIME MACRO msg
        LEA DX, msg
        MOV AH, 09h
        INT 21h
    ENDM    

    PULALINHA MACRO 
        MOV AH, 02h
        MOV DL, 10
        INT 21h
    ENDM

    LINHA MACRO cor, coluna, linha, tam
        LOCAL lin
        MOV AH, 0Ch
        MOV AL, cor
        MOV CX, coluna ;coluna
        MOV DX, linha ;linha
    lin:
        INT 10h
        INC CX
        CMP CX, tam
        JLE lin
    ENDM

    COLUNA MACRO cor, coluna, linha, tam
        LOCAL col
        MOV AH, 0Ch
        MOV AL, cor
        MOV CX, coluna ;coluna
        MOV DX, linha ;linha
    col:
        INT 10h
        INC DX
        CMP DX, tam
        JLE col
    ENDM
    
    ESCREVE MACRO letra, cor
        MOV AH, 0Eh
        MOV AL, letra
        MOV BH, 0
        MOV BL, cor
        INT 10h
    ENDM

    POSI MACRO linha, coluna
        MOV DH, linha           
        MOV DL, coluna 
        MOV AH, 02h         
        MOV BH, 0           
        INT 10h
    ENDM

    marrom EQU 6h
    cinzaclaro EQU 7h
    cinzaescuro EQU 8h
    azul EQU 9h
    verde EQU 0Ah
    ciano EQU 0Bh
    vermelho EQU 0Ch
    magenta EQU 0Dh
    amarelo EQU 0Eh
    branco EQU 0Fh

main PROC
    MOV AX, @data
    MOV DS, AX

    LIMPATELA
    MOV AH, 0
    MOV AL, 13
    INT 10h

    MOV AH, 0Bh   
    MOV BH, 0
    MOV BL, 0Fh ;cor de fundo
    INT 10h
    
    POSI 0, 93
    ESCREVE 'S', magenta
    ESCREVE 'U', magenta
    ESCREVE 'D', magenta
    ESCREVE 'O', magenta
    ESCREVE 'K', magenta
    ESCREVE 'U', magenta
    ESCREVE ' ', magenta
    ESCREVE 'G', magenta
    ESCREVE 'A', magenta
    ESCREVE 'M', magenta
    ESCREVE 'E', magenta

    CALL layout
    MOV SI, 4 ;linha
    MOV DI, 90 ;coluna
    MOV CH, 1 ;linha
    MOV CL, 1 ;coluna
    PUSH CX
    POSI 23, 92
    IMPRIME POSICAO
    POSI 23, 100
    OR CH, 30h
    OR CL, 30h
    ESCREVE CH, cinzaclaro
    ESCREVE 'x', cinzaclaro
    ESCREVE CL, cinzaclaro
    POP CX

prox4:
    MOV AH, 00h
    INT 16h
    CMP AH, 72 ;cima
    JNE prox1
    CMP CH, 1
    JE prox4
    SUB SI, 2
    DEC CH
    JMP alteraposi
prox1:
    CMP AH, 80 ;baixo
    JNE prox2
    CMP CH, 9
    JE prox4
    ADD SI, 2
    INC CH
    JMP alteraposi
prox2:
    CMP AH, 4Dh ;direita
    JNE prox3
    CMP CL, 9
    JE prox4
    ADD DI, 2
    INC CL
    JMP alteraposi
prox3:
    CMP AH, 4Bh ;esquerda
    JNE prox4
    CMP CL, 1
    JE prox4
    SUB DI, 2
    DEC CL

alteraposi:
    PUSH CX
    POSI 23, 100
    OR CH, 30h
    OR CL, 30h
    ESCREVE CH, cinzaclaro
    ESCREVE 'x', cinzaclaro
    ESCREVE CL, cinzaclaro
    POP CX
    JMP prox4

    MOV AH, 4Ch
    INT 21h
main ENDP

vernum PROC
    CMP AL, 0
    JGE compdnv
    IMPRIME ERRO
    compdnv:
    CMP AL, 9
    JLE ehnum
    IMPRIME ERRO
    ehnum:
RET
vernum ENDP

layout PROC 
    CALL numeros
    ;linhas internas claras
    LINHA cinzaclaro, 75, 45, 219
    LINHA cinzaclaro, 76, 61, 219
    LINHA cinzaclaro, 76, 93, 219
    LINHA cinzaclaro, 76, 109, 219
    LINHA cinzaclaro, 76, 141, 219
    LINHA cinzaclaro, 76, 157, 219

    COLUNA cinzaclaro 91, 30, 172
    COLUNA cinzaclaro 107, 30, 172
    COLUNA cinzaclaro 139, 30, 172
    COLUNA cinzaclaro 155, 30, 172
    COLUNA cinzaclaro 187, 30, 172
    COLUNA cinzaclaro 203, 30, 172

    ;linhas internas escuras 
    LINHA cinzaescuro, 76, 77, 219
    LINHA cinzaescuro, 76, 125, 219
    COLUNA cinzaescuro 123, 30, 172
    COLUNA cinzaescuro 171, 30, 172
    
    ;quadrado externo
    LINHA cinzaescuro, 75, 30, 219
    COLUNA cinzaescuro, 75, 30, 172
    LINHA cinzaescuro, 75, 172, 219
    COLUNA cinzaescuro 219, 30, 172

RET
layout ENDP

numeros PROC
    POSI 23, 92
    IMPRIME POSICAO

    POSI 4, 88
    ESCREVE '1', verde
    POSI 6, 88
    ESCREVE '2', verde
    POSI 8, 88
    ESCREVE '3', verde
    POSI 10, 88
    ESCREVE '4', verde
    POSI 12, 88
    ESCREVE '5', verde
    POSI 14, 88
    ESCREVE '6', verde
    POSI 16, 88
    ESCREVE '7', verde
    POSI 18, 88
    ESCREVE '8', verde
    POSI 20, 88
    ESCREVE '9', verde
    
    POSI 2, 90
    ESCREVE '1', verde
    POSI 2, 92
    ESCREVE '2', verde
    POSI 2, 94
    ESCREVE '3', verde
    POSI 2, 96
    ESCREVE '4', verde
    POSI 2, 98
    ESCREVE '5', verde
    POSI 2, 100
    ESCREVE '6', verde
    POSI 2, 102
    ESCREVE '7', verde
    POSI 2, 104
    ESCREVE '8', verde
    POSI 2, 106
    ESCREVE '9', verde


    POSI 4, 90
    ESCREVE '5', azul
    POSI 4, 92
    ESCREVE '3', azul
    POSI 4, 98
    ESCREVE '7', azul

    POSI 6, 90
    ESCREVE '6', azul
    POSI 6, 96
    ESCREVE '1', azul
    POSI 6, 98
    ESCREVE '9', azul
    POSI 6, 100
    ESCREVE '5', azul

    POSI 8, 92
    ESCREVE '9', azul
    POSI 8, 94
    ESCREVE '8', azul
    POSI 8, 104
    ESCREVE '6', azul

    POSI 10, 90
    ESCREVE '8', azul
    POSI 10, 98
    ESCREVE '6', azul
    POSI 10, 106
    ESCREVE '3', azul

    POSI 12, 90
    ESCREVE '4', azul
    POSI 12, 96
    ESCREVE '8', azul
    POSI 12, 100
    ESCREVE '3', azul
    POSI 12, 106
    ESCREVE '1', azul

    POSI 14, 90
    ESCREVE '7', azul
    POSI 14, 98
    ESCREVE '2', azul
    POSI 14, 106
    ESCREVE '6', azul
    POSI 16, 92
    ESCREVE '6', azul
    POSI 16, 102
    ESCREVE '2', azul
    POSI 16, 104
    ESCREVE '8', azul

    POSI 18, 96
    ESCREVE '4', azul
    POSI 18, 98
    ESCREVE '1', azul
    POSI 18, 100
    ESCREVE '9', azul
    POSI 18, 106
    ESCREVE '5', azul
    
    POSI 20, 98
    ESCREVE '8', azul
    POSI 20, 104
    ESCREVE '7', azul
    POSI 20, 106
    ESCREVE '9', azul
RET
numeros ENDP

cmpnums PROC

reti:
RET
cmpnums ENDP
end main
