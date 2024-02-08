# Del 2 (25%)

## Oppgave A)

Klassen [**DecreasingStack**](DecreasingStacks.java) implementerer en *stack* av heltall,
med den spesielle regelen at et nytt element må være *mindre enn* de foregående.

Følgende metoder skal implementeres:

- isEmpty(): sier om den er tom
- push(int n): legger n til som øverste elemente, men bare hvis det er mindre enn de andre
- peek() returnerer det øverste elementet, uten å endre noe
- pop(): som peek(), men fjerner også elementet

I tillegg må en konstruktør og **toString()**-metoden implementeres.

For detaljer om oppførsel, se javadoc i filene.

## Oppgave B)

Klassen [**DecreasingStacks**](DecreasingStacks.java) fungerer også som en slags *stack*, og bruker en samling instanser av **DecreasingStack**.

Fullfør implementasjonen av følgende metoder: 

- isEmpty(): sier om den er tom
- push(int n): legger n til den første **DecreasingStack**-instansen som tar i mot den, evt. lager en ny **DecreasingStack**
- pop(): returnerer og fjerner det aller minste elementet
- popAll(): returnerer (og fjerner) alle elementene i stigende rekkefølge (altså minste først)

For detaljer om oppførsel, se javadoc i filene.

## Oppgave C)

Skriv en testklasse for **DecreasingStack**, som tester **push**- og **pop**-metodene (og implisitt en eller flere andre metoder). Denne klassen ligger i test-mappen.
