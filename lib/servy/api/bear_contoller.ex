defmodule Servy.Api.BearController do

  def index(conv) do
    json =
      Servy.Wildthings.list_bears()
      |> Jason.encode!()

      conv = put_resp_content_type(conv, "application/json")

      %{conv | status: 200, resp_body: json}
  end

  def create(conv, %{"name" => name, "type" => type}) do
    %{conv | status: 201, resp_body: "Created a #{type} bear named #{name}!"}
  end

  def put_resp_content_type(%Servy.Conv{resp_headers: resp_headers} = conv, type) when is_binary(type) do
  headers = Map.put(resp_headers, "Content-Type", type)
  %{ conv | resp_headers: headers }
end

end
