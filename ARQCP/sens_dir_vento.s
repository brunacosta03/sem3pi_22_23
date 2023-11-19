.section .text
    .global sens_dir_vento # unsigned short sens_dir_vento(unsigned short ult_dir_vento, short comp_rand)

sens_dir_vento:
    movw %si, %ax # Put value comp_rand in %ax
    cwd # extend sinal %ax:%dx
    
    movw $6, %cx # put variation 6 in %cx
    idivw %cx # %ax / %cx

    addw %di, %dx # %dx = %dx + %di(ult_dir_vento)
    movw %dx, %ax # put remainder + ult_dir_vento in %ax

    cmpw $0, %ax # Lower Limit
    jl to_less

    cmpw $365, %ax # Higher Limit
    jg to_big

    jmp end

to_less:
    addw $6, %ax # If is less then lower limit increase 6
    jmp end

to_big:
    subw $6, %ax # If is above higher limit decrease 6
    jmp end

end:
    ret
    