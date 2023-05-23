defmodule Pal.Test do
  use Pal.DataCase

  alias Pal.Service
  alias Pal.User
  alias Pal.Account
  alias Pal.Transaction
  alias Pal.Visit
  alias Pal.Factory
  alias Pal.Helpers

  setup_all context do
    ## clear the tables
    Repo.delete_all(Transaction)
    Repo.delete_all(Visit)
    Repo.delete_all(Account)
    Repo.delete_all(User)

    pal_attrs = Factory.string_params_for(:user_pal_attrs)
    mem_attrs = Factory.string_params_for(:user_member_attrs)
    {:ok, {%User{} = user, [pal_account | _]}} = Service.create_user(pal_attrs)
    {:ok, {%User{} = user, [mem_account | _]}} = Service.create_user(mem_attrs)

    %{member: mem_account, pal: pal_account}
  end

  describe "create/1" do
    test "it create a user and an accounts for member and pal" do
      params = Factory.string_params_for(:user_both_attrs)

      assert {:ok, {%User{} = user, accounts}} = Service.create_user(params)

      user_record = Repo.get(User, user.id)
      assert user == user_record
      assert length(accounts) == 2
    end

    test "it create a 30 minutes member visit request" do
      attrs = Factory.string_params_for(:user_member_attrs)

      assert {:ok, {%User{} = user, [member | _]}} = Service.create_user(attrs)
      assert {:ok, account} = Service.add_minutes(member, 100)

      assert {:ok, visit} =
               Service.create_visit(member.id, %{
                 "minutes" => 30,
                 "date" => Faker.DateTime.forward(10),
                 "tasks" => ["cooking", "water the plants"]
               })

      assert visit.minutes == 30
    end

    test "it fulfill a visit request", ctx do
      minutes_requested = 63
      assert {:ok, account} = Service.add_minutes(ctx.member, 150)

      assert {:ok, visit} =
               Service.create_visit(ctx.member.id, %{
                 "minutes" => minutes_requested,
                 "date" => Faker.DateTime.forward(10),
                 "tasks" => ["walk the doo"]
               })

      assert {:ok, action} = Service.fulfill_visit(visit.id, ctx.pal.id)
      pal_account = Repo.get(Account, ctx.pal.id)
      assert pal_account.minutes == Helpers.deduct_percentage(minutes_requested)
    end

    test "it returns an error tuple when user can't be created" do
      empty_attrs = %{}

      assert {:error, %Changeset{valid?: false}} = Service.create_user(empty_attrs)
    end
  end
end
