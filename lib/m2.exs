# fib_gen = fn fib ->
#   fn
#     (0) -> 1
#     (1) -> 1
#     (n) -> fib.(n-1) + fib.(n-2)
#   end
# end

# fib = y.(fib_gen)

############################

stx = quote do
  letrec fib = fn
    (0) -> 1
    (1) -> 1
    (n) -> fib.(n-1) + fib.(n-2)
  end
end

IO.puts inspect(stx, pretty: true)

defmodule M do
  def y(f) do
    g = fn g ->
      f.(fn x -> g.(g).(x) end)
    end
    g.(g)
  end
  
  defmacro letrec({:=, _, [id, fun]}) do
    quote do
      gen = fn unquote(id) ->
        unquote(fun)
      end
      unquote(id) = M.y(gen)
    end
  end
end
