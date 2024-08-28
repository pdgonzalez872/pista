defmodule Pista.HTMLParsers.TournamentsA1Impl do
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
    upcoming_tournaments = find_upcoming_tournaments(document)
    past_tournaments = find_past_tournaments(document)
    all = upcoming_tournaments ++ past_tournaments

    {:ok, List.flatten(all)}
  end

  defp find_upcoming_tournaments(document) do
    document
    |> Floki.find(".tour")
    |> Floki.find(".ptarjeta")
    |> Enum.map(fn el ->
      Logger.info("Processing pertinent data")

      [url] = el |> Floki.find(".tlugar") |> Floki.find("a") |> Floki.attribute("href")

      case Pista.Requests.get("https://www.a1padelglobal.com/#{url}") do
        {:ok, %{body: html}} = _result ->
          Pista.HTMLParsers.parse_tournaments_a1_individual_tournament(%{
            html_input: html,
            url: url
          })

        error ->
          Logger.error("Error getting #{url}")
          error
      end
    end)
  end

  defp find_past_tournaments(document) do
    document
    |> Floki.find(".torneos-pasados-bg")
    |> Enum.map(fn el ->
      el
      |> Floki.find(".card-item")
      |> Floki.attribute("href")
      |> Enum.map(fn url ->
        case Pista.Requests.get("https://www.a1padelglobal.com/#{url}") do
          {:ok, %{body: html}} = _result ->
            Pista.HTMLParsers.parse_tournaments_a1_individual_tournament(%{
              html_input: html,
              url: url
            })

          error ->
            Logger.error("Error getting #{url}")
            error
        end
      end)
    end)
  end
end
