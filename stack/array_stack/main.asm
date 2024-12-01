extern malloc, realloc, free
    
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

    mov [stack + ArrayStack.size], dword 1
    mov rdi, stack
    call stack_resize
    test rax, rax
    jz .exit

    push qword [stack + ArrayStack.capacity]
    push rax

    mov rdi, stack
    call stack_free

.exit:
    pop rax
    pop rax
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

; stack_resize(stack: &ArrayStack) -> Option<()>
stack_resize:
    ; # Stack Frame
    ; [rbp - 8]: &ArrayStack
    ; [rbp -12]: u32
    push rbp
    mov rbp, rsp
    sub rsp, 16
    mov [rbp - 8], rdi          ; save stack as local variable

    mov edx, 1
    mov esi, [rdi + ArrayStack.size]
    shl esi, 1                  ; esi <- 2 * size
    cmovz esi, edx              ; if 2 * size == 0, then esi <- 1
    mov [rbp - 12], esi         ; save new capacity as local variable
    mov rdi, [rdi + ArrayStack.data]
    call realloc

    test rax, rax
    jz .exit                    ; if error, return None

    mov rdi, [rbp - 8]
    mov [rdi + ArrayStack.data], rax
    mov esi, [rbp - 12]
    mov [rdi + ArrayStack.capacity], esi

    mov eax, 1                  ; return Some(())
.exit:
    leave
    ret
