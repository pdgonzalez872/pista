defmodule HTMLParsersTournamentsTest do
  use ExUnit.Case

  import Mox

  setup :verify_on_exit!

  describe "can parse all tournaments from FIP tournaments page" do
    test "parses FIP Rise correctly" do
      {:ok, html} =
        [
          File.cwd!(),
          "test",
          "support",
          "fixtures",
          "static_html",
          "tournaments_fip_all_20240120.html"
        ]
        |> Path.join()
        |> File.read()

      assert {:ok, [first | _] = _result} =
               Pista.HTMLParsers.parse_tournaments_fip(%{html_input: html})

      assert %{
               dates_text: "From 03/01/2024 to 07/01/2024",
               event_name: "FIP RISE AUSTRALIAN PADEL OPEN",
               url: "https://www.padelfip.com/events/fip-rise-australian-padel-open-2024/",
               city: "Sydney",
               country: "Australia",
               end_date: ~D[2024-01-07],
               level: "Rise",
               start_date: ~D[2024-01-03],
               tour: "FIP",
               tournament_grade: "fip_rise"
             } = first
    end

    test "parses FIP Rise correctly, a month later than the above..." do
      {:ok, html} =
        [
          File.cwd!(),
          "test",
          "support",
          "fixtures",
          "static_html",
          "tournaments_fip_all_20240224.html"
        ]
        |> Path.join()
        |> File.read()

      assert {:ok, [first | _] = _result} =
               Pista.HTMLParsers.parse_tournaments_fip(%{html_input: html})

      assert %{
               dates_text: "From 03/01/2024 to 07/01/2024",
               event_name: "FIP RISE AUSTRALIAN PADEL OPEN",
               url: "https://www.padelfip.com/events/fip-rise-australian-padel-open-2024/",
               city: "Sydney",
               country: "Australia",
               end_date: ~D[2024-01-07],
               level: "Rise",
               start_date: ~D[2024-01-03],
               tour: "FIP",
               tournament_grade: "fip_rise"
             } = first
    end

    test "parses Premier correctly" do
      {:ok, html} =
        [
          File.cwd!(),
          "test",
          "support",
          "fixtures",
          "static_html",
          "tournaments_all_premier_20240126.html"
        ]
        |> Path.join()
        |> File.read()

      assert {:ok, [first | _] = _result} =
               Pista.HTMLParsers.parse_tournaments_fip(%{html_input: html})

      assert %{
               city: "Riyadh",
               country: "Saudi Arabia",
               dates_text: "From 24/02/2024 to 02/03/2024",
               end_date: ~D[2024-03-02],
               event_name: "RIYADH P1",
               level: "P1",
               start_date: ~D[2024-02-24],
               tour: "Premier",
               tournament_grade: "premier_p1",
               url: "https://www.padelfip.com/events/riyadh-p1-2024/"
             } = first
    end
  end

  describe "A1" do
    test "parses the tournaments page for A1 correctly" do
      {:ok, html} =
        [
          File.cwd!(),
          "test",
          "support",
          "fixtures",
          "static_html",
          "tournaments_a1_all_20240311.html"
        ]
        |> Path.join()
        |> File.read()

      expect(Pista.RequestsMock, :get, 3, fn some_url ->
        expected = [
          "https://www.a1padelglobal.com/torneo.aspx?idTorneo=2313",
          "https://www.a1padelglobal.com/torneo.aspx?idTorneo=2315",
          "https://www.a1padelglobal.com/torneo.aspx?idTorneo=2317"
        ]

        assert some_url in expected

        {:ok, html} =
          [
            File.cwd!(),
            "test",
            "support",
            "fixtures",
            "static_html",
            "tournaments_a1_individual_monaco_master_20240311.html"
          ]
          |> Path.join()
          |> File.read()

        {:ok, %{body: html}}
      end)

      assert {:ok, result} =
               Pista.HTMLParsers.parse_tournaments_a1(%{html_input: html})

      assert %{
               city: "MONACO",
               country: "-",
               dates_text: "15 - 24 Marzo 2024",
               end_date: ~D[2024-03-24],
               event_name: "MONACO",
               level: "Master",
               start_date: ~D[2024-03-15],
               tour: "A1",
               tournament_grade: "a1_master",
               url: "https://www.a1padelglobal.com/torneo.aspx?idTorneo=2315"
             } = Enum.find(result, fn %{city: "MONACO"} = _el -> true end)
    end

    test "parses an individual A1 tournament correctly - puebla open" do
      {:ok, html} =
        [
          File.cwd!(),
          "test",
          "support",
          "fixtures",
          "static_html",
          "tournaments_a1_individual_puebla_open_20240311.html"
        ]
        |> Path.join()
        |> File.read()

      assert %{
               level: "Open",
               url: "https://www.a1padelglobal.com/passed in",
               tour: "A1",
               event_name: "Puebla",
               start_date: ~D[2024-03-01],
               end_date: ~D[2024-03-10],
               tournament_grade: "a1_open",
               city: "Puebla",
               country: "-",
               dates_text: "1 - 10 Marzo 2024"
             } =
               Pista.HTMLParsers.parse_tournaments_a1_individual_tournament(%{
                 html_input: html,
                 url: "passed in"
               })
    end

    test "parses an individual A1 tournament correctly - monaco master" do
      {:ok, html} =
        [
          File.cwd!(),
          "test",
          "support",
          "fixtures",
          "static_html",
          "tournaments_a1_individual_monaco_master_20240311.html"
        ]
        |> Path.join()
        |> File.read()

      assert %{
               level: "Master",
               url: "https://www.a1padelglobal.com/passed in",
               tour: "A1",
               event_name: "MONACO",
               start_date: ~D[2024-03-15],
               end_date: ~D[2024-03-24],
               tournament_grade: "a1_master",
               city: "MONACO",
               country: "-",
               dates_text: "15 - 24 Marzo 2024"
             } =
               Pista.HTMLParsers.parse_tournaments_a1_individual_tournament(%{
                 html_input: html,
                 url: "passed in"
               })
    end

    @tag :this
    test "parses the calendar tournaments page for A1 correctly" do
      {:ok, html} =
        [
          File.cwd!(),
          "test",
          "support",
          "fixtures",
          "static_html",
          "tournaments_a1_calendar_20240924.html"
        ]
        |> Path.join()
        |> File.read()

      assert {:ok, result} =
               Pista.HTMLParsers.parse_tournaments_calendar_a1(%{html_input: html})

      assert %{
               city: "MONACO",
               country: "-",
               dates_text: "15 - 24 Marzo 2024",
               end_date: ~D[2024-03-24],
               event_name: "MONACO",
               level: "Master",
               start_date: ~D[2024-03-15],
               tour: "A1",
               tournament_grade: "a1_master",
               url: "https://www.a1padelglobal.com/torneo.aspx?idTorneo=2315"
             } = Enum.find(result, fn %{city: "MONACO"} = _el -> true end)
    end
  end

  describe "UPT" do
    test "parses the tournaments page for UPT correctly" do
      {:ok, html} =
        [
          File.cwd!(),
          "test",
          "support",
          "fixtures",
          "static_html",
          "tournaments_upt_all_20240311.html"
        ]
        |> Path.join()
        |> File.read()

      assert {:ok, [first, last]} =
               Pista.HTMLParsers.parse_tournaments_upt(%{html_input: html})

      assert %{
               city: "LEGANéS OPEN",
               country: "Spain",
               dates_text: "Del 08/03/2024 AL 16/03/2024",
               end_date: ~D[2024-03-16],
               event_name: "LEGANéS OPEN",
               level: "Open",
               start_date: ~D[2024-03-08],
               tour: "UPT",
               tournament_grade: "upt_open",
               url: "https://app.ultimatepadeltour.com/torneosHYR.aspx?idTorneo=2271"
             } = first

      assert %{
               city: "A CORUÑA OPEN",
               country: "Spain",
               dates_text: "Del 10/02/2024 AL 18/02/2024",
               end_date: ~D[2024-02-18],
               event_name: "A CORUÑA OPEN",
               level: "Open",
               start_date: ~D[2024-02-10],
               tour: "UPT",
               tournament_grade: "upt_open",
               url: "https://app.ultimatepadeltour.com/torneosHYR.aspx?idTorneo=2270"
             } = last
    end
  end
end
