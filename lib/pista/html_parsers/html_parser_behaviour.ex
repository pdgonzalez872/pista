defmodule Pista.HTMLParsers.HTMLParserBehaviour do
  @callback call(map()) :: {:ok, map()} | {:error, map()}
end
