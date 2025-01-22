%include "./include/utils.inc"

extern malloc, realloc, free

section .note.GNU-stack noalloc noexec nowrite progbits

section .text

; array_init(array: &DynArray) -> Result<(), ()>
global array_init
array_init:
    ; # Stack frame
    ; [rbp - 8]: &DynArray
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
    jz .error

    mov rdi, [rbp - 8]
    mov [rdi + DynArray.data], rdx
    mov [rdi + DynArray.capacity], dword 1
    mov [rdi + DynArray.size], dword 0

.error:
    leave
    ret

; array_free(array: &DynArray)
global array_free
array_free:
	; # Stack Frame
	; [rbp - 8]: &DynArray
	push rbp
	mov rbp, rsp
	sub rsp, 16
	mov [rbp - 8], rdi

	mov rdi, [rdi + DynArray.data]
	call free

	mov rdi, [rbp - 8]
	xor eax, eax
	mov [rdi + DynArray.data], rax
	mov [rdi + DynArray.capacity], eax
	mov [rdi + DynArray.size], eax

	leave
	ret

; array_resize(array: &DynArray) -> Result<(), ()>
global array_resize
array_resize:
	; # Stack Frame
	; [rbp - 8]: &DynArray
	; [rbp - 12]: u32
	push rbp
	mov rbp, rsp
	sub rsp, 16
	mov [rbp - 8], rdi

	mov edx, 1
	mov esi, [rdi + DynArray.size]
	shl esi, 1					; esi <- 2 * size
	cmovz esi, edx				; (2 * size == 0) ? esi <- 1
	mov [rbp - 12], esi			; save new capacity

	mov rdi, [rdi + DynArray.data]
	shl rsi, 3
	call realloc
	mov rdx, rax

	xor eax, eax
	test rdx, rdx
	setz al
	jz .error

	mov rdi, [rbp - 8]
	mov [rdi + DynArray.data], rdx
	mov esi, [rbp - 12]
	mov [rdi + DynArray.capacity], esi

.error:
	leave
	ret
