.section .text
    .global sens_velc_vento # char sens_velc_vento (unsgined char ult_velc_vento, char comp_rand)

sens_velc_vento:
    movb $0, %dl # Put value 0 in remainder

    movsbw %sil, %ax # Move ult_velc_vento to %ax

    movb $15, %cl # put variation 15 in %cl
    idivb %cl # %ax / %cl

    addb %ah, %dl # %dl = %dl + %ah(remainder)
    addb %dil, %dl # %dl = %dl + ult_pluvio

    movsbw %dl, %ax # result will be in %ax

    cmpw $0, %ax # Lower Limit
    jl to_less

    cmpw $53, %ax # Higher Limit
    jg to_big

    jmp end

to_less:
    addw $15, %ax # If is less then lower limit increase 15
    jmp end    

to_big:
    subw $15, %ax # If is above higher limit decrease 15
    jmp end

end:
    ret

    