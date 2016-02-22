defmodule SyntaxUtilsTest do
  use ExUnit.Case
  import SyntaxUtils
  import Enum
  
  test "generate_temporaries" do
    assert map(generate_temporaries(2), &Macro.to_string/1) == ["t1", "t2"]
    assert map(generate_temporaries(2, "a"), &Macro.to_string/1) == ["a1", "a2"]
  end

  test "replace" do
    assert replace(:a, x, to_string(x)) == "a"
    assert replace({:a, 1}, 1, -1) == {:a, -1}
    assert replace([{:a, 1}, {:b, 2}], {:b, x}, {:b, -x}) == [{:a, 1}, {:b, -2}]
    assert replace({{:a, 1}, {:b, 2}}, {:b, x}, {:b, -x}) == {{:a, 1}, {:b, -2}}
    assert replace({{:a, 1}, {:b, 2}}, {_, _}, 42) == 42
    # assert replace([{:a, 1}, {:b, 2}, {:c, [4]}],
    #                [{:a, _}, {:b, _}, {:c, xs}],
    #                [{:a, _}, {:b, _}, {:c, [3|xs]}]) == [{:a, 1}, {:b, 2}, {:c, [3, 4]}]
  end
end
