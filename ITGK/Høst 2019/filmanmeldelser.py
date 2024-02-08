GENRES = ("Action", "Adventure", "Adult", "Animation", "Comedy", "Crime", "Documentary", "Drama", "Fantasy", "Family", "Film-Noir", "Horror", "Musical", "Mystery", "Romance", "Sci-Fi", "Short", "Thriller", "War", "Western")
COUNTRIES = ("Afghanistan", "Albania", "Algeria", "Andorra", "Angola", "Antigua & Deps", "Argentina", "Armenia", "Australia", "Austria", "Azerbaijan", "Bahamas", "Bahrain", "Bangladesh", "Barbados", "Belarus", "Belgium", "Belize", "Benin", "Bhutan", "Bolivia", "Bosnia Herzegovina", "Botswana", "Brazil", "Brunei", "Bulgaria", "Burkina", "Burundi", "Cambodia", "Cameroon", "Canada", "Cape Verde", "Central African Rep", "Chad", "Chile", "China", "Colombia", "Comoros", "Congo", "Congo {Democratic Rep}", "Costa Rica", "Croatia", "Cuba", "Cyprus", "Czech Republic", "Denmark", "Djibouti", "Dominica", "Dominican Republic", "East Timor", "Ecuador", "Egypt", "El Salvador", "Equatorial Guinea", "Eritrea", "Estonia", "Ethiopia", "Fiji", "Finland", "France", "Gabon", "Gambia", "Georgia", "Germany", "Ghana", "Greece", "Grenada", "Guatemala", "Guinea", "Guinea-Bissau", "Guyana", "Haiti", "Honduras", "Hungary", "Iceland", "India", "Indonesia", "Iran", "Iraq", "Ireland {Republic}", "Israel", "Italy", "Ivory Coast", "Jamaica", "Japan", "Jordan", "Kazakhstan", "Kenya", "Kiribati", "Korea North", "Korea South", "Kosovo", "Kuwait", "Kyrgyzstan", "Laos", "Latvia", "Lebanon", "Lesotho", "Liberia", "Libya", "Liechtenstein", "Lithuania", "Luxembourg", "Macedonia", "Madagascar", "Malawi", "Malaysia", "Maldives", "Mali", "Malta", "Marshall Islands", "Mauritania", "Mauritius", "Mexico", "Micronesia", "Moldova", "Monaco", "Mongolia", "Montenegro", "Morocco", "Mozambique", "Myanmar", " {Burma}", "Namibia", "Nauru", "Nepal", "Netherlands", "New Zealand", "Nicaragua", "Niger", "Nigeria", "Norway", "Oman", "Pakistan", "Palau", "Panama", "Papua New Guinea", "Paraguay", "Peru", "Philippines", "Poland", "Portugal", "Qatar", "Romania", "Russian Federation", "Rwanda", "St Kitts & Nevis", "St Lucia", "Saint Vincent & the Grenadines", "Samoa", "San Marino", "Sao Tome & Principe", "Saudi Arabia", "Senegal", "Serbia", "Seychelles", "Sierra Leone", "Singapore", "Slovakia", "Slovenia", "Solomon Islands", "Somalia", "South Africa", "South Sudan", "Spain", "Sri Lanka", "Sudan", "Suriname", "Swaziland", "Sweden", "Switzerland", "Syria", "Taiwan", "Tajikistan", "Tanzania", "Thailand", "Togo", "Tonga", "Trinidad & Tobago", "Tunisia", "Turkey", "Turkmenistan", "Tuvalu", "Uganda", "Ukraine", "United Arab Emirates", "United Kingdom", "United States", "Uruguay", "Uzbekistan", "Vanuatu", "Vatican City", "Venezuela", "Vietnam", "Yemen", "Zambia", "Zimbabwe")
db = {"Spoderman2": (1996, "Fantasy", 12, "Turkey", 10, "Noe om den"), "IskremErLAAAAAaaaaaAAng": (2007, "Action", 17, "Norway", 95, "Den er god"), "Spoderman": (1996, "Fantasy", 12, "Turkey", 10, "Noe om den"), "Spoderman23": (1996, "Fantasy", 12, "Belgium", 10, "Noe om den"), "Spoderman28": (1996, "Fantasy", 12, "Norway", 10, "Noe om den"), "Spoderm": (1996, "Fantasy", 12, "Turkey", 10, "Noe om den")}

import os
FILES = os.listdir()

def input_text(prompt, min_char, max_chars):
    while True:
        answer = input(prompt)
        if len(answer) < min_char:
            print("\t Text is too short!")
        elif len(answer) > max_chars:
            print("\t Text is too long!")
        else:
            return answer

def input_num(prompt, min_num, max_num):
    while True:
        try:
            answer = int(input(prompt))
            if answer <= min_num or answer >= max_num:
                print("\t Must be a number between", min_num, "and", max_num)
            else:
                return answer
        except:
            print("\t Must be an integer")

def input_selection(prompt, selections):
    while True:
        answer = input(prompt)
        if answer in selections:
            return answer
        else:
            first_letters = answer[:2]
            print("\t Not valid choice!")
            print("Options that start with '" + first_letters + "'")
            for i in selections:
                if i.startswith(first_letters):
                    print(i)

def enter_title():
    print("Enter the following data about the film")
    title = input_text("Title:", 1, 100)
    year = input_num("Year:", 1900, 2019)
    genre = input_selection("Genre:", GENRES)
    age = input_num("Age rating:", 0, 18)
    country = input_selection("Country:", COUNTRIES)
    score = input_num("Score (0-100):", 0, 100)
    comment = input_text("Comment:",10,100)
    return (title, year, genre, age, country, score, comment)

def add_movies(db):
    while True:
        updated = False
        answer = input("Do you want to enter a movie (y/n)?")
        if answer.lower() != "y":
            break
        movie = enter_title()
        movie_info = movie[1:]
        if movie[0] in db:
            updated = True
        db[movie[0]] =  movie_info
        if updated == True:
            print("Movie", movie[0], "has been updated")
        else:
            print("Movie", movie[0], "has been added")
    return db

def save_movies(db):
    while True:
        filename = input("Save database to filename:")
        if len(filename) <= 5:
            print("Text is too short!")
        elif len(filename) >= 20:
            print("Text is too long!")
        else:
            break
    file = open(filename, "w")
    try:
        file.write(str(db))
        print("The database was saved to", filename)
        file.close()
    except:
        print("The database could not be saved")

def load_movies(files):
    print(files)
    while True:
        filename = input("Load database from filename:")
        if filename in files:
            file = open(filename, "r")
            string = file.read()
            file.close()
            return eval(string)
        else:
            first_letters = filename[:2]
            print("\t Not valid choice!")
            print("Options that start with '" + first_letters + "'")
            for i in files:
                if i.startswith(first_letters):
                    print(i)

def show_movies(db):
    for i in db:
        name = i
        if len(name) < 20:
            for _ in range(20 - len(name)):
                name += " "
        elif len(name) > 20:
            name = name[:20]
        country = db[i][3]
        if len(country) < 10:
            for _ in range(10 - len(country)):
                country += " "
        elif len(country) > 10:
            country = country[:10]
        genre = db[i][1]
        if len(genre) < 10:
            for _ in range(10 - len(genre)):
                genre += " "
        elif len(genre) > 10:
            genre = genre[:10]
        print(db[i][0], name, genre, country, "Age:", db[i][2], "Score:", str(db[i][4]) + "%")

def most_pop_genre(db):
    ls = []
    dic = {}
    counter = 0
    big = ""
    for i in db:
        ls.append(db[i][1])
    for element in ls:
        if element in dic:
            dic[element] += 1
        else:
            dic[element] = 1
    for i in dic:
        if dic[i] > counter:
            counter = dic[i]
            big = i
    return big

def top3_countries(db):
    ls = []
    for i in db:
        ls.append(db[i][3])

    languages = list(set(ls))
    occurrences = []
    for j in languages:
        occurrences.append(ls.count(j))
    temp = []
    temp.extend(occurrences)
    biggest_index = []
    for _ in range(3):
        big = max(temp)
        index = temp.index(big)
        biggest_index.append(index)
        temp[index] = 0
    for i in range(3):
        print(f"{languages[biggest_index[i]]:20s}: {occurrences[biggest_index[i]]} movies")

def most_countries(database):
    countries = []
    for data in database:
        countries.append(database[data][3])

    set_countries = list(set(countries))
    occurrences = []
    for country in set_countries:
        occurrences.append(countries.count(country))
    
    temp_set_countries = []
    temp_set_countries.extend(occurrences)

    biggest_countries_indexes = []

    for _ in range(5):
        biggest_country = max(temp_set_countries)
        index = temp_set_countries.index(biggest_country)
        biggest_countries_indexes.append(index)
        temp_set_countries[index] = 0

        print(set_countries[index], occurrences[index])

most_countries(db)
        
