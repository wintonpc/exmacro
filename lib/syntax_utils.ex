defmodule SyntaxUtils do
  
  def expand(expr) do
    IO.puts(Macro.to_string(Macro.expand_once(expr, __ENV__)))
  end

  def generate_temporaries(n, prefix \\ "t") do
    Enum.map 1..n, fn i ->
      {String.to_atom(prefix <> to_string(i)), [], Elixir}
    end
  end

  defmacro replace(expr, pat, replacement) do
    result = quote do
      SyntaxUtils.deep_replace unquote(expr), fn
        (unquote(pat)) -> unquote(replacement)
        (x) -> :__no_match__
      end
    end
    result
  end

  def deep_replace(ls, f) when is_list(ls) do
    replace_or ls, f, fn ->
      Enum.map(ls, &deep_replace(&1, f))
    end
  end

  def deep_replace(t, f) when is_tuple(t) do
    replace_or t, f, fn ->
      List.to_tuple(deep_replace(Tuple.to_list(t), f))
    end
  end
  
  def deep_replace(x, f) do
    replace_or(x, f, fn -> x end)
  end

  defp replace_or(x, f, alternative) do
    case f.(x) do
      :__no_match__ ->
        alternative.()
      replacement ->
        replacement
    end    
  end

end
