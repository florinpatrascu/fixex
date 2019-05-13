# FixEx

A hard to pronounce name for a trivial yet very needed functionality: use external apps/cli as optional fixtures providers, for ExUnit tests. This is work in progress, an empty canvas mostly ... for now ;)

With `FixEx` you can write or reuse simple Ruby/Python scripts as fixtures in your Elixir tests.

Using `FixEx` is very simple. Given the following Python Script:

```python
# hello.py
def name(name):
    str = "Hello " + name + "!"
    return str
```

you can write a very simple Elixir test, like this:

```elixir
@fix [:hello, :name, "Florin"]
fix "converse with Python and send args", %{fix: fix} do
  assert "Hello Florin!" == fix
end
```

That's all! Ok, as a "bonus" you can call the scripts mentioned above, in your Elixir app as well. Here's how:

```elixir
defmodule Fixex.ApiTest do
  use ExUnit.Case

  @python {Fixex,
           adapter: Fixex.Python,
           config: [
             python_path: to_charlist("test/erl_port/scripts")
           ]}

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
```

## Install

Add it to your `mix.exs`, as a dependency

```elixir
def deps do
  [{:fixex, "~> 1.0"}]
end
```

Mind you, this is work in progress, any PRs or feedback will be more than welcome, thank you!

## Contributing

- Fork
- Create your feature branch (`git checkout -b my-new-feature`)
- Test (`mix test`)
- Commit your changes (`git commit -am 'Add some feature'`)
- Push to the branch (`git push origin my-new-feature`)
- Create new Pull Request
- Receive my eternal :heart: :)

## License

```txt
Copyright 2019, Florin T.Patrascu

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

   http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
