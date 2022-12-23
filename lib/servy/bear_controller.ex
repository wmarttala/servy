defmodule Servy.BearController do
  alias Servy.Wildthings
  alias Servy.Bear

  defp bear_item(bear) do
    "<li>#{bear.name} - #{bear.type}</li>"
  end

  def index(conv) do
    items =
      Wildthings.list_bears()
      |> Enum.filter(&Bear.is_grizzly/1)
      |> Enum.sort(&Bear.order_asc_by_name/2)
      |> Enum.map(&bear_item/1)
      |> Enum.join()

    %{conv | status: 200, resp_body: "<ul>#{items}</ul>"}
  end

  @spec show(%{:resp_body => any, :status => any, optional(any) => any}, map) :: %{
          :resp_body => <<_::40, _::_*8>>,
          :status => 200,
          optional(any) => any
        }
  def show(conv, %{"id" => id}) do
    bear = Wildthings.get_bear(id)
    %{conv | status: 200, resp_body: "<h1>Bear #{bear.id}: #{bear.name}"}
  end

  def create(conv, %{"type" => type, "name" => name}) do
    %{conv | status: 201, resp_body: "Created a #{type} bear named #{name}"}
  end

  def delete(conv, %{"id" => id}) do
    %{
      conv
      | status: 403,
        resp_body: "Deleting a Bear is Forbidden!! We see you trying to delete Bear #{id}"
    }
  end
end
