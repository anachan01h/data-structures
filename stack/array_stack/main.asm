extern malloc
    
struc ArrayStack
    .data resq 1
    .capacity resd 1
    .size resd 1
endstruc

section .bss
    stack resb ArrayStack_size

section .text
global main

main:
    mov rdi, stack
    call stack_init
    mov rdi, rax
    mov rax, 0x3C
    syscall

; stack_init(stack: &ArrayStack) -> Option<()>
stack_init:
    ; # Stack frame
    ; [rsp]: &ArrayStack
    enter 8, 0
    mov [rsp], rdi

    mov rdi, 1 * 8
    call malloc

    test rax, rax
    jz .exit

    mov rdx, [rsp]
    mov [rdx + ArrayStack.data], rax
    mov [rdx + ArrayStack.capacity], dword 1
    mov [rdx + ArrayStack.size], dword 0

    mov rax, 1
.exit:
    leave
    ret
