fibfib = fn
  (fib, 0) -> 1
  (fib, 1) -> 1
  (fib, n) -> fib.(fib, n-1) + fib.(fib, n-2)
end

fib = fn n -> fibfib.(fibfib, n) end

letrec fib = fn
  (0) -> 1
  (1) -> 1
  (n) -> fib.(n-1) + fib.(n-2)
end

quote do
  letrec fib = fn
    (0) -> 1
    (1) -> 1
    (n) -> fib.(n-1) + fib.(n-2)
  end
end

SyntaxUtils.expand(quote do
                    letrec fib = fn
                      (0) -> 1
                      (1) -> 1
                      (n) -> fib.(n-1) + fib.(n-2)
                    end
end)


