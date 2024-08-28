defmodule Pista.HTMLParsers.TournamentsUPTImpl do
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
         {:ok, _} = success <- find_pertinent_data(document) do
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

  defp find_pertinent_data(document) do
    tournaments = find_upcoming_tournaments(document)
    {:ok, tournaments}
  end

  defp find_upcoming_tournaments(document) do
    document
    |> Floki.find(".torneoDatos")
    |> Enum.map(fn el ->
      Logger.info("Processing pertinent data")

      found =
        el
        |> Floki.find(".botonera")
        |> Floki.find("a")
        |> Enum.find(fn a -> String.contains?(Floki.text(a), "Resultados") end)

      if found do
        [url] =
          found |> Floki.attribute("href")

        Pista.HTMLParsers.parse_tournaments_upt_individual_tournament(%{
          floki_document: el,
          url: "https://app.ultimatepadeltour.com/" <> url
        })
      else
        Logger.info("This was not a tournament")
        :not_a_tournament
      end
    end)
    |> Enum.reject(fn el -> el == :not_a_tournament end)
  end
end
