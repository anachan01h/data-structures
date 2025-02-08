# ArrayQueue

An `ArrayQueue<T>` is an implementation of `Queue<T>` using a `CircDynArray<T>`.

In this implementation, it's assumed that `T` has size of 64 bits.

You can see the attributes and methods of `CircDynArray<T>` [here](../../concrete/circular_dynamic_array).

## Methods

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

Removes a value from the start of `self`, and returns this value (if no error occurs).

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
