defmodule ServyTest do
  use ExUnit.Case
  doctest Servy

  test "greets the world" do
    assert Servy.hello("Elixir") == "Hello, Elixir!"
  end
end
