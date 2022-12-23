defmodule Servy.Plugins do
  @moduledoc "Utilities for handling HTTP requests"

  require Logger

  alias Servy.Conv

  # def emojify(%{status: 200} = conv) do
  #   emojies = String.duplicate("🎉", 5)
  #   body = emojies <> "\n" <> conv.resp_body <> "\n" <> emojies

  #   %{conv | resp_body: body}
  # end

  @doc "Wraps the response body of requests with emojis based on the path provided in the request"
  def emojify(%Conv{path: "/wildthings" <> _, resp_body: resp_body} = conv) do
    %Conv{conv | resp_body: "🐻🦁🐯 #{resp_body} 🐯🦁🐻"}
  end

  def emojify(%Conv{path: "/bears" <> _, resp_body: resp_body} = conv) do
    %Conv{conv | resp_body: "🐻 #{resp_body} 🐻"}
  end

  def emojify(%Conv{resp_body: resp_body} = conv) do
    %Conv{conv | resp_body: "⛔ #{resp_body} ⛔"}
  end

  def track(%Conv{status: 404, path: path} = conv) do
    Logger.warn("Warning: #{path} is on the loose!")
    conv
  end

  def track(%Conv{} = conv), do: conv

  def rewrite_path(%Conv{path: "/wildlife"} = conv) do
    %Conv{conv | path: "/wildthings"}
  end

  def rewrite_path(%Conv{path: "/bears?id=" <> id} = conv) do
    %Conv{conv | path: "/bears/#{id}"}
  end

  def rewrite_path(%Conv{path: path} = conv) do
    regex = ~r{\/(?<thing>\w+)\?id=(?<id>\d+)}
    captures = Regex.named_captures(regex, path)
    rewrite_path_captures(conv, captures)
  end

  def rewrite_path_captures(%Conv{} = conv, %{"thing" => thing, "id" => id}) do
    %{conv | path: "/#{thing}/#{id}"}
  end

  def rewrite_path_captures(%Conv{} = conv, nil), do: conv

  def log(%Conv{} = conv), do: IO.inspect(conv)

end