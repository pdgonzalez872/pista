defmodule Pista.HTMLParsers.TournamentsA1CalendarImpl do
  @moduledoc """
  This one is interesting because we will need to go into each of the pages to
  get more info.
  """
  require Logger

  @behaviour Pista.HTMLParsers.HTMLParserBehaviour

  @impl true
  def call(%{html_input: html_input}) do
    action = "#{__MODULE__} -> processing html"
    Logger.info("Start #{action}")

    with {:ok, document} <- parse_html(html_input),
         {:ok, _} = success <- find_tournaments(document) do
      Logger.info("Success #{action}")

      success
    else
      error ->
        Logger.error("Error #{action}: #{inspect(error)}")

        error
    end
  end

  defp parse_html(html_input) do
    Floki.parse_document(html_input)
  end

  defp find_tournaments(document) do
    tournaments =
      document
      |> Floki.find(".calendar-item")
      |> Enum.map(fn el ->
        Logger.info("Processing pertinent data")
        event_name = el |> Floki.find(".location") |> Floki.text()

        [country] =
          el
          |> Floki.find("img")
          |> Floki.attribute("alt")

        %{event_name: event_name, country: country}
      end)
      |> Enum.uniq()

    {:ok, tournaments}
  end
end
