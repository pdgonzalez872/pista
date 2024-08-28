defmodule Pista.RequestsBehaviour do
  @callback get(binary()) :: {:ok, map()}
  @callback post_fip(binary()) :: {:ok, map()}
end
