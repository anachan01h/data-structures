%include "./include/utils.inc"

extern deque_init, deque_free, deque_push_back, deque_pop_back, deque_push_front, deque_pop_front
extern printf

section .note.GNU-stack noalloc noexec nowrite progbits

section .data
	msg_pushb db "Push Back: %d", 0x0A, 0
	msg_popb db "Pop Back: %d", 0x0A, 0
	msg_pushf db "Push Front: %d", 0x0A, 0
	msg_popf db "Pop Front: %d", 0x0A, 0

section .bss
	deque resb ArrayDeque_size

section .text

global main
main:
	push rbp
	mov rbp, rsp
	sub rsp, 16

	mov rdi, deque
	call deque_init
	test eax, eax
	jnz .early_exit

	xor ebx, ebx
.loop1:
	mov rdi, deque
	mov esi, ebx
	call deque_push_back
	test eax, eax
	jnz .error

	mov rdi, msg_pushb
	mov esi, ebx
	xor eax, eax
	call printf

	inc ebx
	cmp ebx, 5
	jb .loop1

	xor ebx, ebx
.loop2:
	mov rdi, deque
	mov esi, ebx
	add esi, 5
	call deque_push_front
	test eax, eax
	jnz .error

	mov rdi, msg_pushf
	mov esi, ebx
	add esi, 5
	xor eax, eax
	call printf

	inc ebx
	cmp ebx, 6
	jb .loop2

	xor ebx, ebx
.loop3:
	mov rdi, deque
	call deque_pop_back
	test eax, eax
	jnz .error

	mov rdi, msg_popb
	mov esi, edx
	xor eax, eax
	call printf

	inc ebx
	cmp ebx, 3
	jb .loop3

.loop4:
	mov rdi, deque
	call deque_pop_front
	test eax, eax
	jnz .error

	mov rdi, msg_popf
	mov esi, edx
	xor eax, eax
	call printf

	cmp [deque + ArrayDeque.size], dword 0
	ja .loop4

	xor eax, eax
.error:
	mov [rbp - 4], eax
	mov rdi, deque
	call deque_free

	mov eax, [rbp - 4]
.early_exit:
	leave
	ret
