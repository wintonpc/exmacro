fib2 = fn
  (_, 0) -> 1
  (_, 1) -> 1
  (fib, n) -> fib.(fib, n-1) + fib.(fib, n-2)
end

fib = fn n -> fib2.(fib2, n) end

############################

stx = quote do
  letrec fib, fn
    (0) -> 1
    (1) -> 1
    (n) -> fib.(n-1) + fib.(n-2)
  end
end

IO.puts inspect(stx, pretty: true)

defmodule M do  
  defmacro letrec(id, fun) do
    quote do
      gen = fn unquote(id) ->
        unquote(fun)
      end
      unquote(id) = M.y(gen)
    end
  end
end
