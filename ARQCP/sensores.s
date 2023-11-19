.section .text
    .global sens_temp
    .global sens_velc_vento
    .global sens_dir_vento
    .global sens_humd_atm
    .global sens_humd_solo
    .global sens_pluvio
sens_temp:

    pushq %rbx

    movb $0, %dl

    cmpb $2, %sil
    jg change

    jmp loop_temp

change:
    movb $2, %sil

loop_temp:
    addb %sil, %dil
    
    movb $50, %bh

    movb %dil, (%rax)

    idivb %bh

    movb %dl, %ah
    
    call sens_velc_vento

    ret

sens_velc_vento:
    movb $0, %cl

loop_vento:
    addb %sil, %dil
    
    movb $30, %bh

    movb %dil, (%rax)

    idivb %bh

end_sens_velc_vento:
    call sens_dir_vento
    
    ret

sens_dir_vento:
    movb $-1, %cl

    cmpw $10, %si
    jg end_sens_dir_vento

    addw %si, %di

    cmpw $360, %di
    jge revert_positive

    cmpw $0, %di
    jl revert_negative

    jmp end_sens_dir_vento

revert_positive:
    subw $360, %di

    jmp end_sens_dir_vento

revert_negative:
    addw $360, %di

end_sens_dir_vento:
    
    movw %di, %ax

    call sens_humd_atm
    
    ret

sens_humd_atm:

    movb %dil, (%rax)

    mulb %sil

    addb (%rax), %dil
    
    cmpb $100, %dil
    jg greater

    movb %dil, (%rax)

    jmp end_sens_humd


greater:

    movb $100, %bh

    movb %dil, (%rax)

    idivb %bh

    movb %dl, %ah
end_sens_humd:

    call sens_humd_solo # (unsigned char ult_hmd_solo, unsigned char ult_pluvio, char comp_rand);

    ret

sens_humd_solo:

    movb %dl, %ah

    mulb %sil

    movb %ah, %dl
    
    cmpb $10, %dl
    je reduce_humd

level_solo:

    addb %dl, %dil

    cmpb $100, %dil
    jg reduce_percent_solo

    jmp end_sens_humd_solo

reduce_humd:
    movb $10, %dl

    jmp level_solo

reduce_percent_solo:
    movb %dil, (%rax)
    movb $100, %cl

    idivb %cl

end_sens_humd_solo:

    movb %dl, %ah

    call sens_pluvio # (unsigned char ult_pluvio, char ult_temp, char comp_rand);

    ret

sens_pluvio:

    movb %sil, (%rax)
    movb %dl, %cl

    idivb %sil
    idivb %sil

    movb %cl, %ah

    mulb %sil

    addb (%rax), %dil

    cmpb $10, %dil
    jg change_sens_pluvio

    jmp end_sens_pluvio

change_sens_pluvio:
    movb $10, %dil

end_sens_pluvio:
    movb %dil, (%rax)

    popq %rbx
    ret
