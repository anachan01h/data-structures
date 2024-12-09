extern malloc, realloc, free
    
struc ArrayStack
    .data resq 1
    .capacity resd 1
    .size resd 1
endstruc

section .bss
    stack resb ArrayStack_size

section .text
global main

main:
    push rbp
    mov rbp, rsp

    mov rdi, stack
    call stack_init
    test eax, eax
    jnz .early_exit

	mov rdi, stack
	mov rsi, 5
	call stack_push

	mov rdi, stack
	mov rsi, 12
	call stack_push

	mov rdi, stack
	mov rsi, 15
	call stack_push

	mov rdi, stack
	call stack_pop

	mov rdi, stack
	call stack_pop

.exit:
	mov rbx, [stack + ArrayStack.capacity]
	mov rbx, rdx

    mov rdi, stack
    call stack_free

	mov rax, rbx
.early_exit:
    leave
    ret

; stack_init(stack: &ArrayStack) -> Result<(), ()>
stack_init:
    ; # Stack frame
    ; [rbp - 8]: &ArrayStack
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
    mov [rdi + ArrayStack.data], rdx
    mov [rdi + ArrayStack.capacity], dword 1
    mov [rdi + ArrayStack.size], dword 0

.exit:
    leave
    ret

; stack_free(stack: &ArrayStack)
stack_free:
    ; # Stack frame
    ; [rbp - 8]: &ArrayStack
    push rbp
    mov rbp, rsp
    sub rsp, 16
    mov [rbp - 8], rdi

    mov rdi, [rdi + ArrayStack.data]
    call free

    mov rdi, [rbp - 8]
    xor rax, rax
    mov [rdi + ArrayStack.data], rax
    mov [rdi + ArrayStack.capacity], eax
    mov [rdi + ArrayStack.size], eax

    leave
    ret

; stack_resize(stack: &ArrayStack) -> Result<(), ()>
stack_resize:
    ; # Stack Frame
    ; [rbp - 8]: &ArrayStack
    ; [rbp -12]: u32
    push rbp
    mov rbp, rsp
    sub rsp, 16
    mov [rbp - 8], rdi          ; save stack as local variable

    mov edx, 1
    mov esi, [rdi + ArrayStack.size]
    shl esi, 1                  ; esi <- 2 * size
    cmovz esi, edx              ; if 2 * size == 0, then esi <- 1
    mov [rbp - 12], esi         ; save new capacity as local variable
    mov rdi, [rdi + ArrayStack.data]
    call realloc
    mov rdx, rax

    xor eax, eax
    test rdx, rdx
    setz al
    jz .exit

    mov rdi, [rbp - 8]
    mov [rdi + ArrayStack.data], rdx
    mov esi, [rbp - 12]
    mov [rdi + ArrayStack.capacity], esi

.exit:
    leave
    ret

; stack_push(stack: &ArrayStack, value: u64) -> Result<(), ()>
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

.no_resize:
	mov rdx, [rbp - 8]
	leave
	ret
