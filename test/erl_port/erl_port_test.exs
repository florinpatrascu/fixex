defmodule ErlPortTest do
  use ExUnit.Case

  alias Fixex.{Ruby, Python}

  @scripts_path "test/erl_port/scripts"
  @python_opts [{:python_path, to_charlist(@scripts_path)}]
  @ruby_opts [{:ruby_lib, to_charlist(@scripts_path)}]

  setup_all do
    {:ok, ruby} = Ruby.start_link(@ruby_opts)
    {:ok, python} = Python.start_link(@python_opts)

    %{ruby: ruby, python: python}
  end

  test "Python says: Hi!", %{python: python} do
    assert "Hi!" == Python.call(python, :hello, :hi)
  end

  test "Ruby says: Hi!", %{ruby: ruby} do
    assert "Hi!" == Ruby.call(ruby, :hello, :hi)
  end
end
