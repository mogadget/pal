defmodule Pal.Transaction do
  use Ecto.Schema
  import Ecto.Changeset

  schema "transactions" do
    timestamps()

    belongs_to(:account, Pal.Account)
    belongs_to(:visit, Pal.Visit)
  end

  def changeset(transaction, attrs) do
    transaction
    |> cast(attrs, [:account_id, :visit_id])
    |> validate_required([:account_id, :visit_id])
  end
end
