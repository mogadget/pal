defmodule Pal.DataCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      alias Ecto.Changeset
      import Pal.DataCase
      alias Pal.{Factory, Repo}
    end
  end
end
