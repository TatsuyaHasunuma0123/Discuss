#Controllerの役割
  #　Routerで定義したデフォルトルートに関連付けられたページを表示する

#アクション名の規約
  # index - 与えられたリソースタイプの全アイテムのリストを表示する
  # show  - IDを元に個々のアイテムを表示
  # new   - 新しいアイテムを受け取るためのフォームをレンダリング
  # create  - 新しいアイテムのパラメータを受け取り、それをデータストアに保存
  # edit  - 個々のアイテムをIDで取得し、編集用のフォームに表示
  # update - 編集されたアイテムのパラメータを受け取り、データストアに保存
  # delete  - 削除するアイテムのIDを受け取り、データストアから削除

#パラメータ
  # conn  - 常に最初のパラメータ。リクエストに関する情報を保持する構造体
  # params  - HTTPリクエストで渡された全てのパラメータを保持するマップ

#レンダリング
  # text/2  - HTMLなしのプレーンテキストとして表示
  #json/2 - 純粋なJSONをレンダリング
  #render/3 - コントローラとビューが同じルート名を共有している必要がある。
              # HelloControllerはHelloViewが必要 HellowViewはtemplates/helloディレクトリが必要


  defmodule DiscussWeb.TopicController do
  #DiscussWebのControllerモジュールを使用
  use DiscussWeb, :controller
  alias DiscussWeb.Topic
  alias Discuss.Repo

  #[]内の関数の際にplugを実行
  plug DiscussWeb.Plugs.RequireAuth when action in [:new, :create, :edit, :update, :delete]


  def index(conn, _params) do
    IO.inspect(conn.assigns)
    # detaを全て追加
    topics = Repo.all(Topic)
    render conn, "index.html", topics: topics
  end

  def new(conn, _params) do
    changeset = Topic.changeset(%Topic{},%{})

    #new.htmlにchangesetを渡す
    render conn, "new.html", changeset: changeset
  end

  def create(conn, %{"topic" => topic}) do
    # conn.assigns.[:user]
    # conn.assigns.user
    # changeset = Topic.changeset(%Topic{}, topic)

    changeset = conn.assigns.user
      |> Ecto.build_assoc(:topics)
      |> Topic.changeset(topic)

    case Repo.insert(changeset) do
      {:ok, _post} ->
        conn
        #一度だけ全てのユーザにメッセージを表示
        |> put_flash(:info, "Topic Created")
        # index にリダイレクト
        |> redirect(to: Routes.topic_path(conn, :index))

      {:error, changeset} ->
        render conn, "new.html", changeset: changeset
    end
  end

  # iex> params = %{"topic" => "adsf"}
  # iex> %{"topic" => string} = params
  # iex> string
  # "asdf"

  def edit(conn, %{"id" => topic_id}) do
    topic = Repo.get(Topic, topic_id)
    # 何も変わっていないことという変化を得る（第二引数はない。）
    changeset = Topic.changeset(topic)

    render conn, "edit.html", changeset: changeset, topic: topic
  end

  def update(conn, %{"id" => topic_id, "topic" => topic}) do
    old_topic = Repo.get(Topic, topic_id)
    changeset = Topic.changeset(old_topic, topic)
    #changeset = Repo.get(Topic, topic_id) |> Topic.changeset(topic)

    case Repo.update(changeset) do
      {:ok, _topic} ->
        conn
        |> put_flash(:info, "Topic Updated")
        |> redirect(to: Routes.topic_path(conn, :index))
      {:error, changeset} ->
        render conn, "edit.html", changeset: changeset, topic: old_topic
    end
  end

  def delete(conn, %{"id" => topic_id}) do
    Repo.get!(Topic, topic_id) |> Repo.delete!

    conn
    |> put_flash(:info, "Topic Deleted")
    |> redirect(to: Routes.topic_path(conn, :index))
  end
end
