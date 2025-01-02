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

### `resize(self: &ArrayQueue<T>) -> Result<(), ()>`

Updates the size of the dynamic array of `self`.

```
function resize(self: &ArrayQueue<T>) -> Result<(), ()>:
	new_capacity <- max(1, 2 * self.size)
	new_data <- mem_alloc(new_capacity * size_of(T))
	if new_data = Error(_):
		return Error
	else if new_data = Ok(data):
		new_data = data
	for i in 0, 1, ..., self.size - 1:
		new_data[i] <- self.data[(self.start + i) % self.capacity]
	mem_free(self.data)
	self.data <- new_data
	self.capacity <- new_capacity
	self.start <- 0
	return Ok
```

### `enqueue(self: &ArrayQueue<T>, value: T) -> Result<(), ()>`

Adds `value` to the end of `self`.

```
function enqueue(self: &ArrayQueue<T>, value: T) -> Result<(), ()>:
	if self.size >= self.capacity:
		result <- self.resize()
		if result = Error:
			return Error
	self.data[(self.start + self.data) % self.capacity] <- value
	self.size <- self.size + 1
	return Ok
```

### `dequeue(self: &ArrayQueue<T>) -> Result<T, ()>`

Removes a value from the start of `self`, and returns this value.

```
function dequeue(self: &ArrayQueue<T>) -> Result<T, ()>:
	value <- self.data[self.start]
	self.start <- (self.start + 1) % self.capacity
	self.size <- self.size - 1
	if self.capacity >= 3 * self.size:
		result <- self.resize()
		if result = Error:
			return Error
	return Ok(value)
```
