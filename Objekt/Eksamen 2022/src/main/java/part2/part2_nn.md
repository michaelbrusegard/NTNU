# Del 2 (25%)

## Oppgave A)

Klassen [**DecreasingStack**](DecreasingStacks.java) implementerer ein *stack* av heiltal,
med den spesielle regelen at eit nytt element må vera mindre enn* dei førre.

Følgjande metodar skal implementerast:

- isEmpty(): seier om han er tom
- push(int n): legg n til som øvste elemente, men berre viss det er mindre enn dei andre
- peek() returnerer det øvste elementet, utan å endra noko
- pop(): som peek(), men fjernar òg elementet

I tillegg må ein konstruktør og **toString()*-metoden blir implementert.

For detaljer om åtferd, sjå javadoc i filene.

## Oppgave B)

Klassen [**DecreasingStacks**](DecreasingStacks.java) fungerer òg som ein slags *stack*, og bruker ei samling instansar av **DecreasingStack**.

Fullfør implementasjonen av følgjande metodar:

- isEmpty(): seier om ho er tom
- push(int n): legg n til den første **DecreasingStack*-instansen som tar i mot han, evt. lagar ein ny **DecreasingStack*
- pop(): returnerer og fjernar det aller minste elementet
- popAll(): returnerer (og fjernar) alle elementa i stigande rekkefølgje (altså minste først)

For detaljar om åtferd, sjå javadoc i filene.

## Oppgave C)

Skriv ein testklasse for **DecreasingStack**, som testar **push*- og *pop*-metodane (og implisitt ein eller fleire andre metodar). Klassen ligg i test-mappa.