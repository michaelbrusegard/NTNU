# Del 3: CharCounter, CharCounterImpl og CharCounterImpl2 (20%)

Oppgaven handler om å telle forekomster av tegn, f.eks. for klassifisering av tekst.
Grensesnittet **CharCounter** (se [CharCounter](CharCounter.java)) dekker de vesentlige metodene
for dette, og oppgaven består i å implementere grensesnittet,
samt en del ekstra *bekvemmelighetsmetoder* (metoder som er kjekke å ha).

For å unngå problemer med følgefeil, så skal dere skrive *bekvemmelighetsmetodene* i den utdelte **CharCounterImpl**-klassen, som allerede implementerer grensesnittet vha. **Map**/**HashMap**.

Deres egen implementasjon skal skrives i **CharCounterImpl2**-klassen (se [CharCounterImpl2](CharCounterImpl2.java)). Dette betyr også at CharCounterImpl2-klassen *ikke* kan bruke en **Map**/**HashMap**, men må bruke andre teknikker/klasser.


## Oppgave A)

Bygg videre på [CharCounterImpl](CharCounterImpl.java)) og implementer konstruktører og metoder som gjenstår:

- **add(CharCounter)** - legger alle tellerne fra CharCounter-argumentet til denne CharCounter-instansen
- **getCountedCharsAsString()** - returnerer alle telte tegn som en String
- **getCharCountIgnoreCase(char)** - som getCharCount, men kombinerer tellere for bokstave som finnes som store/små
- **getCharCount(Predicate)** - returnerer summen av alle tellerne for tegn som tilfredsstiller Predicate-argumentet
- **countChars(String)** - teller tegn (de som støttes) i String-argumentet
- **countChars(Iterator)** - teller tegn (de som støttes) levert av Iterator-argumentet
- **countChars(Iterable)** - teller tegn (de som støttes) levert av Iterable-argumentet
- **countChars(Stream)** - teller tegn (de som støttes) levert av Stream-argumentet
- **countChars(Reader)** - teller tegn (de som støttes) levert av Reader-argumentet
- **countChars(InputStream)** - teller tegn (de som støttes) levert av InputStream-argumentet

For detaljer om oppførsel, se javadoc i filene.

## Oppgave B)

Implementer ferdig grensesnittmetodene i [CharCounterImpl2](CharCounterImpl2.java)):

- **acceptsChar(char)** - bestemmer hvilke tegn som støttes. Bare bokstaver (letter) skal støttes av denne klassen.
- **countChar(char, int)** - øker telleren for tegnet c med den angitte verdien. Utløser unntak hvis tegnet ikke støttes.
- **getCountedChars()** - returnerer settet av alle tegnene som (hittil) er telt
- **getCharCount(c)** - returnerer telleren for det angitte tegnet
- **getTotalCharCount()** - returnerer summen av alle tellerne

For detaljer om oppførsel, se javadoc i filene.
