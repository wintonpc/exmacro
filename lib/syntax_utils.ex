defmodule SyntaxUtils do
  
  def expand(expr) do
    IO.puts(Macro.to_string(Macro.expand_once(expr, __ENV__)))
  end

  def generate_temporaries(n, prefix \\ "t") do
    Enum.take(temporaries(prefix), n)
  end

  def temporaries(prefix \\ "t") do
    Stream.map naturals, fn i ->
      {String.to_atom(prefix <> to_string(i)), [], Elixir}
    end
  end
  
  defp naturals do
    Stream.unfold(1, fn next -> {next, next+1} end)
  end

  defmacro replace(expr, pat, replacement) do
    quote do
      {result, _acc} = SyntaxUtils.deep_replace unquote(expr), fn
        (unquote(pat), acc) -> {unquote(replacement), acc}
        (x, _acc) -> :__no_match__
      end, nil
      result
    end
  end

  def deep_replace(ls, f, acc) when is_list(ls) do
    replace_or ls, f, acc, fn acc ->
      List.foldr ls, {[], acc}, fn x, {xs, acc} ->
        {replacement, acc} = deep_replace(x, f, acc)
        {[replacement|xs], acc}
      end
    end
  end

  def deep_replace(t, f, acc) when is_tuple(t) do
    replace_or t, f, acc, fn acc ->
      {replacement, acc} = deep_replace(Tuple.to_list(t), f, acc)
      {List.to_tuple(replacement), acc}
    end
  end
  
  def deep_replace(x, f, acc) do
    replace_or(x, f, acc, fn acc -> {x, acc} end)
  end

  defp replace_or(x, f, acc, alternative) do
    case f.(x, acc) do
      :__no_match__ ->
        alternative.(acc)
      {replacement, acc} ->
        {replacement, acc}
    end    
  end

end
