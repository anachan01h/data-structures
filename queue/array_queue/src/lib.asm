%include "./include/utils.inc"

extern queue_resize

section .note.GNU-stack noalloc noexec nowrite progbits

section .text

; queue_enqueue(self: &ArrayQueue, value: u64) -> Result<(), ()>
global queue_enqueue
queue_enqueue:
	push rbp
	mov rbp, rsp

	mov edx, [rdi + ArrayQueue.capacity]
	cmp [rdi + ArrayQueue.size], edx
	jb .no_resize

	push rdi
	push rsi
	call queue_resize
	pop rsi
	pop rdi
	test eax, eax
	jnz .error

.no_resize:
	xor edx, edx
	mov eax, [rdi + ArrayQueue.start]
	add eax, [rdi + ArrayQueue.size]
	div dword [rdi + ArrayQueue.capacity]
	mov rax, [rdi + ArrayQueue.data]
	mov [rax + 8 * rdx], rsi
	inc dword [rdi + ArrayQueue.size]

	xor eax, eax
.error:
	leave
	ret

; queue_dequeue(self: &ArrayQueue) -> Result<u64, ()>
global queue_dequeue
queue_dequeue:
	; # Stack Frame
	; [rbp - 8]: u64
	push rbp
	mov rbp, rsp
	sub rsp, 16

	mov rsi, [rdi + ArrayQueue.data]
	mov eax, [rdi + ArrayQueue.start]
	mov rdx, [rsi + 8 * rax]
	mov [rbp - 8], rdx

	inc eax
	xor edx, edx
	div dword [rdi + ArrayQueue.capacity]
	mov [rdi + ArrayQueue.start], edx
	dec dword [rdi + ArrayQueue.size]

	mov ecx, [rdi + ArrayQueue.size]
	mov eax, 3
	mul ecx
	cmp eax, [rdi + ArrayQueue.capacity]
	ja .no_resize

	call queue_resize
	jmp .end

.no_resize:
	xor eax, eax

.end:
	mov rdx, [rbp - 8]
	leave
	ret
