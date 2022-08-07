defmodule Loop do
  defmacro while(expr, do: block) do
    quote do
      try do
        # Elixir has no built-in way to loop, so we cheat at here - creating
        # an infinite stream and consuming it.
        for _ <- Stream.cycle([:ok]) do
          if unquote(expr) do
            unquote(block)
          else
            throw(:break)
          end
        end
      catch
        :break -> :ok
      end
    end
  end

  def break, do: throw(:break)
end

# iex> import Loop
#
# iex> pid = spawn fn ->
#   while true do
#     receive do
#       :stop ->
#         IO.puts "Stopping..." break
#       message ->
#         IO.puts "Got #{inspect message}"
#     end
#   end
# end
#
# iex> send pid, :hello
# iex> send pid, :ping
# iex> send pid, :stop
# iex> Process.alive? pid
