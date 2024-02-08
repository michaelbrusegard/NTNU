def convert(string):
    while len(string) > 5:
        string = string[-5]
    number = 0
    for i in string:
        number += ord(i)
    return chr(number)

print(convert("Petter"))