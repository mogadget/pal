defmodule Pal.Repo.Migrations.AddVisitTable do
  use Ecto.Migration

  def change do
    create table("visits") do
      add :date, :naive_datetime
      add :minutes, :integer
      add :tasks, {:array, :string}
      add :account_id, references(:accounts, on_delete: :delete_all)
      timestamps()
    end
  end
end
