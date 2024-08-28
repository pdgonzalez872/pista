defmodule Pista.HTMLParsers.LiveRedBullTvImpl do
  @moduledoc """
  Finds certain words in html and determines if there is a livestream going on
  or not.
  """
  require Logger

  @behaviour Pista.HTMLParsers.HTMLParserBehaviour

  @impl true
  def call(%{html_input: html_input}) do
    action = "processing html for RedBullTv"
    Logger.info("Start #{action}")

    with {:ok, document} <- Floki.parse_document(html_input),
         result <- document |> Floki.text() |> String.contains?("LIVE NOW") do
      Logger.info("Success #{action}")

      {:ok, %{results: result}}
    else
      error ->
        Logger.error("Error #{action}: #{inspect(error)}")

        error
    end
  end
end
