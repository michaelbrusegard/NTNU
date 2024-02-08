# Eksamen Vår 2022

- **This file in [English](README_en.md)**
- **Denne fila på [nynorsk](README_nn.md)**

Oppgaven består av følgende deler, som ligger inne i hver sin pakke.

- [Del 1](src/main/java/part1/part1_nb.md)
- [Del 2](src/main/java/part2/part2_nb.md) 
- [Del 3](src/main/java/part3/part3_nb.md) 
- [Del 4](src/main/java/part4/part4_nb.md) 
- [Del 5](src/main/java/part5/part5_nb.md) 

## Oppgaveformat

Oppgavebeskrivelsene finner dere under hver del. Det vil si src/main/java/part1/part1.md inneholder oppgavebeskrivelsen for del 1.
Oppgavene har en tekstbeskrivelse, les denne! Ytterligere informasjon kan stå i javadoc-en, som er kommentarer som står før klassedeklarasjonen og metodene i kildekoden.
Dere kan bruke .md-filene til å navigere til riktige filer/klasser som faktisk skal implementeres.
Dersom du mener at javadoc og oppgavebeskrivelse inneholder motstridende informasjon, så gjør en kommentar om dette i [oppgavekommentarer](oppgavekommentarer.md) og
utfør oppgaven slik du mener gir best mening. 


Hvis du ikke skulle klare å implementere en metode i en del kan du selvfølgelig bruke denne videre som om den virket (som i tidligere 'papireksamener').
Merk at metoden bør fortsatt kompilere, alle metoder kompilerer ved hjelp av *dummy* return verdier, som er verdier av riktig type, men ikke korrekte.

Kode som ikke kompilerer vil gi trekk.

Unntak i koden som NullPointerException er ikke kompileringsproblemer (men vil selvfølgelig ikke gi full poengsum). Dere bør teste deres egen kode slik at dere vet at denne kjører. For å hjelpe med dette har de fleste deler main-metode som inneholder noe kode for å teste implementeringen. Disse main-metodene tester ikke nødvendigvis alle tilfeller så du oppfordres til å utvide med dine egne tester. Denne koden bør fortsatt kompilere, men trenger ikke fjernes ved levering. 

## Navigering

Oppgavebeskrivelsene kan brukes som hjelp til å navigere til riktige filer. Når du har åpent en .md-fil kan du trykke på **Preview**-ikon for å få dette på en mer leselig måte. 

Alle metodene dere skal fylle inn er og markert med // TODO.
Disse kan du få en oversikt over i VSCode med Ctrl + Shift + F (søk i hele åpne mappe)

## Besvarelse

*Oppgaveteksten* finnes i  **partx.md**-filer og andre md-filer i prosjektet og kan leses både på gitlab og i IDE-en. Versjoner på nynorsk og engelsk finnes i egne filer. 

Oppgaven *besvares* ved å bygge videre på kode-filene som er der, og fylle inn evt antakelser du gjør, i en separat md-fil (oppgavekommentarer.md)


## Nedlasting og import 
Se beskrivelsen i Inspera.
## Levering
Når eksamen skal leveres kan du gjøre dette på denne måten:

### Levering i VSCode

**Zippe i Windows**

- Høyreklikk på et **tomt område** i 'Explorer' helt til venstre i VSCode. Dette vil være under 'nederste' fil i ytterste mappe.
- Velg **'Reveal in File Explorer'** fra nedtrekksmenyen som dukker opp.
- Du skal nå få opp et utforskervindu (ikke i VSCode, men i Windows). Her skal mappen som inneholder prosjektfolderen vi skal komprimere allerede være markert, men dobbeltsjekk at dette stemmer.
- Høyreklikk på prosjektmappen (den skal hete **exam** eller tilsvarende hvis du har endret navn)
- Velg **'Send til' -> 'Komprimert (zippet) mappe'**.
- Windows komprimerer nå prosjektmappen **exam**, og spør deg hva den skal kalles. La den hete det som foreslås.
- Denne zipfilen er filen dere skal laste opp til Inspera til slutt.
- Dere finner et par bilder av prosessen til slutt i denne filen.

**Zippe i macOS (OS X)**

- Følg instruksjonene som for Windows overfor, men ting har andre navn.
- Høyreklikk på et tomt område i **Explorer** helt til venstre i VSCode og velg **'Reveal in Finder'**
- Høyreklikk prosjektmappen som nå skal være markert og velg **'Komprimer'**.
- Filen du får er den som skal lastes opp til Inspera.

Vær nøye med at du velger riktig mappe!


### For eclipse

**Zippe i Windows**

- Høyreklikk på prosjektikonet i 'Package Explorer' helt til venstre i Eclipse.
- Velg 'Show in' -> click 'System Explorer'.
- Du skal nå få opp et utforskervindu (ikke i Eclipse, men i Windows) som står åpent i en folder som sannsynligvis slutter på git. For meg er det _'C:\Users\borgeha\git'_ Denne folderen inneholder prosjektfolderen vi skal komprimere.
- Høyreklikk prosjektfolderen, den skal hete kont2021 -> meny 'Send til' -> 'Komprimert (zippet) mappe'. 
- Windows komprimerer nå prosjektfolderen kont2021, og spør deg hva den skal kalles La den hete det som foreslås.
- Denne zipfilen er filen dere skal laste opp til Inspera til slutt.
- Dere finner et par bilder av prosessen til slutt i denne filen.

**Zippe i OS X**

- Følg instruksjonene som for Windows overfor, men ting har andre navn.
- Høyreklikk prosjektet i Eclipse -> 'Åpne i Finder'
- Høyreklikk prosjektfolderen og velg 'Komprimer'
- Filen du får er den som skal lastes opp til Inspera.

**System Explorer i VSCode**

<img src="images/System_Explorer_VSCode.png" alt="drawing" width="600"/>

**System Explorer i Eclipse**

<img src="images/System_Explorer.png" alt="drawing" width="600"/>

**Komprimering av eksamensbesvarelse**

<img src="images/Compress.png" alt="drawing" width="600"/>
