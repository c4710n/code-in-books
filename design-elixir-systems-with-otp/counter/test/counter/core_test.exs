defmodule Counter.CoreTest do
  use ExUnit.Case
  doctest Counter

  test "inc increments an integer value" do
    assert Counter.Core.inc(1) == 2
  end
end
