# Pal

## Installation

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

member_pal = %{
  "email" => Faker.Internet.email(),
  "first_name" => Faker.Name.first_name(),
  "last_name" => Faker.Name.last_name(),
  "roles" => ["member", "pal"]
}

# create both a member and pal account for a single user

{:ok, {%User{} = user, accounts}} = Pal.Service.create_user(member_pal)

# get user's account
pal = Pal.Service.get_user_account(user, "pal")
mem = Pal.Service.get_user_account(user, "member")


# create user's member account

member_attrs = %{
  "email" => Faker.Internet.email(),
  "first_name" => Faker.Name.first_name(),
  "last_name" => Faker.Name.last_name(),
  "roles" => ["member"]
}

{:ok, {%User{} = user, [member|_]}} = Pal.Service.create_user(member_attrs)


# add minutes to member account
{:ok, account} = Pal.Service.add_minutes(member, 150)
```

#### This app is mostly in happy path and some validations are not in place such as

- it doesn't validate if a pal is the same user as member
- it doesn't validate for visit that already been fulfilled

#### These are the technology and design considerations:

- This app uses Ecto for ORM, Postgres for database, and Faker to test data.
- Does not used a separate database for test and therefore it deletes all created records for every test run
- Uses Ecto.Multi to wrap the fulfill visit call as trasaction
