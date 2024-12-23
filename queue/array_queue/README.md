# ArrayQueue

An `ArrayQueue<T>` is an implementation of `Queue<T>` using a dynamic circular array.

In this implementation, it's assumed that `T` has size of 64 bits.

## Attributes
- `data: &T`: a pointer for an array of objects of type `T`;
- `capacity: u32`: the number of objects of type `T` that can be put on `data` array;
- `size: u32`: the number of objects of type `T` that `data` array contains;
- `start: u32`: the position of the first object inside `data` array.

## Methods

### `init(self: &ArrayQueue<T>) -> Result<(), ()>`

Initializes the dynamic circular array of `self`.

```
function init(self: &ArrayQueue<T>) -> Result<(), ()>:
	result <- mem_alloc(size_of(T))
	if result = Error(_):
		return Error
	else if result = Ok(data):
		result <- data
	self.data <- result
	self.capacity <- 1
	self.size <- 0
	self.start <- 0
	return Ok
```

### `free(self: &ArrayQueue<T>)`

Frees the dynamic circular array of `self`.

```
function free(self: &ArrayQueue<T>):
	mem_free(self.data)
	self.data <- nullptr
	self.capacity <- 0
	self.size <- 0
	self.start <- 0
```
