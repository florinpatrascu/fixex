defmodule Fixex do
  @moduledoc """
  Specification of the Fixex adapter API implemented by various custom implementations
  """

  defmacro __using__(opts) do
    quote do
      use ExUnit.Case

      require ExUnit.Callbacks
      require Logger

      import Fixex

      @adapter_name Keyword.get(unquote(opts), :adapter, Fixex.Python)
      @adapter_ok_pid apply(@adapter_name, :start_link, [Keyword.get(unquote(opts), :config, [])])

      Module.register_attribute(__MODULE__, :fix, accumulate: true)

      @before_compile {unquote(__MODULE__), :__before_compile__}
    end
  end

  defmacro __before_compile__(_env) do
    quote do
      def adapter_name(), do: @adapter_name

      def adapter_pid() do
        {:ok, pid} = @adapter_ok_pid
        pid
      end

      def fixes do
        @fix
      end
    end
  end

  defmacro fix(message, var \\ quote(do: _), contents) do
    contents =
      case contents do
        [do: block] ->
          quote do
            unquote(block)
            :ok
          end

        _ ->
          quote do
            try(unquote(contents))
            :ok
          end
      end

    var = Macro.escape(var)
    contents = Macro.escape(contents, unquote: true)

    quote bind_quoted: [var: var, contents: contents, message: message] do
      name = register_test(__ENV__, :fix, message, [])

      def unquote(name)(context) do
        %{fix: fix} = context

        {mod, fun, args} =
          case List.flatten(fix) do
            [] -> raise ArgumentError, "you must specify @fix [module, function, args]"
            [mod, fun] -> {mod, fun, []}
            [mod, fun | args] -> {mod, fun, args}
            _ -> raise ArgumentError, "I don't understand, sorry!"
          end

        response =
          adapter_pid()
          |> adapter_name().call(mod, fun, args)

        unquote(var) = Map.put(context, :fix, response)
        unquote(contents)
      end
    end
  end

  def register_test(%{module: mod, file: file, line: line}, test_type, name, fixex) do
    fix = Module.delete_attribute(mod, :fix)

    {name, _describe, _describe_line, _describetag} =
      case Module.get_attribute(mod, :ex_unit_describe) do
        {line, describe} ->
          description = :"#{test_type} #{describe} #{name}"
          {description, describe, line, Module.get_attribute(mod, :describetag)}

        _ ->
          {:"#{test_type} #{name}", nil, nil, []}
      end

    if Module.defines?(mod, {name, 1}) do
      raise ExUnit.DuplicateTestError, ~s("#{name}" is already defined in #{inspect(mod)})
    end

    tags = %{
      fix: fixex ++ fix,
      line: line,
      file: file,
      test_type: test_type
    }

    test = %ExUnit.Test{name: name, case: mod, tags: tags, module: mod}
    Module.put_attribute(mod, :ex_unit_tests, test)
    Module.delete_attribute(mod, :fix)

    name
  end
end
