extern queue_init, queue_free, queue_enqueue, queue_dequeue
extern printf

%include "./include/utils.inc"

section .note.GNU-stack noalloc noexec nowrite progbits

section .data
	msg1 db "Enqueue: %d", 0x0A, 0
	msg2 db "Dequeue: %d", 0x0A, 0

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

	xor ebx, ebx
.loop1:
	mov rdi, queue
	mov esi, ebx
	call queue_enqueue
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
	mov rdi, queue
	call queue_dequeue
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
	mov rdi, queue
	mov esi, ebx
	add esi, 5
	call queue_enqueue
	test eax, eax
	jnz .error

	mov rdi, msg1
	mov esi, ebx
	add esi, 5
	xor eax, eax
	call printf

	inc ebx
	cmp ebx, 3
	jb .loop3

.loop4:
	mov rdi, queue
	call queue_dequeue
	test eax, eax
	jnz .error

	mov rdi, msg2
	mov rsi, rdx
	xor eax, eax
	call printf

	cmp [queue + ArrayQueue.size], dword 0
	ja .loop4

.error:
	mov rdi, queue
	call queue_free

	xor eax, eax
.early_exit:
	leave
	ret
