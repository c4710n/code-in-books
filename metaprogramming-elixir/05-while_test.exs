ExUnit.start()
Code.require_file("05-while.exs", __DIR__)

defmodule WhileTest do
  use ExUnit.Case
  import Loop

  test "while/2 loops as long as the expression is truthy" do
    pid = spawn(fn -> :timer.sleep(:infinity) end)

    send(self(), :one)

    while Process.alive?(pid) do
      receive do
        :one ->
          send(self(), :two)

        :two ->
          send(self(), :three)

        :three ->
          Process.exit(pid, :kill)
          send(self(), :done)
      end
    end

    assert_received :done
  end

  test "break/0 terminates execution" do
    pid = spawn(fn -> :timer.sleep(:infinity) end)

    send(self(), :one)

    while Process.alive?(pid) do
      receive do
        :one ->
          send(self(), :two)

        :two ->
          send(self(), :three)

        :three ->
          send(self(), :done)
          break()
      end
    end

    assert_received :done
  end
end
