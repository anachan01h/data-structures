extern malloc, free

%include "./include/utils.inc"

section .note.GNU-stack noalloc noexec nowrite progbits

section .text

; queue_init(self: &ArrayQueue) -> Result<(), ()>
global queue_init
queue_init:
	; # Stack frame
	; [rbp - 8]: &ArrayQueue
	push rbp
	mov rbp, rsp
	sub rsp, 16
	mov [rbp - 8], rdi

	mov rdi, 1 * 8
	call malloc
	mov rdx, rax

	xor eax, eax
	test rdx, rdx
	setz al
	jz .exit

	mov rdi, [rbp - 8]
	mov [rdi + ArrayQueue.data], rdx
	mov [rdi + ArrayQueue.capacity], dword 1
	mov [rdi + ArrayQueue.size], dword 0
	mov [rdi + ArrayQueue.start], dword 0

.exit:
	leave
	ret

; queue_free(self: &ArrayQueue)
global queue_free
queue_free:
	; # Stack frame
	; [rbp - 8]: &ArrayQueue
	push rbp
	mov rbp, rsp
	sub rsp, 16
	mov [rbp - 8], rdi

	mov rdi, [rdi + ArrayQueue.data]
	call free

	mov rdi, [rbp - 8]
	xor rax, rax
	mov [rdi + ArrayQueue.data], rax
	mov [rdi + ArrayQueue.capacity], eax
	mov [rdi + ArrayQueue.size], eax
	mov [rdi + ArrayQueue.start], eax

	leave
	ret

; queue_resize(self: &ArrayQueue) -> Result<(), ()>
queue_resize:
	; # Stack Frame
	; [rbp - 8]: &ArrayQueue
	; [rbp - 12]: u32
	push rbp
	mov rbp, rsp
	sub rsp, 16
	mov [rbp - 8], rdi			; save queue

	mov edx, 1
	mov edi, [rdi + ArrayQueue.size]
	shl edi, 1					; edi <- 2 * size
	cmovz edi, edx				; if 2 * size == 0, then esi <- 1
	mov [rbp - 12], edi			; save new capacity

	shl rdi, 3					; new_capacity * 8
	call malloc
	mov r8, rax

	mov eax, 1
	test r8, r8
	jz .exit

	mov rdi, [rbp - 8]
	mov rsi, [rdi + ArrayQueue.data]
	xor ecx, ecx
.loop:
	xor edx, edx
	mov eax, [rdi + ArrayQueue.start]
	add eax, ecx
	div dword [rdi + ArrayQueue.capacity]

	mov eax, [rsi + 8 * rdx]
	mov [r8 + 8 * rcx], eax

	inc ecx
	cmp ecx, [rdi + ArrayQueue.size]
	jb .loop

	mov [rdi + ArrayQueue.data], r8
	mov eax, [rbp - 12]
	mov [rdi + ArrayQueue.capacity], eax
	xor eax, eax
	mov [rdi + ArrayQueue.start], eax

	mov rdi, rsi
	call free

	xor eax, eax
.exit:
	leave
	ret

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
	test eax, eax
	jnz .error
	pop rsi
	pop rdi

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
