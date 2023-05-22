defmodule Pal.Factory do
  use ExMachina.Ecto, repo: Pal.Repo
  alias Pal.Schemas.User

  def user_both_attrs_factory do
    %{
      "email" => Faker.Internet.email(),
      "first_name" => Faker.Name.first_name(),
      "last_name" => Faker.Name.last_name(),
      "roles" => ["member", "pal"]
    }
  end

  def user_member_attrs_factory do
    %{
      "email" => Faker.Internet.email(),
      "first_name" => Faker.Name.first_name(),
      "last_name" => Faker.Name.last_name(),
      "roles" => ["member"]
    }
  end

  def user_pal_attrs_factory do
    %{
      "email" => Faker.Internet.email(),
      "first_name" => Faker.Name.first_name(),
      "last_name" => Faker.Name.last_name(),
      "roles" => ["pal"]
    }
  end
end
