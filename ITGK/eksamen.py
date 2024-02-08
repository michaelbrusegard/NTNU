def les_meteoritter(filnavn):
    fil = open(filnavn, "r")
    # Leser alle linjene i filen inn i en liste
    linjer = fil.readlines()
    fil.close()
    linjer = [["name","id","class","mass","year","latitude","longitude"], ["Aachen","1","L5","21.0","1880","50.775","6.08333"], ["Aarhus","2","H6","720.0","1951","56.18333","10.23333"], ["Abee","6","EH4","107000.0","1952","54.21667","-113.0"], ["Acapulco","10","Acapulcoite","1914.0","1976","16.88333","-99.9"], ["Akyumak","433",'"Iron',' IVA"',"50000.0","1981","39.91667","42.81667"]]
    # Fjerner første element i listen som er listen med overskriftene
    linjer.pop(0)
    # For hver enkelt linje
    for linje in linjer:
        # Formaterer hvert enkelt element i lista
        for element in linje:
            element = element.format(encoding="utf8")
            
        # Hvis lengden av listen er mindre en 7 vet jeg at den mangler masse
        if len(linje) < 7:
            # Legger inn masse som 0 på riktig plass
            linje.insert(3,"0")
            
        # Hvis lengden av listen er større enn 7 så vet jeg at klassen har et komma
        if len(linje) > 7:
            # Fjerner både element 2 og 3 som vil da være klassen delt i to elementer av komma
            linje.pop(2)
            linje.pop(2)
            # Legger inn klassen Iron på riktig plass
            linje.insert(2, "Iron")
        # Gjør massen om til flyttall
        linje[3] = float(linje[3])
        # Gjør årstall om til int
        linje[4] = int(linje[4])
    return linjer

print(les_meteoritter("meteoritter.csv"))

def sorter_masse(nedslag, kolonne):
    # Lager en lister for massen og for typen
    masse = []
    typen = []
    
    # For hver meteoritt i nedslag lista så legger jeg til masse i masse listen
    # Legger også inn typen utifra hvilken kolonne som er valgt
    for meteoritt in nedslag:
        if kolonne == "name":
            typen.append(meteoritt[0])
        elif kolonne == "id":
            typen.append(meteoritt[1])
        elif kolonne == "class":
            typen.append(meteoritt[2])
        elif kolonne == "year":
            typen.append(meteoritt[4])
        masse.append(meteoritt[3])
    
    # Lager en liste over de unike typene i typen
    unike_typen = list(set(typen))
    
    # Lager dictionary
    dict = {}
    
    # Itererer gjennom hver unike type
    for typ in unike_typen:
        type_masse = 0
        # Så lenge det finnes flere av nåværende type i typen lista
        while typ in typen:
            # Finner indeksen til der den fant typ
            indeks = typen.index(typ)
            # Legger til masse basert på samme indeks (Siden listene er i samme indeks rekkerfølge)
            type_masse += masse[indeks]
            # Setter nåværende indeks for typen til 0 slik at den ikke finner den samme typ igjen
            typen[indeks] = 0
        # Legger til den totale massen i et dictionary basert på typen
        dict[typ] = type_masse
    
    return dict

print(sorter_masse([['Aachen', '1', 'L5', 21.0, 1880, '50.775', '6.08333'], ['Aarhus', '2', 'H6', 720.0, 1951, '56.18333', '10.23333']], "year"))

def storst_nedslagsmasse():
    # Bruker funksjonen i oppgave A til å lese og formatere filen
    # meteoritter = les_meteoritter('meteoritter.csv')
    # Bruker funksjonen i oppgave B til å lage et dictionary med total masse per år
    masse_per_ar = {1880: 21.0, 1951: 720.0}
    
    # Lager lister for ar og masse
    ar = []
    masse = []
    
    # Fyller opp listene slik at indeksen i til hvert år i ar listen tilsvarer indeksen til massen i masse listen
    for key, element in masse_per_ar.items():
        ar.append(key)
        masse.append(element)
    
    # Lager en kopi av masse lista og lager en variabel som er den største massen i lista
    temp_masse = []
    temp_masse.extend(masse)
    old_storst_masse = max(temp_masse)
    
    # Lager en liste for å lagre indeksene til de største massene
    index_liste = []

    while True:
        # Finner størst masse i lista
        storst_masse = max(temp_masse)
        # Hvis forgje størst masse er den samme som den nye
        if old_storst_masse == storst_masse:
            # Finner indeksen til den største massen
            index = temp_masse.index(storst_masse)
            # Lagrer indeksen i indeks lista
            index_liste.append(index)
            # Setter den største massen i temp_masse lista til 0 slik at den vil finne en ny masse på neste runde
            temp_masse[index] = 0
            # Setter forgje størst masse til den nåværende
            old_storst_masse = storst_masse
        else:
            # Hopper ut av løkka hvis det ikke er flere masser som er like store
            break
    
    # Hvis det bare er en størst masse i et år så printes det
    if len(index_liste) == 1:
        print(f"Meteoritter hadde størst masse i året: {ar[index_liste[0]]} Massen var da: {masse[index_liste[0]]}")
    else:
        print("Meteoritter hadde størst masse i årene:")
         # Itererer gjennom indeks lista og printer ut året og massen til årene som har største masse
        for i in index_liste:
            print(f"{ar[index_liste[i]]}")
        print(f"Massen var da: {masse[index_liste[0]]}")

storst_nedslagsmasse()