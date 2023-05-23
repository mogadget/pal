defmodule Pal.Repo.Migrations.AddAccountTable do
  use Ecto.Migration

  def change do
    create table("accounts") do
      add :role, :string
      add :minutes, :integer
      add :fee, :decimal
      add :user_id, references(:users, on_delete: :delete_all)
      timestamps()
    end
  end
end
