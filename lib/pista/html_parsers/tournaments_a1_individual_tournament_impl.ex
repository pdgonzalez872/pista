defmodule Pista.HTMLParsers.TournamentsA1IndividualTournamentImpl do
  @moduledoc """
  This one is interesting because we will need to go into each of the pages to
  get more info.
  """
  require Logger

  @behaviour Pista.HTMLParsers.HTMLParserBehaviour

  @impl true
  def call(%{html_input: html_input, url: url}) do
    action = "#{__MODULE__} -> processing html"
    Logger.info("Start #{action}")

    with {:ok, document} <- parse_html(html_input),
         {:ok, tournament_success} <- find_pertinent_data(document, url) do
      Logger.info("Success #{action}")

      tournament_success
    else
      error ->
        Logger.error("Error #{action}: #{inspect(error)}")

        error
    end
  end

  defp parse_html(html_input) do
    Floki.parse_document(html_input)
  end

  defp find_pertinent_data(el, url) do
    Logger.info("Processing pertinent data")
    name = el |> Floki.find(".master__location") |> Floki.text()

    dates_text = el |> Floki.find(".master__date") |> Floki.text()

    Logger.info("Processing #{name}")

    [start_date, end_date] =
      dates_text
      |> String.replace("-", " ")
      |> String.split(" ", trim: true)
      |> case do
        [day_start, day_end, month_text, year_text] ->
          month =
            Map.get(
              %{
                "Enero" => 1,
                "Febrero" => 2,
                "Marzo" => 3,
                "Abril" => 4,
                "Mayo" => 5,
                "Junio" => 6,
                "Julio" => 7,
                "Agosto" => 8,
                "Septiembre" => 9,
                "Octubre" => 10,
                "Noviembre" => 11,
                "Deciembre" => 12
              },
              month_text
            )

          # If the start date is higher than the end date it means that it
          # starts in the previous month
          # Could fetch the correct date here, but I think this will be brittle
          [
            Date.new!(String.to_integer(year_text), month, String.to_integer(day_start)),
            Date.new!(String.to_integer(year_text), month, String.to_integer(day_end))
          ]
      end
      |> case do
        [_start_date, _end_date] = success ->
          success

        error ->
          Logger.error("Error processing #{name}, error: #{inspect(error)}")
          error
      end

    [city, country] = [name, "-"]

    {tour, level} = derive_tour_and_level(el)

    data = %{
      url: "https://www.a1padelglobal.com/" <> url,
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

  defp derive_tour_and_level(el) do
    level = el |> Floki.find(".master__title2") |> Floki.text()
    {"A1", level}
  end
end
