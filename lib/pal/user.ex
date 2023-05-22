defmodule Pal.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field(:email, :string)
    field(:roles, {:array, :string})
    field(:first_name, :string)
    field(:last_name, :string)
    timestamps()

    has_many(:accounts, Pal.Account)
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :first_name, :last_name, :roles])
    |> validate_required([:email, :first_name, :last_name, :roles])
    |> validate_subset(:roles, ["member", "pal"])
    |> validate_email()
    |> validate_unique_email()
  end

  defp validate_email(changeset) do
    changeset
    |> validate_required([:email])
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/, message: "must have the @ sign and no spaces")
    |> validate_length(:email, max: 160)
  end

  defp validate_unique_email(changeset) do
    unique_constraint(changeset, :email)
  end
end
