defmodule Fixex.ApiTest do
  use ExUnit.Case

  @python {Fixex,
           adapter: Fixex.Python, config: [python_path: to_charlist("test/erl_port/scripts")]}

  setup_all do
    {:ok, python} = start_supervised(@python)

    {:ok, adapter: python}
  end

  describe "API for general use" do
    test "use Fixex to call Python", %{adapter: python} do
      assert "Goodbye Joe :'(" == Fixex.call(python, :hello, :goodbye, "Joe")
    end
  end
end
