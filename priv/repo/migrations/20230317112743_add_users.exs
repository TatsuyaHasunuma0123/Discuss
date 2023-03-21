defmodule Discuss.Repo.Migrations.AddUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :email, :string
      add :provider, :string
      add :token, :string #ユーザの変わりにGithubのアカウントでリクエストを行うためのもの

      # テーブル内の全てのレコードに全てのユーザが作成した更新日時を持つことを確認
      # 記録保持のために作成
      timestamps()
    end
  end
end
