defmodule DiscussWeb.Topic do
  use DiscussWeb, :model

  # phoenixにpostgressの内部で何が予期されるかを伝える
  # Topicsがデータベース内部でどう見えるか
  schema "topics" do
    field :title, :string
    belongs_to :user, DiscussWeb.User
    has_many :comments, DiscussWeb.Comment
  end

  #データの整合性を検証
    # cast  - structとparamsの指定のキーワードを比較して差分だけchangesetにする。
    #validate_required  - nilと空文字の禁止
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title])
    |> validate_required([:title])
  end
end

#Example
  # iex> struct = %DiscussWeb.Topic{}
  # iex> params = %{title: "Great JS"}
  # iex> Discuss.Topic.changeset(struct, params)
  # Ecto.changeset<action: nil, changes: %{title: "Great JS}, errors:[], data: #Discuss.Topic<>, valid?: true"}
  # iex> Discuss.Topic.changeset(struct, %{})
  # Error(タイトル無し)
