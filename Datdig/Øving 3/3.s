main:
    # Sette a2 til verdien i a0
    mv a2, a0
    # Sette a1 til 0 (aka at det ikke er et kvadrattall)
    li a1, 0
    # Sette a4 til 0 i tilfellet det er et tall der fra før av
    li a4, 0
    
loop:
    # -1 på a2
    addi a2, a2, -1
    # Hvis a2 er 0 så gir vi opp
    beqz a2, end
    
    # Sjekker om a0 er delelig med den nåværende a2, hvis det er det så setter vi a3 til 0 og hvis a3 er 0 så går vi ut av loopen
    rem a3, a0, a2
    beqz a3, found_divisor
    
    # Fortsette loopen vi fant ikke a2 (sad)
    j loop
    
found_divisor:
    # Hvis funnet divisor er større enn lagret divisor
    bgt a2, a4, update_divisor
    # Multiplisere a2 med seg selv å putte i a3 også hvis den er lik a0 så kjører vi is square
    mul a3, a2, a2
    beq a3, a0, is_square
    j loop
    
update_divisor:
    # Oppdatere største divisor
    mv a4, a2
    j found_divisor
    
is_square:
    # Sette a1 til 1
    li a1, 1
    j end
    
end:
    # Sette den største divisoren i a0
    mv a0, a4
    # Finito
    nop
    