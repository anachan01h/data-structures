%include "./include/utils.inc"

extern deque_resize

section .note.GNU-stack noalloc noexec nowrite progbits

section .text

; deque_push_back(self: &ArrayDeque, value: u64) -> Result<(), ()>
global deque_push_back
deque_push_back:
	push rbp
	mov rbp, rsp

	mov edx, [rdi + ArrayDeque.capacity]
	cmp [rdi + ArrayDeque.size], edx
	jb .no_resize

	push rdi
	push rsi
	call deque_resize
	pop rsi
	pop rdi
	test eax, eax
	jnz .error

.no_resize:
	xor edx, edx
	mov eax, [rdi + ArrayDeque.start]
	add eax, [rdi + ArrayDeque.size]
	div dword [rdi + ArrayDeque.capacity]
	mov rax, [rdi + ArrayDeque.data]
	mov [rax + 8 * rdx], rsi
	inc dword [rdi + ArrayDeque.size]

	xor eax, eax
.error:
	leave
	ret

; deque_pop_back(self: &ArrayDeque) -> Result<u64, ()>
global deque_pop_back
deque_pop_back:
	; # Stack Frame
	; [rbp - 8]: u64
	push rbp
	mov rbp, rsp
	sub rsp, 16

	mov rsi, [rdi + ArrayDeque.data]
	mov eax, [rdi + ArrayDeque.start]
	add eax, [rdi + ArrayDeque.size]
	dec eax
	div dword [rdi + ArrayDeque.capacity]
	mov rdx, [rsi + 8 * rdx]
	mov [rbp - 8], rdx

	dec dword [rdi + ArrayDeque.size]

	mov ecx, [rdi + ArrayDeque.size]
	mov eax, 3
	mul ecx
	cmp eax, [rdi + ArrayDeque.capacity]
	ja .no_resize

	call deque_resize
	jmp .end

.no_resize:
	xor eax, eax

.end:
	mov rdx, [rbp - 8]
	leave
	ret

; deque_push_front(self: &ArrayDeque, value: u64) -> Result<(), ()>
global deque_push_front
deque_push_front:
	push rbp
	mov rbp, rsp

	mov edx, [rdi + ArrayDeque.capacity]
	cmp [rdi + ArrayDeque.size], edx
	jb .no_resize

	push rdi
	push rsi
	call deque_resize
	pop rsi
	pop rdi
	test eax, eax
	jnz .error

.no_resize:
	xor edx, edx
	mov eax, [rdi + ArrayDeque.start]
	dec eax
	div dword [rdi + ArrayDeque.capacity]
	mov [rdi + ArrayDeque.start], edx
	mov rax, [rdi + ArrayDeque.data]
	mov [rax + 8 * rdx], rsi
	inc dword [rdi + ArrayDeque.size]

	xor eax, eax
.error:
	leave
	ret

	; deque_pop_front(self: &ArrayDeque) -> Result<u64, ()>
global deque_pop_front
deque_pop_front:
	; # Stack Frame
	; [rbp - 8]: u64
	push rbp
	mov rbp, rsp
	sub rsp, 16

	mov rsi, [rdi + ArrayDeque.data]
	mov eax, [rdi + ArrayDeque.start]
	mov rdx, [rsi + 8 * rax]
	mov [rbp - 8], rdx

	xor edx, edx
	inc eax
	div dword [rdi + ArrayDeque.capacity]
	mov [rdi + ArrayDeque.start], edx
	dec dword [rdi + ArrayDeque.size]

	mov ecx, [rdi + ArrayDeque.size]
	mov eax, 3
	mul ecx
	cmp eax, [rdi + ArrayDeque.capacity]
	ja .no_resize

	call deque_resize
	jmp .end

.no_resize:
	xor eax, eax

.end:
	mov rdx, [rbp - 8]
	leave
	ret
