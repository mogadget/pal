defmodule Pal.Application do
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      Pal.Repo
    ]

    opts = [strategy: :one_for_one, name: Pal.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
