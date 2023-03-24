defmodule DiscussWeb.CommentsChannel do
  use DiscussWeb, :channel

  @impl true
  def join(name, _params, socket) do
    IO.puts("---------------------")
    IO.puts (name)
    {:ok, %{hey: "there"}, socket}
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  @impl true
  def handle_in(name, message, socket) do
    IO.puts("----------")
    IO.puts(name)
    IO.inspect(message)
    {:reply, :ok, socket}
  end
end
