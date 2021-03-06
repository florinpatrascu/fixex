defmodule Fixex.Adapter do
  defmacro __using__(_) do
    quote do
      @behaviour Fixex.Adapter

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

  @type t :: __MODULE__
  @type opts :: list

  @callback start_link(Keyword.t()) :: Supervisor.on_start()
  @callback call(pid, module, function | any, opts) :: {:ok, any} | {:error, any} | any
end
