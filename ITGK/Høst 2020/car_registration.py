from random import randint

def car_registration():
    letters = "abcdefghijklmnopqrstuvwxyz"
    registration = ""
    for i in range(2):
        registration += letters[randint(0, 25)].upper()
    for i in range(5):
        registration += str(randint(0, 9))
    return registration

print(car_registration())