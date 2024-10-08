defmodule Pista.HTMLParsers.TournamentsFipImpl do
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
    data =
      document
      |> Floki.find("article")
      |> Enum.map(fn el ->
        Logger.info("Processing pertinent data")

        [url] =
          el
          |> Floki.find(".event-title a")
          |> Enum.flat_map(fn a_tag -> Floki.attribute(a_tag, "href") end)

        # %{
        #   league: "WPT",
        #   event_name: "Abu Dhabi",
        #   start_date: "2/20/2023",
        #   end_date: "2/26/2023",
        #   city: "Abu Dhabi",
        #   country: "United Arab Emirates",
        #   tournament_grade: "wpt_master",
        #   url: "-"
        # },

        name = el |> Floki.find(".event-title") |> Floki.text()
        dates_text = el |> Floki.find(".date-start-end") |> Floki.text()

        Logger.info("Processing #{name}")

        [start_date, end_date] =
          dates_text
          |> String.replace("From", "")
          |> String.replace("to", "")
          |> String.split()
          |> Enum.map(fn date_text ->
            [d, m, y] =
              date_text
              |> String.split("/", trim: true)
              |> Enum.map(fn s -> String.to_integer(s) end)

            Date.new!(y, m, d)
          end)
          |> case do
            [_start_date, _end_date] = success ->
              success

            error ->
              Logger.error("Error processing #{name}, error: #{inspect(error)}")
              error
          end

        [city, country] =
          el
          |> Floki.find(".event-location")
          |> Floki.text()
          |> String.split(" - ")
          |> case do
            [only_one] -> [only_one, only_one]
            [_city, _country] = success -> success
            ["Croatia" = country, _, _country] -> ["Porec-Parenzo", country]
            other -> [Enum.at(other, 0), Enum.at(other, -1)]
          end

        {tour, level} = derive_tour_and_level(url)

        %{
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
      end)

    {:ok, data}
  end

  defp derive_tour_and_level(url) do
    fip = "FIP"
    rise = "Rise"
    promotion = "Promotion"
    platinum = "Platinum"
    premier = "Premier"
    major = "Major"
    p1 = "P1"
    p2 = "P2"
    star = "Star"
    gold = "Gold"

    cond do
      String.contains?(url, String.downcase(fip)) && String.contains?(url, String.downcase(rise)) ->
        {fip, rise}

      String.contains?(url, String.downcase(fip)) &&
          String.contains?(url, String.downcase(promotion)) ->
        {fip, promotion}

      String.contains?(url, String.downcase(fip)) &&
          String.contains?(url, String.downcase(platinum)) ->
        {fip, platinum}

      String.contains?(url, String.downcase(fip)) &&
          String.contains?(url, String.downcase(star)) ->
        {fip, star}

      String.contains?(url, String.downcase(fip)) &&
          String.contains?(url, String.downcase(gold)) ->
        {fip, gold}

      String.contains?(url, String.downcase(major)) ->
        {premier, major}

      String.contains?(url, String.downcase(p1)) ->
        {premier, p1}

      String.contains?(url, String.downcase(p2)) ->
        {premier, p2}

      true ->
        Logger.error("Unable to derive tournament kind from url: #{url}")
        {"N/A", "N/A"}
    end
  end
end
