struc ArrayDeque
	.data resq 1
	.capacity resd 1
	.size resd 1
	.start resd 1
endstruc

%define deque_init array_init
%define deque_free array_free
%define deque_resize array_resize
