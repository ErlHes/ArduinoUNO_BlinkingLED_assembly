;
; Laboving2.asm
;
; Created: 22-Jan-19 8:42:03 AM
; Author : Erlend Hestvik
;

; Oppgave 1
	ldi r17,3
	ldi r18,5
	mov r0, r18
	out DDRB, r17
	in r0, DDRB
	sts 0x0100, r18
	lds r1, 0x0100
	st x+, r18
	ld r16, x
	push r16
	ldi r16, 99
	pop r16
; Oppgave 2
; 127 + 129
	ldi r20, 127
	ldi r21, 129
	add  r20, r21
; 80 + 48
	ldi r22, 80
	ldi r23, 48
	add r22, r23
; 128 + 40
	ldi r24, 128
	ldi r25, 40
	add r24, r25
; 8166 + 840
	clc ;sletter carry for å hindre feil
	ldi r28, low(8166) 
	ldi r29, high(8166)
	ldi r30, low(840)
	ldi r31, high(840)
	add r28, r30
	adc r29, r31
	adiw r29:r28, 40
; Oppgave 3

;Her gjøres det litt forarbeid, først klareres DDRB, og så lastest inn 161
;slik at PINB 0, 5 og 7 blir satt som outputs.
;Deretter Settes PORTB7 og PORTB0 høy slik at PINB7 og PINB0 toggles til høy,
;Dette er fordi jeg vil at neste seksjon "CHKBIT" skal kjøre i en undelig løkke
;til enten PINB0 eller PINB7 blir lav.

	ldi r16, 161
	ldi r17, 0
	out DDRB, r17
	OUT DDRB, r16
	sbi PORTB, PINB7
	sbi PORTB, PINB0
	nop
	nop ;To tomme klokkesykluser slik at I/O rekker å oppdatere seg
CHKBIT:	
;For simulering må man manuelt sette PINB7 eller PINB0 til lav i I/O for å komme
;ut av denne løkken.
	sbis PINB,PINB0
	rjmp ToggleBitSET
	sbis PINB,PINB7
	rjmp ToggleBitSET
	rjmp CHKBIT

ToggleBitSet:	; Hovedløkke for å toggle PINB5 til høy
	ldi r18, 5	; setter hvor mange ganger vi vil kjøre 250ms løkka.
Delay_Loop1:	; Løkke 1, denne vil kjøre 5*250ms altså ~1sekund (Løkka er ca 1,02ms for treg, her kunne jeg ha optimalisert bedre)
	dec r18	; teller ned hovedløkka
	ldi r19, 250	; Setter hvor mange ganger vi vil kjøre 1ms løkka
	brne Delay_loop2	; Hopper til neste løkke så lenge r18 ikke er 0
	sbi PORTB, PORTB5	; Om r18 er null er løkka ferdig og PORTB5 toggles høy slik at PINB5 blir høy
	rjmp ToggleBitReset	; Hopper så til Reset løkka, som er helt identisk strukturert som Set løkka
Delay_loop2:	; Løkke 2, denne vil kjøre 250*1ms
	dec r19	; Teller ned løkke 2
	ldi r20, 250	; Setter hvor mange ganger vi vil kjøre 4mikrosekund løkka
	brne Delay_loop3	; Hopper til 4mikrosekundløkka så lenge r19 ikke er 0
	rjmp Delay_loop1	; Hopper tilbake til hovdeløkka om r19 er null
Delay_loop3:	; Løkke 3, denne vil kjøre 250 * 4 mikrosekund @ 1Mhz klokkehastighet, altså 1ms
	dec r20	; Teller ned løkke 3
	nop		; Tom klokkesyklus
	brne delay_loop3	; Hopper tilbake til starten hvis løkka ikke er ferdig telt ned
	rjmp delay_loop2	; Hopper tilbake til løkke 2 hvis løkka er ferig telt ned

; Reset løkka er helt identiskt oppbygt som Set løkka, og vil ikke bli kommentert da det bare er å finne tilsvarende seksjon ovenfor.
ToggleBitReset:
	ldi r18, 5
Delay_Loop4:
	dec r18
	ldi r19, 250
	brne Delay_loop5
	cbi PORTB, PORTB5
	rjmp ToggleBitSet
Delay_loop5:
	dec r19
	ldi r20, 250
	brne Delay_loop6
	rjmp Delay_loop4
Delay_loop6:
	dec r20
	nop
	brne delay_loop6
	rjmp delay_loop5

	nop
	
; Replace with your application code
start:
    inc r16
    rjmp start
