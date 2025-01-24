# ArrayStack

An `ArrayStack<T>` is an implementation of `Stack<T>` using a `DynArray<T>`.

In this implementation, it's assumed that `T` has size of 64 bits.

You can see the attributes and methods of `DynArray<T>` [here](../../concrete/dynamic_array).

## Methods

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
