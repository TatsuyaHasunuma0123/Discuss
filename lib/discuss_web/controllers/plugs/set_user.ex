#ユーザがログインしているかを判定するためのplug
defmodule DiscussWeb.Plugs.SetUser do
  import Plug.Conn
  import Phoenix.Controller

  alias Discuss.Repo
  alias DiscussWeb.User
  alias DiscussWeb.Router.Helpers

  # initとcallは自動で呼び出される関数
  def init(_params) do
  end

  def call(conn, _pamams) do
    user_id = get_session(conn, :user_id)

    # 条件式がtrueなら以降のコードを実行
    cond do
      # Repo.getがユーザーを返すならnilを返さない
      # user_idの定義
      # => true
      # User構造体がuser変数に代入される
      user = user_id && Repo.get(User, user_id) ->
        assign(conn, :user, user)
      # iex> red = 1 && "red"
      # iex> red
      # "red"
      # conn.assigns.user => user struct
      true ->
        assign(conn, :user, nil)
    end
  end
end
