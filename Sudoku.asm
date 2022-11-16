TITLE VINICIUS AFONSO ALVAREZ - RA:22006181
TITLE PLINAO DA MASSA - RA:

.model small
.data
    mat DB 5,3,?,?,7,?,?,?,?
        DB 6,?,?,1,9,5,?,?,?
        DB ?,9,8,?,?,?,?,6,?
        DB 8,?,?,?,6,?,?,?,3
        DB 4,?,?,8,?,3,?,?,1
        DB 7,?,?,?,2,?,?,?,6
        DB ?,6,?,?,?,?,2,8,?
        DB ?,?,?,4,1,9,?,?,5
        DB ?,?,?,?,8,?,?,7,9


    titulo DB 10, "                       SUDOKU$"
    regra1 DB 10, 10, "1. Utilize o mouse para selecionar o que for pedido$"
    regra2 DB 10, "2. Utilize os numeros de 1 a 9 para preencher o quadro$"
    regra3 DB 10, "3. A qualquer momento, se desejar sair do jogo, pressione o 'ESC'$", 10

.code

    LIMPATELA MACRO 
        MOV AX, 02h
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
    
main PROC
    MOV AX, @data
    MOV DS, AX

    LIMPATELA
    IMPRIME titulo
    IMPRIME regra1
    IMPRIME regra2
    IMPRIME regra3
    MOV AH, 4Ch
    INT 21h
main ENDP
end main