struc ArrayQueue
	.data resq 1
	.capacity resd 1
	.size resd 1
	.start resd 1
endstruc

%define queue_init array_init
%define queue_free array_free
%define queue_resize array_resize
