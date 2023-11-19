.section .data
    .global state, inc
    
.section .text
    .global pcg32_random_r

pcg32_random_r:
    # prologue
    pushq %rbp
    movq %rsp, %rbp
    subq $16, %rsp # allocate 24 bytes for local variables


    movq state(%rip), %rax # put state in %rax
    movq inc(%rip), %rdx # put inc in %rdx

    # Advance internal state
    movq %rax, -8(%rbp) # oldstate = state;

    movq $6364136223846793005, %rcx # put value 6364136223846793005 in %rcx
    imulq %rcx, %rax # %rax = oldstate * 6364136223846793005ULL

    orq $1, %rdx # %rdx = (inc|1)
    addq %rdx, %rax # this line is sum --> oldstate * 6364136223846793005ULL + (inc|1)
    movq %rax, state(%rip) # state = oldstate * 6364136223846793005ULL + (inc|1);


    # Calculate output function (XSH RR), uses old state for max ILP
    movq -8(%rbp), %rcx # move oldstate to %ecx
    shrq $18, %rcx # shift right 18 in %rcx
    xorq -8(%rbp), %rcx # move oldstate to %rcx
    shrq $27, %rcx # shift right 27 in %rcx
    movl %ecx, -16(%rbp) # save value xorshifted


    movq -8(%rbp), %rcx # move oldstate to %ecx
    shrq $59, %rcx # oldstate >> 59u


    movq -16(%rbp), %rax # move xorshifted to %rax
    rorl %cl, %eax # Bit rotation to the right --> (xorshifted >> rot) | (xorshifted << ((-rot) & 31))


    # epilogue ( deallocates 24 bytes )
    movq %rbp, %rsp
    popq %rbp

    ret
