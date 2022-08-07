defmodule Hub do
  @moduledoc """
  Documentation for `Hub`.
  """

  @username "c4710n"

  "https://api.github.com/users/#{@username}/repos"
  |> then(&Finch.build(:get, &1, [{"content-type", "application/json"}]))
  |> Finch.request(JustFinch)
  |> case do
    {:ok, %Finch.Response{body: body, status: 200}} ->
      Jason.decode!(body)

    _ ->
      raise "failed to request ;("
  end
  |> Enum.each(fn repo ->
    def unquote(String.to_atom(repo["name"]))() do
      unquote(Macro.escape(repo))
    end
  end)

  def go(repo) do
    url = apply(__MODULE__, repo, [])["html_url"]
    IO.puts("Launching browser to #{url}...")
    System.cmd("open", [url])
  end
end
