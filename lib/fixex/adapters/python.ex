defmodule Fixex.Python do
  @moduledoc """
  simple adapter for interacting with external apps written in Python or Ruby,
  via the [ErlPort](http://erlport.org/) library
  """
  use Fixex

  def start_link(opts \\ [])
  def start_link(opts) when is_list(opts), do: :python.start(opts)

  def start_link(_opts), do: :python.start()

  def call(pid, mod, function, args \\ [])

  def call(pid, mod, function, args) do
    :python.call(pid, mod, function, args)
  end
end
