defmodule Pal.Repo.Migrations.AddTransactionTable do
  use Ecto.Migration

  def change do
    create table("transactions") do
      add :account_id, references(:accounts, on_delete: :nothing)
      add :visit_id, references(:visits, on_delete: :nothing)
      timestamps()
    end
  end
end
