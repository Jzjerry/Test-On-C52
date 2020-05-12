		ORG		0000H
		RS 		EQU P2.4
		RW		EQU	P2.5
		E		EQU P2.6
		AJMP	BSTART
		
		ORG		0030H
BSTART:	CLR		EA
		MOV		TMOD,#20H
		MOV		TH1,#0F4H
		MOV		TL1,#0F4H
		MOV		PCON,#00H
		SETB	TR1
		MOV		SCON,#50H

DISPLAY:MOV		P1,#00000001B	;LCD1602 INIT
		ACALL	ENABLE
		MOV		P1,#00111000B
		ACALL	ENABLE
		MOV		P1,#00001111B
		ACALL	ENABLE
		MOV		P1,#00000110B
		ACALL	ENABLE


BLOOP1:	JNB		RI,$
		CLR		RI
		MOV		A,SBUF
		XRL		A,#0E1H
		JNZ		BLOOP1
		MOV		SBUF,#0E2H
		JNB		TI,$
		CLR		TI
		
RECIVE:	JNB		RI,$
		CLR		RI
		
		MOV		R6,#00H
		
		MOV		A,SBUF
		MOV		R4,A
		
		ADD		A,R6
		MOV		R6,A
		
		
		JNB		RI,$		;Stuck here
		CLR		RI
		MOV		A,SBUF
		XRL		A,R6
		JZ		END1
		
		MOV		SBUF,#0FFH	;Sum Doesn't Equal
		JNB		TI,$
		CLR		TI
		SJMP	BLOOP1
		
END1:	MOV		SBUF,#00H
		JNB		TI,$
		CLR		TI

LOOP1:	MOV		A,#0FAH
		XRL		A,R4
		JZ		ENTER
		
		MOV		A,#0FBH
		XRL		A,R4
		JZ		CLEAR
		
		
		SETB	E
		MOV		P1,R4
		SETB	RS
		CLR		RW
		CLR		E
		ACALL	DELAYL
		
		SJMP	RECIVE

DELAY:	MOV		R3,#20H
D1:		MOV		R4,#20H
D2:		MOV		R5,#24H
		DJNZ	R5,$
		DJNZ	R4,D2
		DJNZ	R3,D1
		RET	

CLEAR:	MOV		P1,#00010000B
		ACALL	ENABLE
		AJMP	RECIVE

ENTER:	MOV		P1,#00000110B
		ACALL	ENABLE
		MOV		P1,#0C0H
		ACALL	ENABLE
		AJMP	RECIVE

ENABLE:	CLR		RS
		CLR		RW
		CLR		E
		ACALL	DELAYL
		SETB	E
		RET
DELAYL:	MOV		P1,#0FFH
		CLR		RS
		SETB	RW
		CLR		E
		NOP
		SETB	E
		JB		P1.7,DELAY
		RET
		
		END