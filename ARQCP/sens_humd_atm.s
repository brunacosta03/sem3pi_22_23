.section .text
    .global sens_humd_atm # unsigned char sens_humd_atm(unsigned char ult_hmd_atm, unsigned char ult_pluvio, char comp_rand)

sens_humd_atm:
    movsbw %dl, %ax # Move ult_pluvio to %ax

    movb $0, %dl # Put value 0 in remainder

    cmpb $0, %sil # If pluvisiodade is 0 is not raining
    jle not_raining

    cmpb $0, %sil # If pluvisiodade is not 0 means that is raining
    jg is_raining

not_raining:
    movb $5, %cl # Not raining so variation will be 5
    idivb %cl # %ax / %cl

    jmp result

is_raining:
    movb $15, %cl # Is raining so variation will be 10 
    idivb %cl # %ax / %cl

    jmp result

result:
    addb %ah, %dl # %dl = %dl + %ah(remainder)
    addb %dil, %dl # %dl = %dl + ult_hmd_atm

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
    