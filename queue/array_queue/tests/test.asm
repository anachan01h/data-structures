extern queue_init, queue_free
extern printf

%include "./include/utils.inc"

section .note.GNU-stack noalloc noexec nowrite progbits

section .data
	msg1 db "Capacity after init: %d", 0x0A, 0
	msg2 db "Capacity after free: %d", 0x0A, 0

section .bss
	queue resb ArrayQueue_size

section .text

global main
main:
	push rbp
	mov rbp, rsp

	mov rdi, queue
	call queue_init
	test eax, eax
	jnz .early_exit

	mov rdi, msg1
	mov esi, [queue + ArrayQueue.capacity]
	xor eax, eax
	call printf

	mov rdi, queue
	call queue_free

	mov rdi, msg2
	mov esi, [queue + ArrayQueue.capacity]
	xor eax, eax
	call printf

	xor eax, eax
.early_exit:
	leave
	ret
