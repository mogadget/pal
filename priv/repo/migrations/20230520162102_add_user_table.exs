defmodule Pal.Repo.Migrations.AddUserTable do
  use Ecto.Migration

  def change do
    create table("users") do
      add :email, :string
      add :first_name, :string
      add :last_name, :string
      add :roles, {:array, :string}, default: []
    end

    create unique_index(:users, [:email])
  end
end
