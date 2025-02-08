%include "./include/utils.inc"

extern malloc, free

section .note.GNU-stack noalloc nowrite progbits

section .text

; array_init(self: &CircDynArray) -> Result<(), ()>
global array_init
array_init:
	; # Stack frame
	; [rbp - 8]: &CircDynArray
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
	mov [rdi + CircDynArray.data], rdx
	mov [rdi + CircDynArray.capacity], dword 1
	mov [rdi + CircDynArray.size], dword 0
	mov [rdi + CircDynArray.start], dword 0

.exit:
	leave
	ret

; queue_free(self: &CircDynArray)
global array_free
array_free:
	; # Stack frame
	; [rbp - 8]: &CircDynArray
	push rbp
	mov rbp, rsp
	sub rsp, 16
	mov [rbp - 8], rdi

	mov rdi, [rdi + CircDynArray.data]
	call free

	mov rdi, [rbp - 8]
	xor rax, rax
	mov [rdi + CircDynArray.data], rax
	mov [rdi + CircDynArray.capacity], eax
	mov [rdi + CircDynArray.size], eax
	mov [rdi + CircDynArray.start], eax

	leave
	ret

; array_resize(self: &CircDynArray) -> Result<(), ()>
global array_resize
array_resize:
	; # Stack Frame
	; [rbp - 8]: &CircDynArray
	; [rbp - 12]: u32
	push rbp
	mov rbp, rsp
	sub rsp, 16
	mov [rbp - 8], rdi			; save array

	mov edx, 1
	mov edi, [rdi + CircDynArray.size]
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
	mov rsi, [rdi + CircDynArray.data]
	xor ecx, ecx
.loop:
	xor edx, edx
	mov eax, [rdi + CircDynArray.start]
	add eax, ecx
	div dword [rdi + CircDynArray.capacity]

	mov rax, [rsi + 8 * rdx]
	mov [r8 + 8 * rcx], rax

	inc ecx
	cmp ecx, [rdi + CircDynArray.size]
	jb .loop

	mov [rdi + CircDynArray.data], r8
	mov eax, [rbp - 12]
	mov [rdi + CircDynArray.capacity], eax
	xor eax, eax
	mov [rdi + CircDynArray.start], eax

	mov rdi, rsi
	call free

	xor eax, eax
.exit:
	leave
	ret
