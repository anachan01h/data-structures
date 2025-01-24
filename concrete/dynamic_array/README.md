# Dynamic Array

Let `T` be a data type. A **dynamic array** of type `T`, denoted by `DynArray<T>`, is a sequence of objects of type `T` in memory, with variable size.

In this implementation, it's assumed that `T` has size of 64 bits.

## Attributes
- `data: &T`: an address for an array of objects of type `T`;
- `capacity: u32`: the number of objects of type `T` that can be put on `data` array;
- `size: u32`: the number of objects of type `T` that `data` array contains.

## Methods

### `init(self: &DynArray<T>) -> Result<(), ()>`

Initializes `self`.

```
function init(self: &DynArray<T>) -> Result<(), ()>:
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

### `free(self: &DynArray<T>)`

Frees `self`.

```
function free(self: &DynArray<T>):
    mem_free(self.data)
    self.data <- nullptr
    self.capacity <- 0
    self.size <- 0
```

### `resize(self: &DynArray<T>) -> Result<(), ()>`

Updates the size of `self`.

```
function resize(self: &DynArray<T>) -> Result<(), ()>:
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
