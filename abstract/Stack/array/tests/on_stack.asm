%include "./include/def.inc"

extern stack_push, stack_pop
extern printf

section .note.GNU-stack noalloc noexec nowrite progbits

section .data
	msg1 db "Push: %d", 0x0A, 0
	msg2 db "Pop: %d", 0x0A, 0
	overflow db "Error: overflow!", 0x0A, 0
	underflow db "Error: underflow!", 0x0A, 0

section .bss
	stack resb Stack_size

section .text

global main
main:
	push rbp
	mov rbp, rsp
	sub rsp, 8 * 10

	mov rdi, stack
	mov [rdi + Stack.data], rsp
	mov [rdi + Stack.capacity], dword 10
	mov [rdi + Stack.size], dword 0

	xor ebx, ebx
.loop1:
	mov rdi, stack
	mov esi, ebx
	call stack_push
	test eax, eax
	jnz .overflow

	mov rdi, msg1
	mov esi, ebx
	xor eax, eax
	call printf

	inc ebx
	cmp ebx, 6
	jb .loop1

	xor ebx, ebx
.loop2:
	mov rdi, stack
	call stack_pop
	test eax, eax
	jnz .underflow

	mov rdi, msg2
	mov esi, edx
	xor eax, eax
	call printf

	inc ebx
	cmp ebx, 3
	jb .loop2

	mov ebx, 6
.loop3:
	mov rdi, stack
	mov esi, ebx
	call stack_push
	test eax, eax
	jnz .loop4

	mov rdi, msg1
	mov esi, ebx
	xor eax, eax
	call printf

	inc ebx
	jmp .loop3

.loop4:
	mov rdi, stack
	call stack_pop
	test eax, eax
	jnz .loop4_end

	mov rdi, msg2
	mov esi, edx
	xor eax, eax
	call printf

	jmp .loop4

.loop4_end:
	jmp .exit

.overflow:
	mov rdi, overflow
	xor eax, eax
	call printf
	jmp .exit

.underflow:
	mov rdi, underflow
	xor eax, eax
	call printf

.exit:
	leave
	ret
