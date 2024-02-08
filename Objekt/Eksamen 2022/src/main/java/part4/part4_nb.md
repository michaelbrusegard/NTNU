# Del 4 - CharCounter og filbehandling (25%)

Denne delen kombinerer **CharCounter** og filbehandling.

I oppgave A så skal dere definere et tekstfilformat for **CharCounter** og implementere lagring av det.
I oppgave B, så skal dere telle tegn i tekst fra filer.

## Oppgave A)

Dere skal implementere fillagring for **CharCounter** ved å implementere **CharCounterFileFormat**
(se [CharCounterFileFormat](CharCounterFileFormat.java) i klassen **CharCounterFileFormatImpl**.

Lagringsformatet skal være tekstlig og ideelt sett generelt nok til å takle telling av alle typer tegn, også blanke og linjeskift. Dokumenter formatet tekstlig som javadoc øverst i klassen og lag en eksempelfil [CharCounterFileFormat-sample.txt](CharCounterFileFormat-sample.txt) som illustrerer formatet.

Implementer de nødvendige metodene:

- **save(CharCounter, OutputStream)** - skriver innholdet i CharCounter-argumentet til OutputStream-argumentet iht. tekstformatet du har definert. Det som skrives skal kunne leses med load-metodene.
- **CharCounter load(InputStream)** - oppretter en CharCounterImpl-instans med innhold lest fra InputStream-argumentet iht. tekstformatet. Tekst skrevet av save-metoden skal gjenskape en tilsvarende CharCounter-instans.
- **void loadInto(CharCounter charCounter, InputStream)** - utvider en eksisterende CharCounter-instans med innhold lest fra InputStream-argumentet iht. tekstformatet

## Oppgave B)

Implementer metodene i **CharCounterUtil** i [CharCounterUtil.java](CharCounterUtil.java)

- **CharCounter countLetters(File)** - teller tegnene i File-argumentet
- **computeDistance(CharCounter, CharCounter)** - måler "avstanden" mellom to CharCounter-instanser ved å beregne forholdstallet (relativ frekvens) for hvert tegn (telleren for tegnet delt på totalt antall tegn) og summere kvadratet av differansen mellom denne verdien for samme tegn i de to argumentene. 

For eksempel, hvis en CharCounter teller 2 A'er, 3 B'er (og ingen C), og den andre teller 2 B'er, 1 C, (men ingen A), så får vi følgende beregninger:
- forholdstall (relative frekvenser) for A, B and C: $\frac25, \frac35, \frac05$ and $\frac03, \frac23, \frac13$
- Avstanden er da gitt ved uttrykket
  $$\left(\frac25-\frac03\right)^2 + \left(\frac35 - \frac23\right)^2 + \left(\frac05-\frac13\right)^2$$
Gjør utregningen med flyttall.

- **unmodifiableCharCounter(CharCounter)** - returner en instans av (en klasse som implementerer) CharCounter, som delegerer til argumentet, men utløser unntak for metoder som prøver å endre på den.
