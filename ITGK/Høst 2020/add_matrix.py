a = [[1,2,3,4,5],[3,4,5,6,7]]
b = [[2,4,6,8,9],[6,8,10,12,13]]

def add_matrix(a, b):
    if len(a) != len(b):
        return
    
    c = []

    for i in range(len(a)):
        if len(a[i]) != len(b[i]):
            return
        c.append([])
        
        for j in range(len(a[i])):
            c[i].append(a[i][j] + b[i][j])
    return c

print(add_matrix(a, b))