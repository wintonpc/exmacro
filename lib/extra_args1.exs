defmodule Hacks do
  import SyntaxUtils
  
  defmacro letrec({:=, _, [id, {:fn, ctx, clauses}]}) do
    num_args = num_clause_args(hd(clauses))
    params = SyntaxUtils.generate_temporaries(num_args)
    fixed_clauses = Enum.map clauses, fn {:->, ctx, [params, body]} ->
      {:->, ctx, [[id|params], fix_body(id, body)]}
    end
    quote do
      ff = unquote({:fn, ctx, fixed_clauses})
      unquote(id) = fn unquote_splicing(params) -> ff.(ff, unquote_splicing(params)) end
    end
  end

  def fix_body({raw_id, _, _} = id, body) do
    replace(body,
            {{:., c1, [{^raw_id, c2, z}]}, c3, args},
            {{:., c1, [{raw_id, c2, z}]}, c3, [id|args]})
  end
  
  def num_clause_args({:->, _, [args, 1]}) do
    length(args)
  end
end
