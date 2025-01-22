%include "./include/utils.inc"

extern stack_init, stack_free, stack_push, stack_pop

section .note.GNU-stack noalloc noexec nowrite progbits

section .bss
    stack resb ArrayStack_size

section .text

global main
main:
    push rbp
    mov rbp, rsp

    mov rdi, stack
    call stack_init
    test eax, eax
    jnz .early_exit

	mov rdi, stack
	mov rsi, 5
	call stack_push

	mov rdi, stack
	mov rsi, 12
	call stack_push

	mov rdi, stack
	mov rsi, 15
	call stack_push

	mov rdi, stack
	call stack_pop

	mov rdi, stack
	call stack_pop

.exit:
	mov rbx, [stack + ArrayStack.capacity]
	mov rbx, rdx

    mov rdi, stack
    call stack_free

	mov rax, rbx
.early_exit:
    leave
    ret
