# Del 4 - CharCounter og filbehandling (25%)

Denne delen kombinerer **CharCounter** og filbehandling.

I oppgåve A så skal de definera eit tekstfilformat for **CharCounter** og implementera lagring av det.
I oppgåve B, så skal de telja teikn i tekst frå filer.

## Oppgave A)

De skal implementera fillagring for **CharCounter** ved å implementera **CharCounterFileFormat*
(sjå [CharCounterFileFormat](CharCounterFileFormat.java) i klassen **CharCounterFileFormatImpl**.

Lagringsformatet skal vera tekstlig og ideelt sett generelt nok til å takla teljing av alle typar teikn, også blanke og linjeskift. Dokumenter formatet tekstlig som javadoc øvst i klassen og lag ein eksempelfil [CharCounterFileFormat-sample.txt](CharCounterFileFormat-sample.txt) som illustrerer formatet.

Implementer dei nødvendige metodane:

- *save(CharCounter, OutputStream)** - skriv innhaldet i CharCounter-argumentet til OutputStream-argumentet iht. tekstformatet du har definert. Det som blir skrive skal kunna lesast med load-metodene.
- **CharCounter load(InputStream)** - opprettar ein CharCounterImpl-instans med innhald lese frå InputStream-argumentet iht. tekstformatet. Tekst skrive av save-metoden skal attskapa ein tilsvarande CharCounter-instans.
- **void loadInto(CharCounter charCounter, InputStream)** - utvidar ein eksisterande CharCounter-instans med innhald lese frå InputStream-argumentet iht. tekstformatet

## Oppgave B)

Implementer metodane i **CharCounterUtil** i [CharCounterUtil.java](CharCounterUtil.java)

- **CharCounter countLetters(File)** - tel teikna i File-argumentet
- **computeDistance(CharCounter, CharCounter)** - måler "avstanden" mellom to CharCounter-instanser ved å berekna forholdstalet for kvart teikn (teljaren for teiknet delt på det samla talet teikn) og summera kvadratet av differansen mellom denne verdien for same teikn i dei to argumenta.

Til dømes, viss ein CharCounter tel 2 A-ar, 3 B-ar (og ingen C), og den andre tel 2 B-ar, 1 C, (men ingen A), så får vi følgjande utrekningar:
- forholdstal (relative frekvensar) for A, B and C: $\frac25, \frac35, \frac05$ and $\frac03, \frac23, \frac13$
- Avstanden er då gitt ved uttrykket
  $$\left(\frac25-\frac03\right)^2 + \left(\frac35 - \frac23\right)^2 + \left(\frac05-\frac13\right)^2$$
Gjer utrekninga med flyttal.

- **unmodifiableCharCounter(CharCounter)** - returner ein instans av (ein klasse som implementerer) CharCounter, som delegerer til argumentet, men utløyser unntak for metodar som prøver å endra på han.