def prepare(number):
    for i in number:
        if i != "0" and i != "1":
            return "Det er ikke et binært tall"
    for i in range(8 - len(number)):
        number = "0" + number
    return number

print(prepare("0101"))