defmodule Fixex.Ruby do
  @moduledoc """
  simple adapter for interacting with external apps written in Python or Ruby,
  via the [ErlPort](http://erlport.org/) library
  """
  use Fixex.Adapter

  def start_link(opts \\ [])
  def start_link(opts) when is_list(opts), do: :ruby.start(opts)

  def start_link(_opts), do: :ruby.start()

  def call(pid, mod, function, args \\ [])

  def call(pid, mod, function, args) do
    :ruby.call(pid, mod, function, args)
  end
end
