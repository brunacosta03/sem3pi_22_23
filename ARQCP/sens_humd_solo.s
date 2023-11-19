.section .text
    .global sens_humd_solo

sens_humd_solo:
    movsbw %dl, %ax # Move ult_pluvio to %ax

    movb $0, %dl # put value 0 in remainder

    cmpb $0, %sil # If pluvisiodade is 0 is not raining
    jle not_raining

    cmpb $0, %sil # If pluvisiodade is not 0 means that is raining
    jg is_raining

not_raining:
    movb $3, %cl # Not raining so variation will be 3 
    idivb %cl # %ax / %cl

    jmp result

is_raining:
    movb $10, %cl # Is raining so variation will be 10 
    idivb %cl # %ax / %cl

    jmp result

result:
    addb %ah, %dl # %dl = %dl + %ah(remainder)
    addb %dil, %dl # %dl = %dl + ult_hmd_solo

    movsbw %dl, %ax # result will be in %ax

    cmpw $0, %ax # Lower Limit
    jle to_low

    cmpw $103, %ax # Higher Limit
    jg to_high

    jmp end

to_low:
    movw $0, %ax
    jmp end

to_high:
    movw $103, %ax
    jmp end

end:
    ret
    