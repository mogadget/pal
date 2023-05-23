defmodule Pal.Helpers do
  def deduct_percentage(minutes, pctg \\ 0.15) do
    overhead = minutes * pctg

    Float.ceil(minutes - overhead, 2)
    |> Decimal.from_float()
    |> Decimal.new()
  end

  def subtract_minutes(min1, min2) do
    Decimal.sub(min1, min2)
    |> Decimal.to_float()
    |> Float.ceil(2)
  end

  def add_minutes(min1, min2), do: Decimal.add(min1, min2)
end
