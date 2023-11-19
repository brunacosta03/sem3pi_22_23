.section .text
    .global sens_pluvio # unsigned char sens_pluvio(unsigned char ult_pluvio, char ult_temp, char comp_rand);

sens_pluvio:
    movsbw %dl, %ax # Move ult_temp to %ax

    movb $0, %dl # Put value 0 in remainder

    movb $15, %cl # %cl = 15
    idivb %cl # %ax / %cl

    cmpb $12, %sil # Check if temperature is < 12
    jl temp_low # Temperature < 12 so temperature is low

    cmpb $12, %sil # Check if temperature is > 12
    jge temp_high # Temperature >= 12 so temperature is high

    jmp result

temp_low:
    cmpb $0, %ah # Temperature is lower so have more chance to rain
    jl turn_pos

    jmp result

temp_high:
    cmpb $0, %ah # Temperature is higher so have less chance to rain
    jg turn_neg

    jmp result

turn_pos:
    notb %ah # %ah = ~%ah
    jmp result

turn_neg:
    notb %ah # %ah = ~%ah
    jmp result

result:
    addb %ah, %dl # %dl = %dl + %ah(remainder)
    addb %dil, %dl # %dl = %dl + ult_pluvio

    movsbw %dl, %ax # result will be in %ax


    cmpw $0, %ax # Lower Limit
    jle pluvio_null

    cmpw $103, %ax # Higher Limit
    jg pluvio_to_high

    jmp end

pluvio_null:
    movw $0, %ax # If is less then lower limit should be 0
    jmp end

pluvio_to_high:
    subw $15, %ax # %ax = %ax - 15
    jmp end

end:
    ret
    