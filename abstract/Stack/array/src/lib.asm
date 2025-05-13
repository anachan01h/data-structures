%include "./include/def.inc"

section .note.GNU-stack noalloc noexec nowrite progbits

section .text

; stack_push(self: &Stack, value: i64) -> Result<(), ()>
global stack_push
stack_push:
	push rbp
	mov rbp, rsp

	xor eax, eax
	mov edx, [rdi + Stack.size]
	mov ecx, [rdi + Stack.capacity]
	cmp edx, ecx
	setae al
	jae .overflow

	mov rdx, [rdi + Stack.data]
	mov ecx, [rdi + Stack.size]
	mov [rdx + 8 * rcx], rsi
	inc dword [rdi + Stack.size]

.overflow:
	leave
	ret

; stack_pop(self: &Stack) -> Result<i64, ()>
global stack_pop
stack_pop:
	push rbp
	mov rbp, rsp

	xor eax, eax
	mov edx, [rdi + Stack.size]
	test edx, edx
	setz al
	jz .underflow

	dec dword [rdi + Stack.size]
	mov rdx, [rdi + Stack.data]
	mov ecx, [rdi + Stack.size]
	mov rdx, [rdx + 8 * rcx]

.underflow:
	leave
	ret
