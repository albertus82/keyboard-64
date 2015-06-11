   10 rem **** pianoforte elettronico ****
  100 si = 54272: rem sid base
  110 cn = 1022727: rem clock ntsc in hz
  120 cp = 985248 : rem clock pal in hz
  130 z  = 0
  140 p  = 1:  rem polifonia (attiva)
  150 wf = 16: rem forma d'onda triang.
  160 m  = 1
  170 ok = 1:  rem ottava piu' alta
  180 hb = 256
  190 sp = 0:  rem flag sust. permanente
  200 mr = 8:  rem release minimo
  220 an = 0:  rem attack  (0-15)
  230 ab = 0:  rem decay   (0-15)
  240 ha = 15: rem sustain (0-15)
  270 au = 11: rem release (0-15)
  280 er = 2 ^ (1/12): rem rapporto tra i semitoni nel temperamento equabile
  290 def fn sidf(f) = (f * 5.8) + 30
  300 gosub 60000: rem reset sid
  500 rem configurazione schermo...
  600 poke 53280, 9: rem colore bordi
  650 poke 53281, 0: rem colore sfondo
  800 print chr$(5): rem colore carattere
  900 print chr$(147): rem clear screen
  950 poke 53272, 23: rem minuscolo
  999 rem schermo configurato.
 1000 rem stampa dell'interfaccia
 1020 print " ******* Pianoforte elettronico ******* "
 1040 print "{rvon}{CBM-K} {rght} {rght} {SHIFT--} {rght} {rght} {rght} {SHIFT--} {rght} {rght} {SHIFT--} {rght} {rght} {rght} {SHIFT--} {rght} {rght} {SHIFT--} {rght} {rght} "
 1050 print"{up}{rvon}{CBM-K} {rght} {rght} {SHIFT--} {rght} {rght} {rght} {SHIFT--} {rght} {rght} {SHIFT--} {rght} {rght} {rght} {SHIFT--} {rght} {rght} {SHIFT--} {rght} {rvof}D{rvon} "
 1100 print"{up}{rvon}{CBM-K} {rvof}S{rvon} {rvof}D{rvon} {SHIFT--} {rvof}G{rvon} {rvof}H{rvon} {rvof}J{rvon} {SHIFT--} {rvof}2{rvon} {rvof}3{rvon} {SHIFT--} {rvof}5{rvon} {rvof}6{rvon} {rvof}7{rvon} {SHIFT--} {rvof}9{rvon} {rvof}0{rvon} {SHIFT--} {rvof}-{rvon} {rvof}e{rvon} "
 1200 print"{up}{rvon}{CBM-K} {rght} {rght} {SHIFT--} {rght} {rght} {rght} {SHIFT--} {rvof}L{rvon} {rvof}:{rvon} {SHIFT--} {rght} {rght} {rght} {SHIFT--} {rght} {rght} {SHIFT--} {rght} {rvof}l{rvon} "
 1300 print"{up}{rvon}{CBM-K} {SHIFT--} {SHIFT--} {SHIFT--} {SHIFT--} {SHIFT--} {SHIFT--} {SHIFT--} {SHIFT--} {SHIFT--} {SHIFT--} {SHIFT--} {SHIFT--} {SHIFT--} {SHIFT--} {SHIFT--} {SHIFT--} {SHIFT--} {SHIFT--} {SHIFT--}R"
 1350 print"{up}{rvon}{CBM-K}Z{SHIFT--}X{SHIFT--}C{SHIFT--}V{SHIFT--}B{SHIFT--}N{SHIFT--}M{SHIFT--}Q{SHIFT--}W{SHIFT--}E{SHIFT--}R{SHIFT--}T{SHIFT--}Y{SHIFT--}U{SHIFT--}I{SHIFT--}O{SHIFT--}P{SHIFT--}@{SHIFT--}*{SHIFT--}e"
 1400 print"{up}{rvon}{CBM-K} {SHIFT--} {SHIFT--} {SHIFT--} {SHIFT--} {SHIFT--} {SHIFT--} {SHIFT--},{SHIFT--}.{SHIFT--}/{SHIFT--} {SHIFT--} {SHIFT--} {SHIFT--} {SHIFT--} {SHIFT--} {SHIFT--} {SHIFT--} {SHIFT--} {SHIFT--}t"
 1405 print
 1407 print"Selezionare il temperamento desiderato:": print
 1410 print"(M)esotonico 1/4 c.",
 1412 print"(K)irnberger III"
 1414 print
 1416 print"(W)erckm. I (III)",
 1418 print"(E)quabile"
 1420 get t$: if t$<>"e" and t$<>"m" and t$<>"k" and t$<>"w" then 1420
 1425 print"{up}                                        ":dt$="{up}{up}{up}{up}{up}{up}Temperamento: "
 1430 if t$="e" then print dt$+"{rvon}Equabile{rvof}                 "
 1435 if t$="m" then print dt$+"{rvon}Mesotonico 1/4 comma{rvof}     "
 1440 if t$="k" then print dt$+"{rvon}Kirnberger III{rvof}           "
 1442 if t$="w" then print dt$+"{rvon}Werckmeister I (III){rvof}     "
 1445 print"{down}                                        {up}{up}"
 1450 input"La (in Hz, 200-960, default 440)"; la$
 1460 la = val(la$)
 1480 if la<200 or la>963 then la=440: print"{up}{up}" spc(34) "440   "
 1500 gosub 8000: rem gui ottave
 1550 gosub 8500: rem gui polifonia
 1600 gosub 9000: rem gui waveform
 1700 gosub 7000: rem gui sustain
 1800 print"Accordatura in corso..."
 1900 rem tasti che compongono la scala
 1910 k$ = "zsxdcvgbhnjmq2w3er5t6y7ui9o0p@-*" + chr$(20) + chr$(13)
 1920 nt = len(k$): rem numero tasti
 1930 dim f( nt )
 1970 dim k( 255 )
 2000 gosub 50000: rem accordatura
 2100 for i = 1 to nt
 2200 k(asc(mid$(k$, i))) = i
 2300 next i
 2540 as = (an*16) + ab: rem (atta/deca)
 2550 hh = (ha*16) + au: rem (sust/rele)
 2600 for i = 0 to 2: rem per ogni voce
 2630 poke si + 5 + (i * 7), as: rem imposta attack/decay
 2670 poke si + 6 + (i * 7), hh: rem imposta sustain/release
 2700 poke si + 2 + (i * 7), 4000 and 255: rem imposta pulse width low
 2730 poke si + 3 + (i * 7), 4000 / 256:   rem imposta pulse width high
 2770 next i
 2800 poke si + 24, 15 + 16 + 64: rem volume massimo + filtri lp & hp attivi
 2830 poke si + 23, 7: rem filtri attivi per tutte le voci; risonanza non attiva
 2900 print "{up}{rvon}Tastiera pronta. 'Run/Stop' per uscire. {rvof}"
 3000 rem *** ciclo di funzionamento ***
 3010 get a$:if a$="" then 3010
 3020 if a$="," then a$="q": goto 3100
 3030 if a$="l" then a$="2": goto 3100
 3040 if a$="." then a$="w": goto 3100
 3050 if a$=":" then a$="3": goto 3100
 3060 if a$="/" then a$="e"
 3100 fr = f(k(asc(a$))) / m
 3110 if fr=z then 5000
 3120 fh = int(fr / hb)
 3140 fl = si+(v*7): rem indirizzo di base della voce corrente
 3160 w  = fl+4
 3200 poke fl+6, z: poke fl+5, z: rem reset adsr
 3300 poke w, 8: poke w, 0
 3400 poke fl, fr - (hb * fh)
 3500 poke fl+1, fh
 3550 if as<>z then poke fl+5, as
 3600 poke fl+6, hh
 3700 poke w, wf+1
 3750 if sp=0 then for i=1 to 50*an: next: poke w, wf
 3800 if p=1 then v=v+1: if v=3 then v=0
 3900 goto 3010
 3999 rem ** fine ciclo funzionamento **
 5000 rem ******* tasti funzione *******
 5010 if a$ = chr$(133) then m = 8: ok = 4: gosub 8000: goto 3000
 5150 if a$ = chr$(137) then m = 4: ok = 3: gosub 8000: goto 3000
 5200 if a$ = chr$(134) then m = 2: ok = 2: gosub 8000: goto 3000
 5300 if a$ = chr$(138) then m = 1: ok = 1: gosub 8000: goto 3000
 5400 if a$ = chr$(135) then wf = 16: gosub 9000: goto 3000
 5500 if a$ = chr$(139) then wf = 32: gosub 9000: goto 3000
 5600 if a$ = chr$(136) then wf = 64: gosub 9000: goto 3000
 5700 if a$ = chr$(140) then wf =128: gosub 9000: goto 3000
 5800 if a$ = "{rght}" then gosub 6000: goto 3000
 5850 if a$ = "{down}" then gosub 6500: goto 3000
 5900 if a$ = " " then p=1-p: gosub 8500: goto 3000: rem spazio
 5950 if a$ = chr$(19) then print a$: run: rem home
 5999 goto 3000
 6000 rem *** regolazione del sustain **
 6100 if sp=1 then return: rem era gia' al massimo
 6200 if au=15 and sp=0 then sp=1: goto 6900
 6300 au=au+1
 6499 goto 6800
 6500 if au=mr then return: rem era gia' al minimo
 6600 if au=15 and sp=1 then sp=0: goto 6900
 6700 au=au-1
 6800 hh=(ha*16) + au
 6900 gosub 7000: rem aggiorna la gui
 6999 return
 7000 rem ********* gui sustain ********
 7050 print"{home}{down}{down}{down}{down}{down}{down}{down}{down}{down}{down}{down}{down}{down}{down}{down}{down}{down}{down}"
 7100 su$="": for i=mr to 16: su$=su$+".": next
 7200 print"'CuRSoRi' sustain: min ["su$"] max"
 7300 print "{up}"spc(24+(au-mr+sp))"*":print
 7900 return
 8000 rem **** gui selezione ottave ****
 8050 print"{home}{down}{down}{down}{down}{down}{down}{down}{down}{down}{down}{down}{down}{down}{down}"
 8100 print"'F1,F2,F3,F4' altezza"
 8150 if ok = 4 then print"{up}{up}{rght}{rvon}F1{rvof}": return
 8200 if ok = 3 then print"{up}{up}{rght}{rght}{rght}{rght}{rvon}F2{rvof}": return
 8250 if ok = 2 then print"{up}{up}{rght}{rght}{rght}{rght}{rght}{rght}{rght}{rvon}F3{rvof}": return
 8300 if ok = 1 then print"{up}{up}{rght}{rght}{rght}{rght}{rght}{rght}{rght}{rght}{rght}{rght}{rvon}F4{rvof}": return
 8500 rem ******** gui polifonia *******
 8550 print"{home}{down}{down}{down}{down}{down}{down}{down}{down}{down}{down}{down}{down}{down}{down}"
 8600 print"{rght}{rght}{rght}{rght}{rght}{rght}{rght}{rght}{rght}{rght}{rght}{rght}{rght}{rght}{rght}{rght}{rght}{rght}{rght}{rght}{rght}{rght}- 'Spc' polifonia "
 8700 if p=1 then print"{up}{up}{rght}{rght}{rght}{rght}{rght}{rght}{rght}{rght}{rght}{rght}{rght}{rght}{rght}{rght}{rght}{rght}{rght}{rght}{rght}{rght}{rght}{rght}{rght}{rght}{rght}{rvon}Spc{rvof}"
 8900 return
 9000 rem *** gui selez. forma d'onda **
 9050 print"{home}{down}{down}{down}{down}{down}{down}{down}{down}{down}{down}{down}{down}{down}{down}{down}{down}"
 9100 print"'F5,F6,F7,F8' forma onda - 'Home' reset "
 9200 if wf = 16 then print"{up}{up}{rght}{rvon}F5{rvof}": return
 9300 if wf = 32 then print"{up}{up}{rght}{rght}{rght}{rght}{rvon}F6{rvof}": return
 9400 if wf = 64 then print"{up}{up}{rght}{rght}{rght}{rght}{rght}{rght}{rght}{rvon}F7{rvof}": return
 9500 if wf =128 then print"{up}{up}{rght}{rght}{rght}{rght}{rght}{rght}{rght}{rght}{rght}{rght}{rvon}F8{rvof}"
 9900 return
 10000 rem ****** equabile 12-tet ******
 10100 for i = 1 to nt
 10200 f(i) = fn sidf(f1)
 10300 f1 = f1 * er
 10400 next i
 10999 return
 19000 rem **** werckmeister i (iii) ***
 19100 data "w", 1.0534: rem c#
 19150 data "w", 1.1173: rem d
 19200 data "w", 1.1851: rem d#
 19250 data "w", 1.2527: rem e
 19300 data "w", 1.3333: rem f
 19350 data "w", 1.4044: rem f#
 19400 data "w", 1.4948: rem g
 19450 data "w", 1.5801: rem g#
 19500 data "w", 1.6702: rem a
 19550 data "w", 1.7777: rem a#
 19600 data "w", 1.8790: rem b
 19650 data "w", 2     : rem c
 24000 rem **** mesotonico 1/4 comma ***
 24100 data "m", 1.0449: rem c#
 24150 data "m", 1.1180: rem d
 24200 data "m", 1.1963: rem d#
 24250 data "m", 1.2500: rem e
 24300 data "m", 1.3375: rem f
 24350 data "m", 1.3976: rem f#
 24400 data "m", 1.4954: rem g
 24450 data "m", 1.5625: rem g#
 24500 data "m", 1.6718: rem a
 24550 data "m", 1.7888: rem a#
 24600 data "m", 1.8692: rem b
 24650 data "m", 2     : rem c
 34000 rem ******* kirnberger iii ******
 34100 data "k", 1.0535: rem c#
 34150 data "k", 1.1180: rem d
 34200 data "k", 1.1852: rem d#
 34250 data "k", 1.2500: rem e
 34300 data "k", 1.3333: rem f
 34350 data "k", 1.4063: rem f#
 34400 data "k", 1.4953: rem g
 34450 data "k", 1.5802: rem g#
 34500 data "k", 1.6719: rem a
 34550 data "k", 1.7778: rem a#
 34600 data "k", 1.8750: rem b
 34650 data "k", 2     : rem c
 50000 rem ******** accordatura ********
 50020 do = 766.67: rem costante di intonaz. del 'do' equabile con 'la' a 440 hz
 50030 if peek(678) = 0 then do = do / (cn / cp): rem compensaz. diff. pal/ntsc
 50050 f1 = do / 440 * la: rem intonazione in base al 'la' scelto dall'utente
 50100 if t$="e" then gosub 10000: return: rem l'equabile non richiede i 'data'
 50150 dim ra(11): rem array che conterra' i rapporti del temperamento scelto
 50160 restore
 50170 for i = 0 to 11
 50180 read r$, r: if r$ <> t$ then 50180: rem lettura rapporti temperamento
 50190 ra(i) = r
 50200 next i
 50350 restore
 50400 ld = er ^ 9: rem rapporto 'la'/'do' del temperamento equabile
 50500 de = ld / ra(8): rem deriva del 'la' rispetto al 'la' equabile
 50600 f1 = f1 * de: rem regolazione fine del 'do' per avere il 'la' desiderato
 50650 f0 = f1: rem frequenza del primo 'do' (sara' moltiplicata per i rapporti)
 50680 j = 0
 50700 for i = 1 to nt: rem accordatura di tutti i tasti
 50900 f(i) = fn sidf(f1)
 51000 f1 = f0 * ra(j)
 51100 if ra(j) < 2 then j = j + 1: next i: rem rapporto semitono successivo
 51150 if ra(j) = 2 then j = 0: f0 = f1: next i: rem 'do' alzato di un'ottava
 51400 return
 60000 rem ********* reset sid *********
 60100 for i = 0 to 28
 60200 poke si + i, 0
 60300 next i
 60400 rem reset sid completato.
 60999 return
