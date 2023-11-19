.section .text
    .global sens_temp # char sens_temp (char ult_temp, char comp_rand)

sens_temp:
    movb $0, %dl # Put value 0 in remainder

    movsbw %sil, %ax # Move ult_temp to %ax

    movb $5, %cl # put variation 5 in %cl
    idivb %cl # %ax / %cl

    addb %ah, %dl # %dl = %dl + %ah(remainder)
    addb %dil, %dl # %dl = %dl + ult_temp

    movsbw %dl, %ax # result will be in %ax

    cmpw $-10, %ax # Lower Limit
    jl to_less

    cmpw $53, %ax # Lower Limit
    jg to_big

    jmp end

to_less:
    addw $5, %ax # If is less then lower limit increase 5
    jmp end

to_big:
    subw $5, %ax # If is above higher limit decrease 15
    jmp end

end:
    ret
