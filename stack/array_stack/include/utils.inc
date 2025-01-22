struc ArrayStack
    .data resq 1
    .capacity resd 1
    .size resd 1
endstruc

%define stack_init array_init
%define stack_free array_free
%define stack_resize array_resize