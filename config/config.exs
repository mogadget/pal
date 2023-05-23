import Config

config :pal, Pal.Repo,
  database: "pal_dev",
  username: "pguser",
  password: "p@55w0rd",
  hostname: "localhost"

config :pal,
  ecto_repos: [Pal.Repo]
