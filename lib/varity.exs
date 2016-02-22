defmodule EmitY do    
  defmacro emit_y do
    quote do
      def y(f) do
        case :erlang.fun_info(f.(nil))[:arity] do
          unquote(
            Enum.map(1..10, fn n ->
              params = SyntaxUtils.generate_temporaries(n)
              quote do
                unquote(n) ->
                  g = fn g ->
                    f.(fn unquote_splicing(params) -> g.(g).(unquote_splicing(params)) end)
                  end
                  g.(g)
              end
            end) |> Enum.concat)
        end
      end
    end
  end
end

defmodule Varity do
  # def varity(f) do
  #   result = fn args -> IO.puts "apply(#{inspect(f)}, #{inspect(args)}"; apply(f, args) end
  #   result
  # end

  # def unvarity(f) do
  #   case :erlang.fun_info(f)[:arity] do
  #     1 ->
  #       fn a1 -> f.([a1]) end
  #   end
  # end

  require EmitY
  
  EmitY.emit_y

  def test do
    fib_gen = fn fib ->
      fn
        (0) -> 1
        (1) -> 1
        (n) -> fib.(n-1) + fib.(n-2)
      end
    end

    fib = y(fib_gen)
  end
end
