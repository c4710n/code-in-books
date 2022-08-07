defmodule Mime do
  @external_resource mime_path = Path.join([__DIR__, "mimes.txt"])

  for line <- File.stream!(mime_path, [], :line) do
    [type, rest] =
      line
      |> String.split("\t")
      |> Enum.map(&String.trim(&1))

    extensions = String.split(rest, ~r/,\s?/)

    def exts_from_type(unquote(type)), do: unquote(extensions)
    def type_from_ext(ext) when ext in unquote(extensions), do: unquote(type)
  end

  def exts_from_type(_type), do: []
  def type_from_ext(_ext), do: nil

  def valid_type?(type) do
    type
    |> exts_from_type()
    |> Enum.any?()
  end
end
