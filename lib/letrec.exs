defmodule LetRec do
  import Enum
  import SyntaxUtils

  defmacro letrec({:=, _, [id, fun]}) do
    quote do
      gen = fn unquote(id) ->
        unquote(fun)
      end
      unquote(id) = LetRec.y(gen)
    end
  end

  def y(f) do
    g = fn g -> f.(fn n -> g.(g).(n) end) end
    g.(g)
  end
  
  # defmacro letrec({:=, _, [id, {:fn, ctx, clauses}]}) do
  #   params = SyntaxUtils.generate_temporaries(arg_count(hd(clauses)))
  #   quote do
  #     fibfib = unquote({:fn, ctx, map(clauses, &fix_clause(id, &1))})
  #     unquote(id) = fn unquote_splicing(params) ->
  #       fibfib.(fibfib, unquote_splicing(params))
  #     end
  #   end
  # end

  # def arg_count({:->, _, [params, _]}) do
  #   length(params)
  # end

  # def fix_clause(id, {:->, ctx, [params, body]}) do
  #   {:->, ctx, [[id|params], fix_body(id, body)]}
  # end

  # def fix_body({raw_id, _, _} = id, body) do
  #   SyntaxUtils.replace(body,
  #                       {{:., _, [{^raw_id, _, _}]}, _, args},
  #                       {{:., _, [{raw_id, _, _}]}, _, [id|args]})
  # end
end
