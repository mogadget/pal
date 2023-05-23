defmodule Pal.Repo.Migrations.AlterMinutesToDecimal do
  use Ecto.Migration

  def change do
    alter table(:accounts) do
      remove_if_exists :fee, :decimal
      modify :minutes, :decimal
    end
  end
end
