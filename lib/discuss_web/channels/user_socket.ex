defmodule DiscussWeb.UserSocket do
  use Phoenix.Socket

  channel "comments:*", DiscussWeb.CommentsChannel

  def connect(%{"token" => token}, socket) do
    {:ok, socket}
  end

  def id(_socket), do: nil
end
