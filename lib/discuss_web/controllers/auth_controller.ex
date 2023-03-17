defmodule DiscussWeb.AuthController do
  use DiscussWeb, :controller
  # router.exにあるplug
  # mix.exs,configに追加でコードを書いている
  plug  Ueberauth

  def request(conn, params) do
    IO.puts "+++++++++++"
    IO.inspect(conn.assigns)
    IO.puts "+++++++++++"
    IO.inspect(params)
    IO.puts "+++++++++++"
  end

  def callback(conn, params) do
    IO.puts "+++++++++++"
    IO.inspect(conn.assigns)
    IO.puts "+++++++++++"
    IO.inspect(params)
    IO.puts "+++++++++++"
  end

end
