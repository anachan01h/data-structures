extern malloc

section .data
stack:
    .data dq 0
    .length dq 0
    .size dq 0

section .text
global main

main:
    call create
    mov rdi, [stack.length]
    mov rax, 0x3C
    syscall

create:
    mov rdi, 8
    call malloc
    mov [stack.length], byte 1
    mov [stack.size], byte 0
    ret
