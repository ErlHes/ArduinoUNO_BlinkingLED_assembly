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
	clc ;sletter carry for � hindre feil
	ldi r28, low(8166) 
	ldi r29, high(8166)
	ldi r30, low(840)
	ldi r31, high(840)
	add r28, r30
	adc r29, r31
	adiw r29:r28, 40
; Oppgave 3

;Her gj�res det litt forarbeid, f�rst klareres DDRB, og s� lastest inn 161
;slik at PINB 0, 5 og 7 blir satt som outputs.
;Deretter Settes PORTB7 og PORTB0 h�y slik at PINB7 og PINB0 toggles til h�y,
;Dette er fordi jeg vil at neste seksjon "CHKBIT" skal kj�re i en undelig l�kke
;til enten PINB0 eller PINB7 blir lav.

	ldi r16, 161
	ldi r17, 0
	out DDRB, r17
	OUT DDRB, r16
	sbi PORTB, PINB7
	sbi PORTB, PINB0
	nop
	nop ;To tomme klokkesykluser slik at I/O rekker � oppdatere seg
CHKBIT:	
;For simulering m� man manuelt sette PINB7 eller PINB0 til lav i I/O for � komme
;ut av denne l�kken.
	sbis PINB,PINB0
	rjmp ToggleBitSET
	sbis PINB,PINB7
	rjmp ToggleBitSET
	rjmp CHKBIT

ToggleBitSet:	; Hovedl�kke for � toggle PINB5 til h�y
	ldi r18, 5	; setter hvor mange ganger vi vil kj�re 250ms l�kka.
Delay_Loop1:	; L�kke 1, denne vil kj�re 5*250ms alts� ~1sekund (L�kka er ca 1,02ms for treg, her kunne jeg ha optimalisert bedre)
	dec r18	; teller ned hovedl�kka
	ldi r19, 250	; Setter hvor mange ganger vi vil kj�re 1ms l�kka
	brne Delay_loop2	; Hopper til neste l�kke s� lenge r18 ikke er 0
	sbi PORTB, PORTB5	; Om r18 er null er l�kka ferdig og PORTB5 toggles h�y slik at PINB5 blir h�y
	rjmp ToggleBitReset	; Hopper s� til Reset l�kka, som er helt identisk strukturert som Set l�kka
Delay_loop2:	; L�kke 2, denne vil kj�re 250*1ms
	dec r19	; Teller ned l�kke 2
	ldi r20, 250	; Setter hvor mange ganger vi vil kj�re 4mikrosekund l�kka
	brne Delay_loop3	; Hopper til 4mikrosekundl�kka s� lenge r19 ikke er 0
	rjmp Delay_loop1	; Hopper tilbake til hovdel�kka om r19 er null
Delay_loop3:	; L�kke 3, denne vil kj�re 250 * 4 mikrosekund @ 1Mhz klokkehastighet, alts� 1ms
	dec r20	; Teller ned l�kke 3
	nop		; Tom klokkesyklus
	brne delay_loop3	; Hopper tilbake til starten hvis l�kka ikke er ferdig telt ned
	rjmp delay_loop2	; Hopper tilbake til l�kke 2 hvis l�kka er ferig telt ned

; Reset l�kka er helt identiskt oppbygt som Set l�kka, og vil ikke bli kommentert da det bare er � finne tilsvarende seksjon ovenfor.
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
