# Circular Dynamic Array

Let `T` be a data type. A **circular dynamic array** of type `T`, denoted by `CircDynArray<T>`, is a sequence of objects of type `T` in memory, with variable size, where we consider that the first element comes after the last element.

In this implementation, it's assumed that `T` has size of 64 bits.

## Attributes
- `data: &T`: a pointer for an array of objects of type `T`;
- `capacity: u32`: the number of objects of type `T` that can be put on `data` array;
- `size: u32`: the number of objects of type `T` that `data` array contains;
- `start: u32`: the position of the first object inside `data` array.

## Methods

### `init(self: &CircDynArray<T>) -> Result<(), ()>`

Initializes `self`.

```
function init(self: &CircDynArray<T>) -> Result<(), ()>:
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

### `free(self: &CircDynArray<T>)`

Frees `self`.

```
function free(self: &CircDynArray<T>):
	mem_free(self.data)
	self.data <- nullptr
	self.capacity <- 0
	self.size <- 0
	self.start <- 0
```

### `resize(self: &CircDynArray<T>) -> Result<(), ()>`

Updates the size of `self`.

```
function resize(self: &CircDynArray<T>) -> Result<(), ()>:
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
