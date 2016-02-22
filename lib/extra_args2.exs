defmodule LetRec do
  import Enum
  import SyntaxUtils
  
  defmacro letrec({:=, _, [id, {:fn, ctx, clauses}]}) do
    params = SyntaxUtils.generate_temporaries(arg_count(hd(clauses)))
    quote do
      fibfib = unquote({:fn, ctx, map(clauses, &fix_clause(id, &1))})
      unquote(id) = fn unquote_splicing(params) ->
        fibfib.(fibfib, unquote_splicing(params))
      end
    end
  end

  def arg_count({:->, _, [args, _]}) do
    length(args)
  end

  def fix_clause(id, {:->, ctx, [args, body]}) do
    {:->, ctx, [[id|args], fix_body(id, body)]}
  end

  def fix_body({raw_id, _, _} = id, body) do
    SyntaxUtils.replace(body,
                        {{:., c1, [{^raw_id, c3, z1}]}, c2, args},
                        {{:., c1, [{raw_id, c3, z1}]}, c2, [id|args]})
  end
end
