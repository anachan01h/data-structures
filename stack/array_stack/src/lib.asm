%include "./include/utils.inc"

extern stack_resize

section .note.GNU-stack noalloc noexec nowrite progbits

section .text

; stack_push(stack: &ArrayStack, value: u64) -> Result<(), ()>
global stack_push
stack_push:
	push rbp
	mov rbp, rsp
	xor eax, eax

	mov edx, [rdi + ArrayStack.capacity]
	cmp [rdi + ArrayStack.size], edx ; if stack.size >= stack.capacity...
	jb .no_resize

	push rdi
	push rsi					; save arguments
	call stack_resize			; ... then stack.resize()
	test eax, eax
	jnz .error
	pop rsi
	pop rdi						; restore arguments

.no_resize:
	mov rdx, [rdi + ArrayStack.data]
	mov ecx, [rdi + ArrayStack.size]
	mov [rdx + 8 * rcx], rsi
	inc dword [rdi + ArrayStack.size]

.error:
	leave
	ret

; stack_pop(stack: &ArrayStack) -> Result<u64, ()>
global stack_pop
stack_pop:
	; # Stack Frame
	; [rbp - 8]: u64
	push rbp
	mov rbp, rsp
	sub rsp, 16
	xor eax, eax

	mov rsi, [rdi + ArrayStack.data]
	mov ecx, [rdi + ArrayStack.size]
	mov rdx, [rsi + 8 * rcx - 8]
	mov [rbp - 8], rdx			; save top value
	dec dword [rdi + ArrayStack.size] ; decrement size

	dec ecx
	mov eax, 3
	mul ecx
	cmp eax, [rdi + ArrayStack.capacity] ; if 3 * stack.size <= stack capacity...
	ja .no_resize

	call stack_resize			; ... then stack.resize()
	jmp .end

.no_resize:
	xor eax, eax

.end:
	mov rdx, [rbp - 8]
	leave
	ret
