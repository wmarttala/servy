defmodule Servy.Wildthings do
  alias Servy.Bear

  @db_path Path.expand("lib/servy/db", File.cwd!())

  def list_bears do
    @db_path
    |> Path.join("bears.json")
    |> read_json()
    |> Jason.decode!(keys: :atoms)
    |> create_bear_list()
  end

  defp read_json(source) do
    case File.read(source) do
      {:ok, contents} ->
        contents
      {:error, reason} ->
        IO.inspect "Error reading #{source}: #{reason}"
        "[]"
    end
  end

  defp parse_list([%{id: id, name: name, type: type, hibernating: hibernating } | tail], bears_created) do
    parse_list(tail, [%Bear{id: id, name: name, type: type, hibernating: hibernating} | bears_created ])
  end

  defp parse_list([%{id: id, name: name, type: type } | tail], bears_created) do
    parse_list(tail, [%Bear{id: id, name: name, type: type} | bears_created ])
  end

  defp parse_list([], bears_created), do: bears_created |> Enum.reverse()

  def create_bear_list(bears)  do
    parse_list(bears, [])
  end

  def get_bear(id) when is_integer(id) do
    Enum.find(list_bears(), fn b -> b.id == id end)
  end

  def get_bear(id) when is_binary(id) do
    id |> String.to_integer() |> get_bear()
  end
end
