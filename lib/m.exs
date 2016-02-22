# in a module
defmodule Fib do
  def fib(0), do: 1
  def fib(1), do: 1
  def fib(n), do: fib(n-1) + fib(n-2)
end

# as a fun
fib = fn
  (0) -> 1
  (1) -> 1
  (n) -> fib.(n-1) + fib.(n-2)
end

# ...but it doesn't work because fib is out of scope

# we can pass fib to itself
fibfib = fn
  (fib, 0) -> 1
  (fib, 1) -> 1
  (fib, n) -> fib.(fib, n-1) + fib.(fib, n-2)
end

fib = fn n -> fibfib.(fibfib, n) end


# ... or ...


# define a fib function generator that takes a fib function to recurse with
fib_gen = fn fib ->
  fn
    (0) -> 1
    (1) -> 1
    (n) -> fib.(n-1) + fib.(n-2)
  end
end

# define fib in terms of the generator
fib = fn n ->
  fib_gen.(fib_gen.(fib_gen.(fib_gen.(:error)))).(n)
end

# refactor a bit
fib = fn n ->
  g = fib_gen.(g)
  g.(n)
end

# oops, g is a recursive definition

# make g a function that receives itself as an argument
fib = fn n ->
  g = fn g ->
    fib_gen.(g.(g))
  end
  g.(g).(n)
end

# ... still spins without ever using n

# delay evaluation of g.(g) until we actually need to recur
fib = fn n ->
  g = fn g ->
    fib_gen.(fn x -> g.(g).(x) end)
  end
  g.(g).(n)
end

# factor out fixed point combinator
y = fn f ->
  g = fn g ->
    f.(fn x -> g.(g).(x) end)
  end
  g.(g)
end

fib = y.(fib_gen)

# But it's still limited to arity 1 functions.
# Exercise: make it work for arbitrary arity recursive functions (up to, say, arity 20)
# Hint: macros may help ;)

###########################

fib_gen = fn fib ->
  fn
    (0) -> 1
    (1) -> 1
    (n) -> fib.(n-1) + fib.(n-2)
  end
end

fib = y.(fib_gen)

