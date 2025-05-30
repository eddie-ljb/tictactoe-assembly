;init
mov R1,#13h
mov r2,#45h

; loop setzt inkrementell Spielfeld zurück
ResetSpielFeld:
mov @r1,#00h
INC r1
DJNZ R2,ResetSpielFeld

setb p1.0 ; Spielerwechsel-Flag

mov r0,#00h
mov 70h,#11h ; 70h letztaktiver Spieler
mov p2,#0 ;Spieler 1 Status
mov p3,#0 ; Spieler 2 Status
mov p1,#00111111b
 
; Leeres Spielfeld
Mov 13h,#0FFh
Mov 14h,#0FFh
Mov 15h,#0FFh
Mov 16h,#0FFh
Mov 17h,#0FFh
Mov 23h,#0FFh
Mov 27h,#0FFh
Mov 33h,#0FFh
Mov 37h,#0FFh
Mov 43h,#0FFh
Mov 47h,#0FFh
Mov 53h,#0FFh
Mov 54h,#0FFh
Mov 55h,#0FFh
Mov 56h,#0FFh
Mov 57h,#0FFh


MainLoop:
jnb p2.4,SkipMiddle ; Wenn Feld 5 nicht gesetzt überspringen
jnb p2.0,P1_Diagonal_False
jnb p1.7,P1_Diagonal_False

P1_Sieg:
mov p1,#11111001b ; SiegLED
jmp SkipP2Sieg

P2_Sieg:
mov p1,#10100100b ; SiegLED

P1_Diagonal_False:
jnb p2.1,P1_MidCol_False
jb p2.7,P1_Sieg ; Feld 3 gesetzt → diagonaler Sieg

P1_MidCol_False:
jnb p2.2,P1_Diagonal2
jb p2.6,P1_Sieg ; Mittlere Spalte

P1_Diagonal2:
jnb p2.3,SkipMiddle
jb p2.5,P1_Sieg ; Diagonale 3-5-7


SkipMiddle:
jnb p2.0,P1_TopLeft_False
jnb p2.1,P1_JumpHere
jb p2.2,P1_Sieg ; Erste Zeile voll?

P1_JumpHere:
jnb p2.3,P1_TopLeft_False
jb p2.6,P1_Sieg ; Zweite Zeile voll?

P1_TopLeft_False:
jnb p1.7,CheckPlayer2
jnb p2.5,P1_BotCol_False
jb p2.2,P1_Sieg ; Dritte Zeile voll?

P1_BotCol_False:
jnb p2.7,CheckPlayer2
jb p2.6,P1_Sieg

CheckPlayer2:

jnb p3.4,SkipMiddle2
jnb p3.0,P2_Diagonal_False
jnb p1.6,P2_Diagonal_False


P2_Diagonal_False:
jnb p3.1,P2_MidCol_False
jb p3.7,P2_Sieg

P2_MidCol_False:
jnb p3.2,P2_Diagonal2
jb p3.6,P2_Sieg

P2_Diagonal2:
jnb p3.3,SkipMiddle2
jb p3.5,P2_Sieg

SkipMiddle2:
jnb p3.0,P2_TopLeft_False
jnb p3.1,P2_JumpHere
jb p3.2,P2_Sieg

P2_JumpHere:
jnb p3.3,P2_TopLeft_False
jb p3.6,P2_Sieg

P2_TopLeft_False:
jnb p1.6,Continue
jnb p3.5,P2_BotCol_False
jb p3.2,P2_Sieg

P2_BotCol_False:
jnb p3.7,Continue
jb p3.6,P2_Sieg
Continue: ; Eingabeprüfung


SETB P0.0
SETB P0.1
SETB P0.2
CLR P0.3

JNB P0.6,Eins
JNB P0.5,Zwei
JNB P0.4,Drei
SETB P0.3
CLR P0.2

JNB P0.6,Vier
JNB P0.5,Fünf
JNB P0.4,Sechs
SETB P0.2
CLR P0.1

JNB P0.6,Sieben
JNB P0.5,Acht
JNB P0.4,Neun
SETB P0.1
CLR P0.0
SETB P0.0
JMP MainLoop

; Eingabeverarbeitung
Eins:
mov r0,#24h
CJNE @r0, #0, GoBack
jb p0.7,SetPlayer


Zwei:
mov r0,#25h
CJNE @r0, #0, GoBack
jb p0.7,SetPlayer

Drei:
mov r0,#26h
CJNE @r0, #0, GoBack
jb p0.7,SetPlayer

Vier:
mov r0,#34h
CJNE @r0, #0, GoBack
jb p0.7,SetPlayer

Fünf:
mov r0,#35h
CJNE @r0, #0, GoBack
jb p0.7,SetPlayer

GoBack:
ljmp MainLoop

Sechs:
mov r0,#36h
CJNE @r0, #0, GoBack
jb p0.7,SetPlayer

Sieben:
mov r0,#44h
CJNE @r0, #0, GoBack
jb p0.7,SetPlayer

Acht:
mov r0,#45h
CJNE @r0, #0, GoBack
jb p0.7,SetPlayer

Neun:
mov r0,#46h
CJNE @r0, #0, GoBack
jb p0.7,SetPlayer







SetPlayer:
jnb p1.0,PlayerB ; Wenn p1.0 = 0 Spieler 2 ist dran

mov @r0,#11h
mov 70h,#22h

; Setbit im Spielerstatus Register
CJNE r0, #24h,Player1_24
setb p2.0
Player1_24:
CJNE r0, #25h,Player1_25
setb p2.1
Player1_25:
CJNE r0, #26h,Player1_26
setb p2.2
Player1_26:
CJNE r0, #34h,Player1_34
setb p2.3
Player1_34:
CJNE r0, #35h,Player1_35
setb p2.4
Player1_35:
CJNE r0, #36h,Player1_36
setb p2.5
Player1_36:
CJNE r0, #44h,Player1_44
setb p2.6
Player1_44:
CJNE r0, #45h,Player1_45
setb p2.7
Player1_45:
CJNE r0, #46h,Player1_46
setb p1.7
Player1_46:
clr p1.0 ; Spieler wechseln
JMP MainLoop


PlayerB:
mov @r0,#22h
mov 70h,#11h ; Nächster Spieler: A
CJNE r0, #24h,Player2_24
setb p3.0
Player2_24:
CJNE r0, #25h,Player2_25
setb p3.1
Player2_25:
CJNE r0, #26h,Player2_26
setb p3.2
Player2_26:
CJNE r0, #34h,Player2_34
setb p3.3
Player2_34:
CJNE r0, #35h,Player2_35
setb p3.4
Player2_35:
CJNE r0, #36h,Player2_36
setb p3.5
Player2_36:
CJNE r0, #44h,Player2_44
setb p3.6
Player2_44:
CJNE r0, #45h,Player2_45
setb p3.7
Player2_45:
CJNE r0, #46h,Player2_46
setb p1.6
Player2_46:
clr p1.0
SETB p1.0
JMP MainLoop

SkipP2Sieg:
END
