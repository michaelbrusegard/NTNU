# Del 3: CharCounter, CharCounterImpl og CharCounterImpl2 (20%)

Oppgåva handlar om å telja førekomstar av teikn, t.d. for klassifisering av tekst.
Grensesnittet **CharCounter** (sjå [CharCounter](CharCounter.java)) dekker dei vesentlege metodane
for dette, og oppgåva består i å implementera grensesnittet,
og dessutan ein del ekstra *bekvemmelighetsmetoder* (metodar som er kjekke å ha).

For å unngå problem med følgjefeil, så skal de skriva *bekvemmelighetsmetodene* i den utdelte **CharCounterImpl*-klassen, som allereie implementerer grensesnittet vha. **Map*/**HashMap**. Deira eigen implementasjon skal skrivast i **CharCounterImpl2*-klassen (sjå [CharCounterImpl2](CharCounterImpl2.java)). Dette betyr òg at CharCounterImpl2-klassen ikkje* kan bruka ein **Map*/**HashMap**, men må bruka andre teknikkar/klassar.


## Oppgave A)

Bygg vidare på [CharCounterImpl](CharCounterImpl.java)) og implementer konstruktørar og metodar som #gjenstå:

- **add(CharCounter)** - legg alle teljarane frå CharCounter-argumentet til denne CharCounter-instansen
- **getCountedCharsAsString()** - returnerer alle talde teikn som ein String
- **getCharCountIgnoreCase(char)** - som getCharCount, men kombinerer teljarar for boktave som finst som store/små
- **getCharCount(Predicate)** - returnerer summen av alle teljarane for teikn som tilfredsstiller Predicate-argumentet
- **countChars(String)** - tel teikn (dei som blir støtta) i String-argumentet
- **countChars(Iterator)** - tel teikn (dei som blir støtta) levert av Iterator-argumentet
- **countChars(Iterable)** - tel teikn (dei som blir støtta) levert av Iterable-argumentet
- **countChars(Stream)** - tel teikn (dei som blir støtta) levert av Stream-argumentet
- **countChars(Reader)** - tel teikn (dei som blir støtta) levert av Reader-argumentet
- **countChars(InputStream)** - tel teikn (dei som blir støtta) levert av InputStream-argumentet

For detaljar om åtferd, sjå javadoc i filene.

## Oppgave B)

Implementer ferdig grensesnittmetodane i [CharCounterImpl2](CharCounterImpl2.java)):

- **acceptsChar(char)** - bestemmer kva teikn som blir støtta. Berre bokstavar (letter) skal støttast av denne klassen.
- **countChar(char, int)** - aukar teljaren for teikna c med den angitte verdien. Utløyser unntak viss teikna ikkje blir støtta.
- **getCountedChars()** - returnerer settet av alle teikna som (hittil) er telt
- **getCharCount(c)** - returnerer teljaren for det angitte teiknet
- **getTotalCharCount()** - returnerer summen av alle teljarane

For detaljar om åtferd, sjå javadoc i filene.