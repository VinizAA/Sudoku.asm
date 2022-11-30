TITLE VINICIUS AFONSO ALVAREZ - RA:22006181
TITLE PLINAO DA MASSA - RA:

.model small
.data
    ERRO DB 10, "DIGITE UM NUMERO DE 0 a 9$"
    NUM DB 10, "DIGITE O NUMERO (0 a 9): $"

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
    
    POSI 1, 93
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

    POSI 5, 112
    ESCREVE 'D', marrom
    ESCREVE 'I', marrom
    ESCREVE 'C', marrom
    ESCREVE 'A', marrom

    POSI 8, 110
    ESCREVE 'D', marrom
    ESCREVE 'E', marrom
    ESCREVE 'S', marrom
    ESCREVE 'F', marrom
    ESCREVE 'A', marrom
    ESCREVE 'Z', marrom
    ESCREVE 'E', marrom
    ESCREVE 'R', marrom

    CALL layout
    XOR DX, DX
solta:
    MOV AX, 3
    INT 33h     
    CMP BX, 1   
    JNE solta     
solta1:
    MOV AX, 3
    INT 33h     
    CMP BX, 0   
    JNE solta1
    
    ;CX --> coluna
    ;DX --> linha

    MOV DH, DL ;linha vai para DH
        XOR BX, BX
        MOV BX, CX
    MOV DL, BL ;coluna vai pra DL           
    MOV AH, 02h         
    MOV BH, 0           
    INT 10h

    MOV AH, 08h
    INT 21h
    ESCREVE AL, vermelho
    MOV AH, 4Ch
    INT 21h
main ENDP

VERNUM PROC
    CMP AL, 0
    JGE compdnv
    IMPRIME ERRO
    compdnv:
    CMP AL, 9
    JLE ehnum
    IMPRIME ERRO
    ehnum:
RET
VERNUM ENDP

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
    POSI 20, 108
    ESCREVE '0', branco
RET
numeros ENDP
end main
