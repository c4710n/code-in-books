defmodule CounterTest do
  use ExUnit.Case
  doctest Counter

  test "use counter through API" do
    pid = Counter.start(0)
    assert Counter.state(pid) == 0
    Counter.tick(pid)
    Counter.tick(pid)
    count = Counter.state(pid)
    assert count == 2
  end
end
