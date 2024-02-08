# Ã˜ving 4
# Ikke bry deg om denne delen, move along
.data
function_error_str: .string "ERROR: Woops, programmet returnerte ikke fra et funksjonskall!"

.text
# Her starter programmet


# Test Mode
# Sett a7 til 1 for Ã¥ teste med veridene under Test - Start
# Sett a7 til 0 nÃ¥r du skal levere
li a7, 0
beq a7, zero, load_complete

# Test - Start
li a0 0
li a1 0
li a2 0
li a3 0
li a4 0
li a5 0
#Test Slutt

load_complete:

# Globale Registre:
# s0-s5 : ForelÃ¸pig liste
# s6    : Har byttet verdier denne syklusen (0/1)

# Hopp forbi funksjoner
j main


# Funksjoner:
    
swap:
    # Args: a0, a1
    # Outputs: a0, a1
    
    # Sammenlikn a0 og a1
    # Putt den minste av dem i a0 og den stÃ¸rste i a1
    # Hvis den byttet a0 og a1, sett den globale variablen s6 til 1 for Ã¥ markere dette til resten av koden
    bge a1, a0, swap_complete
    mv t0, a0
    mv a0, a1
    mv a1, t0
    li s6, 1
    
swap_complete:
    # Returner til instruksjonen etter funksjonskallet (en instruksjon)
    ret

# Hvis programmet kommer hit har den ikke greid Ã¥ returnere fra funksjonen over
# Dette bÃ¸r aldri skje
la a0, function_error_str
li a7, 4
ecall
j end


# Main
main:
    # Last in s0-s5 med verdiene fra a0-a5
    mv s0, a0
    mv s1, a1
    mv s2, a2
    mv s3, a3
    mv s4, a4
    mv s5, a5
    
loop:
    # Reset verdibytteindikator (en instruksjon)
    li s6, 0
    
    # Sorter alle
    # Repeter fÃ¸lgende logikk:
    # Ta s[i] og s[i+1], og lagre dem som argumenter
    # Kall funksjonen `swap` som sorterer dem
    # NÃ¥ skal `swap` ha outputet de to verdiene i to registre
    # Putt den minste verdien i s[i], og den stÃ¸rste i s[i+1]
    # Repeter for i=0..4
    
    # 0 <-> 1
    mv a0, s0
    mv a1, s1
    call swap
    mv s0, a0
    mv s1, a1
    
    # 1 <-> 2
    mv a0, s1
    mv a1, s2
    call swap
    mv s1, a0
    mv s2, a1

    # 2 <-> 3
    mv a0, s2
    mv a1, s3
    call swap
    mv s2, a0
    mv s3, a1

    # 3 <-> 4
    mv a0, s3
    mv a1, s4
    call swap
    mv s3, a0
    mv s4, a1

    # 4 <-> 5
    mv a0, s4
    mv a1, s5
    call swap
    mv s4, a0
    mv s5, a1
    
    # Fortsett loop hvis noe ble endret (en instruksjon)
    bgt s6, t1, loop
    # Hvis ingenting ble byttet er listen sortert
    j loop_end
    
loop_end:
    # Flytt alt til output-registrene
    mv a0, s0
    mv a1, s1
    mv a2, s2
    mv a3, s3
    mv a4, s4
    mv a5, s5
    
end:
    nop