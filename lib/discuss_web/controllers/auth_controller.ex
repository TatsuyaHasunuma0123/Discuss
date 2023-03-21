defmodule DiscussWeb.AuthController do
  use DiscussWeb, :controller
  alias DiscussWeb.User
  alias Discuss.Repo
  plug Ueberauth

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn,  _params) do
    user_params = %{token: auth.credentials.token,
                    email: auth.info.email,
                    provider: "github"}
    changeset  = User.changeset(%User{}, user_params)

    signin(conn, changeset)
  end


  #     @spec configure_session(t(), Keyword.t()) :: t()
  # Configures the session.

  # Options
  # :renew - When true, generates a new session id for the cookie
  # :drop - When true, drops the session, a session cookie will not be included in the response
  # :ignore - When true, ignores all changes made to the session in this request cycle
  def signout(conn, _params) do
    conn
    |> configure_session(drop: true)
    |> redirect(to: Routes.topic_path(conn, :index))
  end

  defp signin(conn, changeset) do
    case insert_or_update_user(changeset) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Welcome back!")
        |> put_session(:user_id, user.id)
        |> redirect(to: Routes.topic_path(conn, :index))
      {:error, _reason} ->
        conn
        |> put_flash(:error, "Error Signing In")
        |> redirect(to: Routes.topic_path(conn, :index))
    end
  end

  # ユーザがすでにログインしているかを確認
  defp insert_or_update_user(changeset) do
    # get_by(検索したいテーブルのモジュール，検索条件)
    # 合：それを返す　否：nil　
    case Repo.get_by(User, email: changeset.changes.email) do
      nil ->
        Repo.insert(changeset) #戻り値は 1.{:ok,user}　2.{:error,reason}
      user ->
        {:ok, user}
    end
  end
end
