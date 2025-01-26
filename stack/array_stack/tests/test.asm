%include "./include/utils.inc"

extern stack_init, stack_free, stack_push, stack_pop
extern printf

section .note.GNU-stack noalloc noexec nowrite progbits

section .data
	msg1 db "Push: %d", 0x0A, 0
	msg2 db "Pop: %d", 0x0A, 0

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
    jnz .exit

	xor ebx, ebx
.loop1:
	mov rdi, stack
	mov esi, ebx
	call stack_push
	test eax, eax
	jnz .error

	mov rdi, msg1
	mov esi, ebx
	xor eax, eax
	call printf

	inc ebx
	cmp ebx, 5
	jb .loop1

	xor ebx, ebx
.loop2:
	mov rdi, stack
	call stack_pop
	test eax, eax
	jnz .error

	mov rdi, msg2
	mov esi, edx
	xor eax, eax
	call printf

	inc ebx
	cmp ebx, 2
	jb .loop2

	xor ebx, ebx
.loop3:
	mov rdi, stack
	mov esi, ebx
	add esi, 5
	call stack_push
	test eax, eax
	jnz .error

	mov rdi, msg1
	mov esi, ebx
	xor eax, eax
	call printf

	inc ebx
	cmp ebx, 3
	jb .loop3

.loop4:
	mov rdi, stack
	call stack_pop
	test eax, eax
	jnz .error

	mov rdi, msg2
	mov rsi, rdx
	xor eax, eax
	call printf

	cmp [stack + ArrayStack.size], dword 0
	ja .loop4

.error:
	mov ebx, eax
	mov rdi, stack
	call stack_free
	mov eax, ebx
	jmp .exit

	xor eax, eax
.exit:
	leave
	ret
