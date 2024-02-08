main:
    add a0, a0, a1
    add a2, a2, a3
    add a4, a4, a5
    
    sub t0, a0, a2
    bltz t0, a2_bigger_than_a0
    
    sub t0, a0, a4
    bltz t0, a4_biggest
    j end

a2_bigger_than_a0:
    sub t0, a2, a4
    bltz t0, a4_biggest
    mv a0, a2
    j end

a4_biggest:
    mv a0, a4
    
end:
    nop