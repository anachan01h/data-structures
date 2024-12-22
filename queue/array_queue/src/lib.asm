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
