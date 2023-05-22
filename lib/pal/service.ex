defmodule Pal.Service do
  import Ecto.Query, warn: false

  alias Pal.Repo
  alias Pal.User
  alias Pal.Account
  alias Pal.Visit
  alias Pal.Transaction

  def create_user(attrs) do
    changeset = User.changeset(%User{}, attrs)

    if changeset.valid? do
      case Repo.insert(changeset) do
        {:ok, user} -> create_user_account(user)
        error -> error
      end
    else
      {:error, changeset}
    end
  end

  def create_user_account(user) do
    accounts =
      Enum.reduce(user.roles, [], fn role, acc ->
        changeset = Account.changeset(%Account{}, %{"user_id" => user.id, "role" => role})

        case Repo.insert(changeset) do
          {:ok, account} -> [account | acc]
          _ -> acc
        end
      end)

    {:ok, {user, accounts}}
  end

  def get_user_account(user, role) do
    query = from(a in Account, where: a.user_id == ^user.id and a.role == ^role)

    Repo.one(query)
  end

  def update_user_account(%Account{id: _id} = account, attrs) do
    account
    |> Pal.Account.changeset(attrs)
    |> Pal.Repo.update()
  end

  def create_visit(account, attrs) do
    if account.role == "member" do
      Visit.changeset(%Visit{}, Map.put(attrs, "account_id", account.id))
      |> Repo.insert()
    else
      {:error, "Cannot request visit for a non-member!"}
    end
  end

  def get_visit(id) do
    Repo.get(Visit, id)
    |> Repo.preload(:account)
  end

  def fulfill_visit(visit_id, pal_account_id) do
    if visit = Repo.get(Visit, visit_id) do
      ## member account
      debit_changeset = get_account_changeset(visit.account_id, :debit, visit.minutes)

      ## pal account
      credit_changeset = get_account_changeset(pal_account_id, :credit, visit.minutes)

      ## transaction
      transaction = %Transaction{
        visit_id: visit_id,
        account_id: pal_account_id
      }

      ## submit transaction
      Ecto.Multi.new()
      |> Ecto.Multi.update(:debit, debit_changeset)
      |> Ecto.Multi.update(:credit, credit_changeset)
      |> Ecto.Multi.insert(:transaction, transaction)
      |> Repo.transaction()
    end
  end

  def add_minutes(%Account{} = account, minutes) do
    update_minutes(:credit, account, minutes)
  end

  def add_minutes(account_id, minutes) do
    if account = Repo.get(Account, account_id) do
      add_minutes(account, minutes)
    end
  end

  defp get_account_changeset(id, :debit, minutes) do
    account = Repo.get(Account, id)
    Account.changeset(account, %{"minutes" => account.minutes - minutes})
  end

  defp get_account_changeset(id, :credit, minutes) do
    account = Repo.get(Account, id)
    Account.changeset(account, %{"minutes" => account.minutes + minutes})
  end

  defp update_minutes(:debit, account, minutes) do
    new_minutes = account.minutes - minutes
    update_user_account(account, %{"minutes" => new_minutes})
  end

  defp update_minutes(:credit, account, minutes) do
    new_minutes = account.minutes + minutes
    update_user_account(account, %{"minutes" => new_minutes})
  end
end
