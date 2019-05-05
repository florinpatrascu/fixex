defmodule Fixex do
  @moduledoc """
  Specification of the Fixex adapter API implemented by various custom implementations
  """

  defmacro __using__(_) do
    quote do
      @behaviour Fixex

      def child_spec(opts) do
        %{
          id: __MODULE__,
          start: {__MODULE__, :start_link, [opts]},
          type: :worker,
          restart: :permanent,
          shutdown: 500
        }
      end

      defoverridable child_spec: 1
    end
  end

  @type opts :: list

  @callback start_link(Keyword.t()) :: Supervisor.on_start()
  @callback call(pid, module, function | any, opts) :: {:ok, any} | {:error, any} | any
end
