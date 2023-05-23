## Pal

This sample demo using Elixir touches pattern matching, computation with decimals and the use of ACID transactions in Ecto

#### Installation

- git clone https://github.com/mogadget/pal.git
- `cd pal`
- `mix deps.get`

Then update your database in config/dev.exs with the proper postgres creditial, and run:

- `mix ecto.create`

To run test

- `mix test`

You can also manually run app API as

- `iex -S mix`

```
alias Pal.User
alias Pal.Account
alias Pal.Visit
alias Pal.Transaction
alias Pal.Service

# create both a member and pal account for a single user
member_pal_attrs = %{
  "email" => Faker.Internet.email(),
  "first_name" => Faker.Name.first_name(),
  "last_name" => Faker.Name.last_name(),
  "roles" => ["member", "pal"]
}

{:ok, {%User{} = user, accounts}} = Pal.Service.create_user(member_pal_attrs)

# get user's account
pal = Pal.Service.get_user_account(user, "pal")
member = Pal.Service.get_user_account(user, "member")

# create a pal account
pal_attrs = %{
  "email" => Faker.Internet.email(),
  "first_name" => Faker.Name.first_name(),
  "last_name" => Faker.Name.last_name(),
  "roles" => ["pal"]
}

{:ok, {%User{} = user, [pal|_]}} = Pal.Service.create_user(pal_attrs)

# add minutes to member account
{:ok, account} = Pal.Service.add_minutes(member, 150)

# create a 30 minutes visit request
visit_attrs = %{
    "minutes" => 30,
    "date" => Faker.DateTime.forward(10),
    "tasks" => ["walk the dog", "bring out the trash"]
}

{:ok, visit} = Pal.Service.create_visit(member.id, visit_attrs)

# pal fulfill a visit
{:ok, filled} = Pal.Service.fulfill_visit(visit.id, pal.id)

# get account balances
pal_account = Pal.Repo.get(Pal.Account, pal.id)

member_account = Pal.Repo.get(Pal.Account, member.id)
```

#### This app is mostly in happy path and some validations are not in place such as

- it doesn't validate if a pal is the same user as member
- it doesn't validate for visit that already been fulfilled

#### These are the technology and design considerations:

- This app uses Ecto for ORM, Postgres for database, and Faker for fake test data.
- Does not have a separate database for test and therefore it deletes all created records for every `mix test` run
- Uses Ecto.Multi to wrap the fulfill_visit call as ACID trasaction
