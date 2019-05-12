defmodule FixexTest do
  use ExUnit.Case

  use Fixex,
    adapter: Fixex.Python,
    config: [python_path: to_charlist("test/erl_port/scripts")]

  describe "Fixes" do
    @fix [:hello, :hi]
    fix "converse with Python via a variable name", ctx do
      assert %{fix: "Hi!"} = ctx
    end

    @fix [:hello, :hi]
    fix "converse with Python via a Map", %{fix: fix} do
      assert "Hi!" == fix
    end

    @fix [:hello, :hi]
    fix "converse with Python via a pattern-match", %{fix: fix} = ctx do
      assert %{fix: ^fix} = ctx
      assert "Hi!" == fix
    end
  end

  describe "Fixex calling externals with args" do
    @fix [:hello, :name, "Florin"]
    fix "converse with Python and send args", %{fix: fix} do
      assert "Hello Florin!" == fix
    end
  end

  describe "Fixex and tests side by side" do
    @fix [:hello, :name, "Test"]
    fix "converse with Python", %{fix: fix} do
      assert "Hello Test!" == fix
    end

    test "genius math" do
      assert 2 == 1 + 1
    end
  end
end
