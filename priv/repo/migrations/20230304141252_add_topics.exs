# mix ecto.gen.migration add_topics で生成
# コードを追加して
# mix ecto migrate
defmodule Discuss.Repo.Migrations.AddTopics do
  use Ecto.Migration

  def change do
    #topicsと呼ばれる新しいテーブルを作成
    create table(:topics) do
      #title：カラム（文字列）
      add :title, :string
    end
  end
end
