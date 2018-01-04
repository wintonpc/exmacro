defmodule Hacks do
  defmacro args ~> body do
    case args do
      {:__block__, _, args} ->
        quote do
          fn unquote_splicing(args) -> unquote(body) end
        end
      _ ->
        quote do
          fn unquote(args) -> unquote(body) end
        end
    end
  end

  defmacro defstruct2(name, fields) do
    kws = Enum.map(fields, fn {name, _, _} -> {name, nil} end)
    quote do
      defmodule unquote(name) do
        defstruct unquote(kws)
      end
    end
  end
end
