fib_gen = fn fib ->
  fn
    (0) -> 1
    (1) -> 1
    (n) -> fib.(n-1) + fib.(n-2)
  end
end

y = fn f ->
  g = fn g -> f.(fn n -> g.(g).(n) end) end
  g.(g)
end

fib = y.(fib_gen)

letrec fib = fn
  (0) -> 1
  (1) -> 1
  (n) -> fib.(n-1) + fib.(n-2)
end

SyntaxUtils.expand(quote do
                    letrec fib = fn
                      (0) -> 1
                      (1) -> 1
                      (n) -> fib.(n-1) + fib.(n-2)
                    end
end)

1..10
|> map(x -> x*x)
