defmodule Pal.Visit do
  use Ecto.Schema
  import Ecto.Changeset

  schema "visits" do
    field(:date, :utc_datetime)
    field(:minutes, :integer)
    field(:tasks, {:array, :string})
    timestamps()

    belongs_to(:account, Pal.Account)
  end

  def changeset(visits, attrs) do
    visits
    |> cast(attrs, [:account_id, :date, :minutes, :tasks])
    |> validate_required([:account_id, :date, :tasks, :minutes])
    |> validate_number(:minutes, greater_than: 0)
  end
end
