# ArrayStack

An `ArrayStack<T>` is an implementation of `Stack<T>` using a dynamic array.

In this implementation, it's assumed that `T` has size of 64 bits.

## Attributes
- `data: &T`: a pointer for an array of objects of type `T`;
- `capacity: u32`: the number of objects of type `T` that can be put on `data` array;
- `size: u32`: the number of objects of type `T` that `data` array contains.

## Methods

### `init(self: &ArrayStack<T>) -> Result<(), ()>`

Initializes the dynamic array of an `ArrayStack<T>`.

```
function init(self: &ArrayStack<T>) -> Result<(), ()>:
    result <- mem_alloc(size_of(T))
    if result = Error(_):
        return Error
    else if result = Ok(data):
        result <- data
    self.data <- result
    self.capacity <- 1
    self.size <- 0
    return Ok
```

### `free(self: &ArrayStack<T>)`

Frees the dynamic array of an `ArrayStack<T>`.

```
function free(self: &ArrayStack<T>):
    mem_free(self.data)
    self.data <- nullptr
    self.capacity <- 0
    self.size <- 0
```

### `resize(self: &ArrayStack<T>) -> Result<(), ()>`

Updates the size of the dynamic array of `self`.

```
function resize(self: &ArrayStack<T>) -> Result<(), ()>:
	new_capacity <- max(1, 2 * self.size)
	result <- mem_realloc(self.data, new_capacity * size_of(T))
	if result = Error(_):
		return Error
	else if result = Ok(data):
		result <- data
	self.data <- result
	self.capacity <- new_capacity
	return Ok
```

### `push(self: &ArrayStack<T>, value: T) -> Result<(), ()>`

Pushes `value` onto `self`.

```
function push(self: &ArrayStack<T>, value: T) -> Result<(), ()>:
	if self.size >= self.capacity:
		result <- self.resize()
		if result = Error:
			return Error
	self.data[self.size] <- value
	self.size <- self.size + 1
	return Ok
```

### `pop(self: &ArrayStack<T>) -> Result<T, ()>`

Pops a value from `self`, and returns this value (if no error occurs).

```
function pop(self: &ArrayStack<T>) -> Result<T, ()>:
	value <- self.data[self.size - 1]
	self.size <- self.size - 1
	if self.capacity >= 3 * self.size:
		result <- self.resize()
		if result = Error:
			return Error
	return Ok(value)
```
