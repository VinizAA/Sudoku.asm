TITLE VINICIUS AFONSO ALVAREZ - RA: 22006181
TITLE PLINIO ZANCHETTA DE SOUZA FERNANDES FILHO - RA: 22023003

.model small
.data

    matriz_result DB 35h, 33h, 34h, 36h, 37h, 38h, 39h, 31h, 32h
                  DB 36h, 37h, 32h, 31h, 39h, 35h, 33h, 34h, 38h
                  DB 31h, 39h, 38h, 33h, 34h, 32h, 35h, 36h, 37h
                  DB 38h, 35h, 39h, 37h, 36h, 31h, 34h, 32h, 33h
                  DB 34h, 32h, 36h, 38h, 35h, 33h, 37h, 39h, 31h
                  DB 37h, 31h, 33h, 39h, 32h, 34h, 38h, 35h, 36h
                  DB 39h, 36h, 31h, 35h, 33h, 37h, 32h, 38h, 34h
                  DB 32h, 38h, 37h, 34h, 31h, 39h, 36h, 33h, 35h
                  DB 33h, 34h, 35h, 32h, 38h, 36h, 31h, 37h, 39h

    matriz_result2 DB 35h, 31h, 39h, 32h, 33h, 34h, 38h, 36h, 37h 
                   DB 33h, 38h, 34h, 39h, 37h, 36h, 35h, 31h, 32h
                   DB 32h, 37h, 36h, 38h, 35h, 31h, 39h, 33h, 34h
                   DB 38h, 33h, 31h, 34h, 39h, 37h, 32h, 35h, 36h
                   DB 39h, 32h, 37h, 33h, 36h, 35h, 31h, 34h, 38h
                   DB 34h, 36h, 35h, 31h, 38h, 32h, 33h, 37h, 39h
                   DB 37h, 39h, 32h, 35h, 34h, 33h, 36h, 38h, 31h
                   DB 36h, 35h, 38h, 37h, 31h, 39h, 34h, 32h, 33h
                   DB 31h, 34h, 33h, 36h, 32h, 38h, 37h, 39h, 35h
    
    POSICAO DB "POSICAO: $"
    ERRO DB "ERRO!$"

    SUDOKU DB 10, 10, 10, "                                  SUDOKU$"
    INSTRUCOES DB 10, "             INSTRUCOES:$"
    REGRA1 DB 10, 10, "             1. Utilize as setas do teclado para selecionar a$" 
    REGRA2 DB 10, "             posicao desejada e pressione 'ENTER'.$"
    REGRA3 DB 10, 10, "             2. Digite o numero desejado (0 a 9).$"
    REGRA4 DB 10, 10, "             3. O numero pressionado aparecera: - verde se correto$"
    REGRA5 DB 10, "                                                - vermelho se incorreto$"
    REGRA6 DB 10, 10, "             4. Existem dois jogos diferentes para jogar!$"
    COMECAR DB 10, 10, 10, "                                 VAMOS LA!$"
    i DW ?
    j DW ?
    REINICIAR DB "REINICIAR$"
    VIDAS DB "VIDAS:$"

    ESCOLHA DB 10, "                      ESCOLHA A FASE (utiize as setas)$"
    FASE1 DB "[ ] FASE 1$"
    FASE2 DB "[ ] FASE 2$"

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
        ;push bx
        MOV AH, 0Eh
        MOV AL, letra
        MOV BH, 0
        MOV BL, cor
        INT 10h
        ;pop bx
    ENDM

    POSI MACRO linha, coluna
        ;push bx
        MOV DH, linha           
        MOV DL, coluna 
        MOV AH, 02h         
        MOV BH, 0           
        INT 10h
        ;pop bx
    ENDM

    DELAY MACRO
        LOCAL pass1
        LOCAL pass2
            MOV DI, 0FFFFh
    pass1:
        MOV CX, 25
    pass2:
        LOOP pass2
        DEC DI
        JNZ pass1
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
   
start:
    LIMPATELA
    MOV AH, 0Bh   
    MOV BH, 0
    MOV BL, 15 ;cor de fundo
    INT 10h

    IMPRIME SUDOKU
    IMPRIME INSTRUCOES
    IMPRIME REGRA1
    IMPRIME REGRA2
    IMPRIME REGRA3
    IMPRIME REGRA4
    IMPRIME REGRA5
    IMPRIME REGRA6
    IMPRIME COMECAR

    POSI 19, 18
    IMPRIME ESCOLHA
    POSI 22, 22
    IMPRIME FASE1
    POSI 22, 44
    IMPRIME FASE2
    POSI 22, 23
    ESCREVE 'X', ciano

    MOV CX, 1
lednv:
    MOV AH, 00h
    INT 16h
    CMP AH, 4Dh ;direita
    JE direita
    CMP AH, 4Bh ;esquerda
    JE esquerda
    CMP AX, 1C0Dh
    JNE lednv
    JMP inicio

esquerda:
    POSI 22, 45
    ESCREVE ' ', branco
    POSI 22, 23
    ESCREVE 'X', ciano
    MOV CX, 1
    JMP lednv

direita:
    POSI 22, 45
    ESCREVE 'X', ciano
    POSI 22, 23
    ESCREVE ' ', branco
    MOV CX, 2
    JMP lednv

inicio:
    LIMPATELA
    MOV AH, 0
    MOV AL, 13
    INT 10h

    MOV AH, 0Bh   
    MOV BH, 0
    MOV BL, 0Fh ;cor de fundo
    INT 10h
    
    POSI 0, 91
    ESCREVE 'S', magenta
    ESCREVE 'U', magenta
    ESCREVE 'D', magenta
    ESCREVE 'O', magenta
    ESCREVE 'K', magenta
    ESCREVE 'U', magenta

    PUSH CX
    CALL layout
    POP CX
testefase:
    CMP CX, 1
    JNE fasix2
    POSI 0, 97
    ESCREVE ' ', magenta
    ESCREVE '-', magenta
    ESCREVE ' ', magenta
    ESCREVE 'F', magenta
    ESCREVE 'A', magenta
    ESCREVE 'S', magenta
    ESCREVE 'E', magenta
    ESCREVE ' ', magenta
    ESCREVE '1', magenta
    CALL numeros1
    JMP begin
fasix2:
    CALL numeros2
    POSI 0, 97
    ESCREVE ' ', magenta
    ESCREVE '-', magenta
    ESCREVE ' ', magenta
    ESCREVE 'F', magenta
    ESCREVE 'A', magenta
    ESCREVE 'S', magenta
    ESCREVE 'E', magenta
    ESCREVE ' ', magenta
    ESCREVE '2', magenta
begin:
    MOV SI, 4 ;linha
    MOV DI, 90 ;coluna
    MOV CH, 1 ;linha
    MOV CL, 1 ;coluna
    PUSH CX
    POSI 23, 93
    IMPRIME POSICAO
    POSI 23, 101
    OR CH, 30h
    OR CL, 30h
    ESCREVE CH, cinzaclaro
    ESCREVE 'x', cinzaclaro
    ESCREVE CL, cinzaclaro
    POP CX
    XOR DX, DX
    XOR BX, BX

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
    JE pintatut
    ADD DI, 2
    INC CL
    JMP alteraposi
prox3:
    CMP AH, 4Bh ;esquerda
    JNE prox5
    CMP CL, 1
    JE prox4
    SUB DI, 2
    DEC CL
    JMP alteraposi

prox5:
    CMP AX, 1C0Dh
    JNE prox4
    MOV DX, SI
    MOV DH, DL ;linha
    MOV BX, DI           
    MOV DL, BL ;coluna 
    MOV AH, 02h         
    MOV BH, 0           
    INT 10h
    MOV AX, AX
    MOV AH, 00h
    INT 16h
    ;========================

    SUB DH,4
    SHR DH,1
    SUB DL,90
    SHR DL,1
    PUSH BX
    PUSH SI

    XOR BX,BX
    MOV BL, DH
    XOR DH,DH
    MOV SI,DX
    CMP AL,matriz_result[BX][SI]
    JE numeroverde
    POP SI 
    POP BX
    MOV DX, SI
    MOV DH, DL ;linha
    MOV BX, DI           
    MOV DL, BL ;coluna 
    MOV AH, 02h         
    MOV BH, 0           
    INT 10h
    ESCREVE AL, vermelho
    JMP prox4

numeroverde:
    ESCREVE AL, verde
    JMP prox4

pintatut:
    POSI 19, 109
    ESCREVE 'R', ciano
    ESCREVE 'E', ciano
    ESCREVE 'I', ciano
    ESCREVE 'N', ciano
    ESCREVE 'I', ciano
    ESCREVE 'C', ciano
    ESCREVE 'I', ciano
    ESCREVE 'A', ciano
    ESCREVE 'R', ciano
    MOV AH, 00h
    INT 16h
    CMP AX, 1C0Dh
    JNE reiniciarcinza
    JMP start

reiniciarcinza:
    CMP AH, 4Bh
    JE reiniciarcinza2
    JMP prox4

reiniciarcinza2:
    POSI 19, 109
    ESCREVE 'R', cinzaclaro
    ESCREVE 'E', cinzaclaro
    ESCREVE 'I', cinzaclaro
    ESCREVE 'N', cinzaclaro
    ESCREVE 'I', cinzaclaro
    ESCREVE 'C', cinzaclaro
    ESCREVE 'I', cinzaclaro
    ESCREVE 'A', cinzaclaro
    ESCREVE 'R', cinzaclaro
    JMP prox4

alteraposi:
    PUSH CX
    POSI 23, 101
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
    CALL numsposi
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

    POSI 19, 109
    IMPRIME REINICIAR
RET
layout ENDP

numeros1 PROC
    POSI 23, 93
    IMPRIME POSICAO

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
numeros1 ENDP

numsposi PROC
    POSI 4, 88
    ESCREVE '1', marrom
    POSI 6, 88
    ESCREVE '2', marrom
    POSI 8, 88
    ESCREVE '3', marrom
    POSI 10, 88
    ESCREVE '4', marrom
    POSI 12, 88
    ESCREVE '5', marrom
    POSI 14, 88
    ESCREVE '6', marrom
    POSI 16, 88
    ESCREVE '7', marrom
    POSI 18, 88
    ESCREVE '8', marrom
    POSI 20, 88
    ESCREVE '9', marrom
    
    POSI 2, 90
    ESCREVE '1', marrom
    POSI 2, 92
    ESCREVE '2', marrom
    POSI 2, 94
    ESCREVE '3', marrom
    POSI 2, 96
    ESCREVE '4', marrom
    POSI 2, 98
    ESCREVE '5', marrom
    POSI 2, 100
    ESCREVE '6', marrom
    POSI 2, 102
    ESCREVE '7', marrom
    POSI 2, 104
    ESCREVE '8', marrom
    POSI 2, 106
    ESCREVE '9', marrom
RET
numsposi ENDP

numeros2 PROC
    POSI 23, 93
    IMPRIME POSICAO

    POSI 4, 90
    ESCREVE '5', azul
    POSI 4, 96
    ESCREVE '2', azul
    POSI 4, 98
    ESCREVE '3', azul
    POSI 4, 102
    ESCREVE '8', azul
    POSI 4, 104
    ESCREVE '6', azul
    POSI 4, 106
    ESCREVE '7', azul

    POSI 6, 92
    ESCREVE '8', azul
    POSI 6, 96
    ESCREVE '9', azul
    POSI 6, 106
    ESCREVE '2', azul

    POSI 8, 90
    ESCREVE '2', azul
    POSI 8, 96
    ESCREVE '8', azul

    POSI 10, 94
    ESCREVE '1', azul
    POSI 10, 98
    ESCREVE '9', azul
    POSI 10, 102
    ESCREVE '2', azul
    POSI 10, 104
    ESCREVE '5', azul

    POSI 12, 92
    ESCREVE '2', azul
    POSI 12, 94
    ESCREVE '7', azul
    POSI 12, 96
    ESCREVE '3', azul
    POSI 12, 98
    ESCREVE '6', azul
    POSI 12, 100
    ESCREVE '5', azul
    POSI 12, 102
    ESCREVE '1', azul

    POSI 14, 94
    ESCREVE '5', azul
    POSI 14, 96
    ESCREVE '1', azul
    POSI 14, 98
    ESCREVE '8', azul
    POSI 14, 100
    ESCREVE '2', azul
    POSI 14, 102
    ESCREVE '3', azul
    POSI 14, 104
    ESCREVE '7', azul

    POSI 16, 94
    ESCREVE '2', azul
    POSI 16, 100
    ESCREVE '3', azul
    POSI 16, 104
    ESCREVE '8', azul
    POSI 16, 106
    ESCREVE '1', azul

    POSI 18, 90
    ESCREVE '6', azul
    POSI 18, 94
    ESCREVE '8', azul
    POSI 18, 98
    ESCREVE '1', azul
    POSI 18, 100
    ESCREVE '9', azul
    POSI 18, 104
    ESCREVE '2', azul
    
    POSI 20, 90
    ESCREVE '1', azul
    POSI 20, 92
    ESCREVE '4', azul
    POSI 20, 98
    ESCREVE '2', azul
    POSI 20, 100
    ESCREVE '8', azul
    POSI 20, 106
    ESCREVE '5', azul
RET
numeros2 ENDP

localizacao PROC 
    OR CH, 30h
    OR CL, 30h
    POSI DH, DL
    ESCREVE CH, ciano
    POSI BH, BL
    ESCREVE CL, ciano
RET
localizacao ENDP
end main

;BH - linha do numero da coluna
;BL - coluna do numero da coluna

;DH - linha do numero da linha
;DL - coluna do numero da linha