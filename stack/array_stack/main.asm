extern malloc, free
    
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
    test rax, rax
    jz .exit

    mov rdi, stack
    call stack_free

.exit:
    mov rdi, [stack + ArrayStack.capacity]
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

    mov rdi, [rsp]
    mov [rdi + ArrayStack.data], rax
    mov [rdi + ArrayStack.capacity], dword 1
    mov [rdi + ArrayStack.size], dword 0

    mov rax, 1
.exit:
    leave
    ret

; stack_free(stack: &ArrayStack)
stack_free:
    ; # Stack frame
    ; [rsp]: &ArrayStack
    enter 8, 0
    mov [rsp], rdi

    mov rdi, [rdi + ArrayStack.data]
    call free

    mov rdi, [rsp]
    xor rax, rax
    mov [rdi + ArrayStack.data], rax
    mov [rdi + ArrayStack.capacity], eax
    mov [rdi + ArrayStack.size], eax

    leave
    ret
