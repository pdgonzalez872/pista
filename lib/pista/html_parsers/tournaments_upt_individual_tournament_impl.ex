defmodule Pista.HTMLParsers.TournamentsUPTIndividualTournamentImpl do
  @moduledoc """
  This one is interesting because we will need to go into each of the pages to
  get more info.
  """
  require Logger

  @behaviour Pista.HTMLParsers.HTMLParserBehaviour

  @impl true
  def call(%{floki_document: document, url: url}) do
    action = "#{__MODULE__} -> processing html"
    Logger.info("Start #{action} for #{url}")

    with {:ok, tournament_success} <- find_pertinent_data(document, url) do
      Logger.info("Success #{action}")

      tournament_success
    else
      error ->
        Logger.error("Error #{action}: #{inspect(error)}")

        error
    end
  end

  defp find_pertinent_data(el, url) do
    Logger.info("Processing pertinent data")

    name =
      el
      |> Floki.find("#ContentPlaceHolder1_lbNombreTorneo")
      |> Floki.text()
      |> String.split(": ")
      |> Enum.at(-1)

    Logger.info("Processing #{name}")

    dates_text = el |> Floki.find("#ContentPlaceHolder1_lbFechasTorneo") |> Floki.text()

    [start_date, end_date] =
      dates_text
      |> String.downcase()
      |> String.replace("del ", "|")
      |> String.replace("al", "|")
      |> String.replace(" ", "")
      |> String.split("|", trim: true)
      |> case do
        [_start_date_text, _end_day_text] = text ->
          Enum.map(text, fn t ->
            [day, month, year] =
              t |> String.split("/") |> Enum.map(fn d -> String.to_integer(d) end)

            Date.new!(year, month, day)
          end)

        error ->
          Logger.error("Error parsing dates for #{name}")
          error
      end

    [city, country] = [name, "Spain"]

    {tour, level} = derive_tour_and_level(el)

    data = %{
      url: url,
      event_name: name,
      city: city,
      country: country,
      dates_text: dates_text,
      tour: tour,
      level: level,
      start_date: start_date,
      end_date: end_date,
      tournament_grade: "#{String.downcase(tour)}_#{String.downcase(level)}"
    }

    {:ok, data}
  end

  defp derive_tour_and_level(_el) do
    {"UPT", "Open"}
  end
end
