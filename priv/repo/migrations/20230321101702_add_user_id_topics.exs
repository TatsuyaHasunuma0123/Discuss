defmodule Discuss.Repo.Migrations.AddUserIdTopics do
  use Ecto.Migration

  def change do
    # topicsテーブルを作り変える
    alter table(:topics) do
      #新たなカラム「user_id」をusersテーブルと関連付ける（usersテーブルのidをuser_idとする）
      add :user_id, references(:users)
    end
  end
end
