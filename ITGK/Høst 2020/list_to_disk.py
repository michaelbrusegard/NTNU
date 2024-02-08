array = [['Beatles','And I love her'],['Beatles','All my loving'],['Traffic','John Barleycorn must die'],['Cream','Sunshine of my love'],['Cream','SLWABR']]

def list_to_disk(ls, filename):
    file = open(filename, "w")
    for i in ls:
        file.write(i[0] + ";" + i[1] + "\n")
    file.close()

list_to_disk(array, "music.txt")