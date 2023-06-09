defmodule Pal.Account do
  use Ecto.Schema
  import Ecto.Changeset

  schema "accounts" do
    field(:role, :string)
    field(:minutes, :decimal, default: 0.0)
    timestamps()

    belongs_to(:user, Pal.User)
  end

  def changeset(account, attrs) do
    account
    |> cast(attrs, [:user_id, :role, :minutes])
    |> validate_required([:user_id, :role])
    |> validate_number(:minutes, greater_than_or_equal_to: 0, message: "not enough minutes")
  end
end
