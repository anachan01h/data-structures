# ArrayStack

An `ArrayStack<T>` is an implementation of `Stack<T>` using a dynamic array.

In my implementation, I assume that `T` has a size of 64 bits.

## Attributes
- `data: &T`: a pointer for an array of objects of type `T`;
- `capacity: u32`: the size of `data` array
- `size: u32`: 

## Methods

### `init(self: &ArrayStack<T>) -> Result<()>`

Initializes the dynamic array of an `ArrayStack<T>`.

```
function init(self: &ArrayStack<T>) -> Result<()>:
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