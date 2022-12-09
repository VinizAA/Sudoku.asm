TITLE SUDOKU GAME 

TITLE VINICIUS AFONSO ALVAREZ - RA: 22006181
TITLE PLINIO ZANCHETTA DE SOUZA FERNANDES FILHO - RA: 22023003

.model small
.data
    fase DW ?
    vidas DW ?
    numeros DW 0
    finzin DW 0

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

    SUDOKU DB 10, 10, "                                  SUDOKU$"
    INSTRUCOES DB 10, "             INSTRUCOES:$"
    REGRA1 DB 10, 10, "             1. Utilize as setas do teclado para selecionar a$" 
    REGRA2 DB 10, "             posicao desejada e pressione 'ENTER'.$"
    REGRA3 DB 10, 10, "             2. Digite o numero desejado (0 a 9).$"
    REGRA4 DB 10, 10, "             3. O numero pressionado aparecera: - verde se correto$"
    REGRA5 DB 10, "                                                - vermelho se incorreto$"
    REGRA6 DB 10, 10, "             4. Voce tem 10 vidas. Se errar 10 vezes, voce perde!$"
    REGRA7 DB 10, 10, "             5. Existem dois jogos diferentes para jogar!$"
    COMECAR DB 10, 10, "                                 VAMOS LA!$"

    REINICIAR DB "REINICIAR$"
    VIDAStxt DB "VIDAS:$"

    ESCOLHA DB 10, "                      ESCOLHA A FASE (utiize as setas)$"
    FASE1 DB "[ ] FASE 1$"
    FASE2 DB "[ ] FASE 2$"

    GANHOU DB "P A R A B E N S,  V O C E   G A N H O U!!$"
    GAMEOVER DB "G A M E   O V E R!! :($"
    MENU DB "[ ] INSTRUCOES$"
    REINICIO DB "[ ] REINICIAR$"

.code

    LIMPATELA MACRO ;macro para limpartela
        MOV AX, 06h
        INT 10h
    ENDM

    IMPRIME MACRO msg;macro para imprimir mensagem MACRO msg ;macro para imprimir mensagem
        LEA DX, msg
        MOV AH, 09h
        INT 21h
    ENDM    

    PULALINHA MACRO ;macro para pularlinha 
        MOV AH, 02h
        MOV DL, 10
        INT 21h
    ENDM

    LINHA MACRO cor, coluna, linha, tam ;macro para desenhar linha
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

    COLUNA MACRO cor, coluna, linha, tam ;macro para desenhar coluna
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
    
    ESCREVE MACRO letra, cor ;macro para escrever letra com cor
        MOV AH, 0Eh
        MOV AL, letra
        MOV BH, 0
        MOV BL, cor
        INT 10h
    ENDM

    POSI MACRO linha, coluna ;macro para posicionar o cursor
        MOV DH, linha           
        MOV DL, coluna 
        MOV AH, 02h         
        MOV BH, 0           
        INT 10h
    ENDM

;cores utilizadas no programa
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
;----------------------------

main PROC 
    MOV AX, @data ;inicializa o @data
    MOV DS, AX
   
start:
    LIMPATELA ;macro para limpar tela 
    MOV AH, 0Bh   
    MOV BH, 0
    MOV BL, 15 ;seta a cor de fundo
    INT 10h

;impressão das instruções
    IMPRIME SUDOKU
    IMPRIME INSTRUCOES
    IMPRIME REGRA1
    IMPRIME REGRA2
    IMPRIME REGRA3
    IMPRIME REGRA4
    IMPRIME REGRA5
    IMPRIME REGRA6
    IMPRIME REGRA7
    IMPRIME COMECAR
;------------------------

;posicionamento do cursor e escrita de mensagens
    POSI 19, 18 
    IMPRIME ESCOLHA 
    POSI 22, 22 
    IMPRIME FASE1 
    POSI 22, 44 
    IMPRIME FASE2 
    POSI 22, 23 
    ESCREVE 'X', ciano 
;---------------------------

    MOV fase, 1 ;fase 1 é a escolhida
lednv:
    MOV AH, 00h ;leitura da tecla pressionada
    INT 16h
    CMP AH, 4Dh ;compara com a seta para direita
    JE direita
    CMP AH, 4Bh ;compara com a seta para esquerda
    JE esquerda
    CMP AX, 1C0Dh ;compara com o 'ENTER'
    JNE lednv ;se nao for igual pula para 'lednv'
    JMP inicio ;pula para 'inicio', independentemente

esquerda:
    POSI 22, 45 ;posicionando cursor
    ESCREVE ' ', branco 
    POSI 22, 23 ;posicionando cursor
    ESCREVE 'X', ciano 
    MOV fase, 1 ;fase 1 é a escolhida
    JMP lednv

direita:
    POSI 22, 45 ;posicionando cursor
    ESCREVE 'X', ciano 
    POSI 22, 23 ;posicionando cursor
    ESCREVE ' ', branco 
    MOV fase, 2 ;fase 2 é a escolhida
    JMP lednv

inicio:
    CMP vidas, 10 ;compara vidas com 10
    JE continuaaa ;se for igual, pula par 'continuaaa'
    MOV vidas, 10 ;se não seta vidas = 10
continuaaa:
    LIMPATELA ;macro para limpar tela
    MOV AH, 0
    MOV AL, 13 
    INT 10h ;modo de video

    MOV AH, 0Bh   
    MOV BH, 0
    MOV BL, 0Fh ;seta a cor de fundo
    INT 10h
    
    POSI 0, 91 ;posicionando cursor
;escrever 'SUDOKU' em cinza claro
    ESCREVE 'S', magenta 
    ESCREVE 'U', magenta 
    ESCREVE 'D', magenta 
    ESCREVE 'O', magenta 
    ESCREVE 'K', magenta 
    ESCREVE 'U', magenta 
;-------------------------------

    POSI 5, 110 ;posicionando cursor
    IMPRIME VIDAStxt 
;escreve '10' em cinza claro
    ESCREVE '1', cinzaclaro 
    ESCREVE '0', cinzaclaro 
;--------------------------

    PUSH CX ;CX vai pra pilha
    CALL layout ;chama procedimento 'layout' (matriz)
    POP CX ;CX sai da pilha
testefase:
    CMP fase, 1 ;ve se a fase é 1
    JNE fasix2 ;se nao for, vai par 'fasix2'
    POSI 0, 97 ;posicionando cursor

;escreve '- FASE 1' em magenta
    ESCREVE ' ', magenta
    ESCREVE '-', magenta
    ESCREVE ' ', magenta
    ESCREVE 'F', magenta
    ESCREVE 'A', magenta
    ESCREVE 'S', magenta
    ESCREVE 'E', magenta
    ESCREVE ' ', magenta
    ESCREVE '1', magenta
    CALL numeros1 ;chama procedimento 'numeros1'
    JMP begin ;pula para 'begin', independentemente

fasix2:
    CALL numeros2 ;chama procedimento 'numeros2'
    POSI 0, 97 ;posicionando cursor
;escreve '- FASE 1' em magenta
    ESCREVE ' ', magenta
    ESCREVE '-', magenta
    ESCREVE ' ', magenta
    ESCREVE 'F', magenta
    ESCREVE 'A', magenta
    ESCREVE 'S', magenta
    ESCREVE 'E', magenta
    ESCREVE ' ', magenta
    ESCREVE '2', magenta
;-------------------------
begin:
    MOV SI, 4 ;linha em SI
    MOV DI, 90 ;coluna em DI
    MOV CH, 1 ;linha em CH
    MOV CL, 1 ;coluna em CL
    PUSH CX ;valores da linha e coluna vão pra pilha
    POSI 23, 93 ;posicionando cursor
    IMPRIME POSICAO
    POSI 23, 101 ;posicionando cursor
    OR CH, 30h
    OR CL, 30h
;escreve a posição do cursor
    ESCREVE CH, cinzaclaro
    ESCREVE 'x', cinzaclaro
    ESCREVE CL, cinzaclaro
;---------------------------
    POP CX ;valores da linha e coluna saem da pilha
    XOR DX, DX ;limpando registradores
    XOR BX, BX ;limpando registradores

prox4:
    MOV AH, 00h ;leitura da tecla pressionada
    INT 16h 
    CMP AH, 72 ;compara com a seta para cima
    JNE prox1 ;se nao for igual, pula para 'prox1'
    CMP CH, 1 ;compara com 1 (ve se esta na linha 1)
    JE prox4 ;se estiver, pula para 'prox4' (le dnv) (nao da para ir pra cima)
    SUB SI, 2 ;se nao estiver na primeira linha, subtrae 2 de SI (linha anterior)
    DEC CH ;decrementa CH (linha)
    JMP alteraposi ;pula para 'alteraposi', independentemente
prox1:
    CMP AH, 80 ;compara com a seta para baixo
    JNE prox2 ;se nao for igual, pula para 'prox2'
    CMP CH, 9 ;compara com 9 (ve se esta na linha 9)
    JE prox4 ;se estiver, pula para 'prox4' (le dnv) (nao da para ir para baixo)
    ADD SI, 2 ;se nao estiver na primeira linha, soma 2 a SI (próxima linha)
    INC CH ;incrementa CH (linha)
    JMP alteraposi ;pula para 'alteraposi', independentemente
prox2:
    CMP AH, 4Dh ;compara com a seta para direita
    JNE prox3 ;se nao for igual, pula para 'prox3'
    CMP CL, 9 ;compara com 9 (ve se esta na linha 9)
    JNE continuaa ;se nao estiver, pula para 'continuaa'
    JMP pintatut ;se for 9 (ultima coluna), pula para 'pintatut'
continuaa:
    ADD DI, 2 ;soma 2 a DI (próxima coluna)
    INC CL ;incrementa CL (coluna)
    JMP alteraposi ;pula para 'alteraposi', independentemente
prox3:
    CMP AH, 4Bh ;compara com a seta para esquerda
    JNE prox5 ;se nao for igual, pula para 'prox5'
    CMP CL, 1 ;compara com 1 (ve se esta na coluna 1)
    JE prox4 ;se estiver, pula para 'prox4' (le dnv) (nao da para ir para esquerda)
    SUB DI, 2 ;se nao estiver na primeira coluna, subtrae 2 de DI (coluna anterior)
    DEC CL ;decrementa CL (coluna)
    JMP alteraposi ;pula para 'alteraposi', independentemente

prox5:
    CMP AX, 1C0Dh ;compara com o ENTER
    JNE prox4 ;se nao for igual, pula para 'prox4' (le dnv)
;posicionando o cursor
    MOV DX, SI 
    MOV DH, DL ;linha
    MOV BX, DI           
    MOV DL, BL ;coluna 
    MOV AH, 02h         
    MOV BH, 0           
    INT 10h
;---------------------
lenum:
    MOV AH, 00h ;leitura da tecla pressionada
    INT 16h
    CALL vernum

    PUSH BX ;BX vai pra pilha           
    PUSH SI ;SI vai pra pilha
    PUSH DX ;DX vai pra pilha

;formula que transforma a posição do cursor do modo de video na posição para utilizar na matriz
    SUB DH, 4 ;subtrae 4 de DH (linha)
    SHR DH, 1 ;divide DH por 2 
    SUB DL, 90 ;subtrae 90 de DL (coluna)
    SHR DL, 1 ;divide DL por 2
                         
    XOR BX, BX ;limpando registrador
    MOV BL, DH ;DH (linha) vai para BL

    XCHG AX, BX ;BX e AX trocam de valor
    PUSH CX ;CX vai pra pilha
    MOV CX, 9 ;CX recebe 9 (quantidade de numeros na linha)
    MUL CL ;multiplica AX por CX (linha*9)
    POP CX ;CX sai da pilha
    XCHG AX, BX ;BX e AX trocam de valor

    XOR DH, DH ;limpando registrador
    MOV SI, DX ;DX vai para SI
    POP DX ;DX sai da pilha
    CMP fase, 1 ;compara fase com 1
    JNE matriz2 ;se nao for igual, pula par 'matriz2'
    CMP AL, matriz_result[BX][SI] ;compara o valor digitado com o valor correto da matriz gabarito 1 (fase 1)
    JE numeroverde ;se for igual, pula para 'numeroverde'
    JMP numeroehvermelho ;se nao for igual, pula para 'numeroehvermelho'
matriz2:
    CMP AL, matriz_result2[BX][SI] ;compara o valor digitado com o valor correto da matriz gabarito 2 (fase 2)
    JE numeroverde ;se for igual, pula para 'numeroverde'
    JMP numeroehvermelho ;se nao for igual pula para 'numeroehvermelho'

numeroehvermelho:
    POP SI ;SI sai da pilha
    POP BX ;BX sai da pilha
;posicionando cursor
    MOV DX, SI 
    MOV DH, DL
    MOV BX, DI           
    MOV DL, BL
    MOV AH, 02h         
    MOV BH, 0           
    INT 10h
;-------------------
    ESCREVE AL, vermelho ;escreve o numero errado em vermelho
    DEC vidas ;errou, decrementa uma vida
    POSI 5, 110 ;posicionando cursor
    IMPRIME VIDAStxt
    POSI 5, 116 ;posicionando cursor
;imprime a quantidade de vidas
    ESCREVE '0', cinzaclaro
    MOV DX, vidas
    OR DL, 30h
    MOV AH, 02h
    INT 21h
;-----------------------------
    CMP vidas, 0 ;compara vidas com 0 (jogador perdeu todas as vidas)
    JNE voltax ;se nao for igual, pula para 'voltax'
    JMP fim_do_jogo ;se for igual pula para 'fim_do_jogo'
voltax: 
    JMP prox4 ;pula para 'prox4', independentemente

numeroverde:
    POP SI ;SI sai da pilha
    POP BX ;BX sai da pilha
    ESCREVE AL, verde ;escreve o numero errado em verde
    INC numeros ;incrementa a quantidade de numeros escritos 
    CMP fase, 1 ;compara fase com 1 (fase 1)
    JNE numsfase2 ;se nao for igual, pula para 'numsfase2'
    CMP numeros, 40 ;compara com 40 (para completar o jogo1, eh necessario acertar 40 numeros)
    JNE cont ;se nao for igual, pula para 'cont'
    JMP fim_do_jogo ;se for igual, pula para 'fim_do_jogo'
numsfase2:
    CMP fase, 2 ;compara fase com 1 (fase 2)
    JNE cont ;se nao for igual, pula para 'cont'
    CMP numeros, 43 ;compara com 43 (para completar o jogo2, eh necessario acertar 43 numeros)
    JNE cont ;se nao for igual, pula para 'cont'
    JMP fim_do_jogo ;se for igual, pula para 'fim_do_jogo'

cont:
    JMP prox4 ;pula para 'prox4', independentemente

pintatut:
    POSI 19, 109 ;posicionando cursor
;escreve 'REINICIAR' em ciano
    ESCREVE 'R', ciano
    ESCREVE 'E', ciano
    ESCREVE 'I', ciano
    ESCREVE 'N', ciano
    ESCREVE 'I', ciano
    ESCREVE 'C', ciano
    ESCREVE 'I', ciano
    ESCREVE 'A', ciano
    ESCREVE 'R', ciano
;----------------------------
    MOV AH, 00h ;leitura da tecla pressionada
    INT 16h
    CMP AX, 1C0Dh ;compara com ENTER
    JNE reiniciarcinza ;se nao for igual, pula para 'reiniciarcinza'
    JMP start ;se for igual, pula para 'start' (reinicia o jogo)

reiniciarcinza:
    CMP AH, 4Bh ;compara com seta para esquerda
    JE reiniciarcinza2 ;se for igual, pula para 'reiniciarcinza2'
    JMP prox4 ;se nao for igual, pula para 'prox4' (le dnv)

reiniciarcinza2:
    POSI 19, 109 ;posicionando cursor
;escreve 'REINICIAR' em cinza claro
    ESCREVE 'R', cinzaclaro
    ESCREVE 'E', cinzaclaro
    ESCREVE 'I', cinzaclaro
    ESCREVE 'N', cinzaclaro
    ESCREVE 'I', cinzaclaro
    ESCREVE 'C', cinzaclaro
    ESCREVE 'I', cinzaclaro
    ESCREVE 'A', cinzaclaro
    ESCREVE 'R', cinzaclaro
;----------------------------------
    JMP prox4 ;pula para 'prox4', independentemente

alteraposi:
    PUSH CX ;CX vai para pilha
    POSI 23, 101 ;posicionando cursor
    OR CH, 30h
    OR CL, 30h
;escreve a posição do cursor
    ESCREVE CH, cinzaclaro
    ESCREVE 'x', cinzaclaro
    ESCREVE CL, cinzaclaro
;---------------------------
    POP CX ;CX sai da pilha
    JMP prox4 ;pula para 'prox4', independentemente

fim_do_jogo:
    LIMPATELA ;macro para limpar tela
    MOV AH, 0Bh   
    MOV BH, 0
    MOV BL, 15 ;seta a cor de fundo
    INT 10h

    CMP fase, 1 ;compara fase com 1 (fase 1)
    JNE numsfase3 ;se nao for igual, pula para 'numfase3'
    CMP numeros, 40 ;se for igual, compara numeros com 40 (para completar o jogo1, eh necessario acertar 40 numeros)
    JNE numsfase3 ;se nao for igual, pula para 'numfase3'
    JMP paraboeins ;se for igual, pula para 'paraboeins' (jogador ganhou o jogo)
numsfase3:
    CMP fase, 2 ;compara fase com 2 (fase 2)
    JNE aquipo ;se nao for igual, pula para 'aquipo'
    CMP numeros, 43 ;se for igual, compara numeros com 43 (para completar o jogo2, eh necessario acertar 43 numeros)
    JNE aquipo ;se nao for igual, pula para 'aquipo'
    JMP fim_do_jogo ;se for igual pula para 'fim_do_jogo'

paraboeins:
    POSI 9, 103 ;posicionando cursor
    IMPRIME GANHOU
    JMP esseaqui ;pula para 'esseaqui', independentemente

aquipo:  
    POSI 9, 112 ;posicionando cursor
    IMPRIME GAMEOVER

esseaqui:
    POSI 11, 107 ;posicionando cursor
    IMPRIME REINICIO
    POSI 11, 126 ;posicionando cursor
    IMPRIME MENU

    POSI 11, 108 ;posicionando cursor
    ESCREVE 'X', ciano

    MOV finzin, 1 
lednv2:
    MOV AH, 00h ;leitura da tecla pressionada
    INT 16h
    CMP AH, 4Dh ;compara com a seta para direita
    JE direitinha ;se for igual, pula para 'direitinha'
    CMP AH, 4Bh ;compara com a seta para esquerda
    JE esquerdinha ;se for igual, pula para 'esquerdinha'
    CMP AX, 1C0Dh ;compara com o ENTER
    JNE lednv2 ;se nao for igual, pula apra 'lednv2'
    CMP finzin, 1 ;se for igual, compara finzin com 1 (escolheu reiniciar)
    JNE finzin2 ;se nao igual, pula para 'finzin2'
    JMP inicio ;se for igual, pula para 'inicio'
finzin2:
    CMP finzin, 2 ;compara finzin com 2 (escolheu instrucoes)
    JNE pula ;se nao for igual, pula para 'pula'
    JMP start ;se for igual, pula pra 'start'
pula:
    JMP start ;pula para 'start', independentemente
    
esquerdinha:
    POSI 11, 127 ;posicionando cursor
    ESCREVE ' ', branco
    POSI 11, 108 ;posicionando cursor
    ESCREVE 'X', ciano
    MOV finzin, 1 ;jogador escolheu reiniciar
    JMP lednv2 ;pula para 'lednv2', independentemente 

direitinha:
    POSI 11, 127 ;posicionando cursor
    ESCREVE 'X', ciano
    POSI 11, 108 ;posicionando cursor
    ESCREVE ' ', branco
    MOV finzin, 2 ;jogador escolheu ver as instrucoes
    JMP lednv2 ;pula para 'lednv2', independentemente 

    MOV AH, 4Ch ;fim do programa
    INT 21h
main ENDP

vernum PROC ;procedimento para verificar se um numero
    CMP AH, 0
    JGE compdnv
    JMP lenum
compdnv:
    CMP AH, 9
    JLE ehnum
    JMP lenum
ehnum:
RET
vernum ENDP

layout PROC ;procedimento do layout da matriz do jogo
    CALL numsposi ;chama o procedimento 'numsposi'
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

    POSI 19, 109 ;posicionando cursor
    IMPRIME REINICIAR
RET
layout ENDP

numeros1 PROC ;procedimento que escreve os numeros ja definidos do jogo da fase 1
    POSI 23, 93 ;posicionando cursor
    IMPRIME POSICAO

;posicionando e escrevendo os numeros ja definidos
    POSI 4, 90 
    ESCREVE '5', azul
    POSI 4, 92
    ESCREVE '3', azul
    POSI 4, 98
    ESCREVE '7', azul
    POSI 4, 104
    ESCREVE '1', azul
    POSI 4, 106
    ESCREVE '2', azul

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
    POSI 8, 100
    ESCREVE '2', azul
    POSI 8, 104
    ESCREVE '6', azul
    POSI 8, 106
    ESCREVE '7', azul

    POSI 10, 90
    ESCREVE '8', azul
    POSI 10, 96
    ESCREVE '7', azul
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
    POSI 12, 102
    ESCREVE '7', azul
    POSI 12, 106
    ESCREVE '1', azul

    POSI 14, 90
    ESCREVE '7', azul
    POSI 14, 94
    ESCREVE '3', azul
    POSI 14, 98
    ESCREVE '2', azul
    POSI 14, 106
    ESCREVE '6', azul

    POSI 16, 92
    ESCREVE '6', azul
    POSI 16, 98
    ESCREVE '3', azul
    POSI 16, 102
    ESCREVE '2', azul
    POSI 16, 104
    ESCREVE '8', azul

    POSI 18, 90
    ESCREVE '2', azul
    POSI 18, 96
    ESCREVE '4', azul
    POSI 18, 98
    ESCREVE '1', azul
    POSI 18, 100
    ESCREVE '9', azul
    POSI 18, 106
    ESCREVE '5', azul

    POSI 20, 90
    ESCREVE '3', azul
    POSI 20, 92
    ESCREVE '4', azul
    POSI 20, 98
    ESCREVE '8', azul
    POSI 20, 104
    ESCREVE '7', azul
    POSI 20, 106
    ESCREVE '9', azul
RET
numeros1 ENDP

numsposi PROC ;procedimento que escreve os numeros que guiam a posição do cursor
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

numeros2 PROC ;procedimento que escreve os numeros ja definidos do jogo da fase 1
    POSI 23, 93 ;posicionando cursor
    IMPRIME POSICAO

;posicionando e escrevendo os numeros ja definidos
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
end main
