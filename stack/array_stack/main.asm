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
    push rbp
    mov rbp, rsp

    mov rdi, stack
    call stack_init
    test rax, rax
    jz .exit

    mov rdi, stack
    call stack_free

.exit:
    mov rax, [stack + ArrayStack.capacity]
    leave
    ret

; stack_init(stack: &ArrayStack) -> Option<()>
stack_init:
    ; # Stack frame
    ; [rbp - 8]: &ArrayStack
    push rbp
    mov rbp, rsp
    sub rsp, 16
    mov [rbp - 8], rdi

    mov rdi, 1 * 8
    call malloc

    test rax, rax
    jz .exit

    mov rdi, [rbp - 8]
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
    ; [rbp - 8]: &ArrayStack
    push rbp
    mov rbp, rsp
    sub rsp, 16
    mov [rbp - 8], rdi

    mov rdi, [rdi + ArrayStack.data]
    call free

    mov rdi, [rbp - 8]
    xor rax, rax
    mov [rdi + ArrayStack.data], rax
    mov [rdi + ArrayStack.capacity], eax
    mov [rdi + ArrayStack.size], eax

    leave
    ret
