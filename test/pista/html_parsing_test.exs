defmodule HtmlParsingTest do
  use ExUnit.Case

  # # How do you know someone is a winner?
  # - relational results -> 6/7 7/6 7/6 -> means the first team won in two sets
  # - complete results have the winner around a strong tag -> this is to be used when we don't have complete results
  #
  #
  # examples A1:
  # - https://www.a1padelglobal.com/torneoPartidos.aspx?idTorneo=2238
  # - https://www.a1padelglobal.com/torneoPartidos.aspx?idTorneo=2261
  describe "results" do
    @tag :skip
    test "parses tournament page correctly - A1 Queretaro 2022" do
      {:ok, html} =
        [File.cwd!(), "test", "support", "fixtures", "static_html", "a1_queretaro_2022.html"]
        |> Path.join()
        |> File.read()

      {:ok, document} = Floki.parse_document(html)

      Floki.find(document, ".table tr") |> Enum.map(fn tr -> dbg(Floki.text(tr)) end)
    end

    @tag :skip
    test "parses tournament page correctly - A1 Cape Town 2023 incomplete" do
      {:ok, html} =
        [
          File.cwd!(),
          "test",
          "support",
          "fixtures",
          "static_html",
          "results_a1_cape_town_2023_incomplete.html"
        ]
        |> Path.join()
        |> File.read()

      {:ok, document} = Floki.parse_document(html)

      Floki.find(document, ".table tr") |> Enum.map(fn tr -> dbg(Floki.text(tr)) end)
    end

    test "parses results_wpt_brussels_2023_002.html" do
      {:ok, html} =
        [
          File.cwd!(),
          "test",
          "support",
          "fixtures",
          "static_html",
          "results_wpt_brussels_2023_002.html"
        ]
        |> Path.join()
        |> File.read()

      assert {:ok,
              %{
                successes_count: successes_count,
                errors_count: errors_count,
                successes: _successes
              } = _result} = Pista.ResultsParsers.WPTImpl.call(%{html_input: html})

      assert successes_count == 118
      assert errors_count == 0
    end

    # Not ready
    @tag :skip
    test "parses results_wpt_brussels_2023_003.html" do
      {:ok, html} =
        [
          File.cwd!(),
          "test",
          "fixtures",
          "support",
          "static_html",
          "results_wpt_brussels_2023_003.html"
        ]
        |> Path.join()
        |> File.read()

      assert {:ok,
              %{
                successes_count: successes_count,
                errors_count: errors_count,
                successes: _successes
              } = _result} = Pista.ResultsParsers.WPTImpl.call(%{html_input: html})

      assert successes_count == 118
      assert errors_count == 0
    end

    @tag :skip
    test "parses results_wpt_granada_2023_001.html" do
      {:ok, html} =
        [
          File.cwd!(),
          "test",
          "support",
          "fixtures",
          "static_html",
          "results_wpt_granada_2023_001.html"
        ]
        |> Path.join()
        |> File.read()

      assert {:ok,
              %{
                successes_count: successes_count,
                errors_count: errors_count,
                successes: _successes
              } = _result} = Pista.ResultsParsers.WPTImpl.call(%{html_input: html})

      assert successes_count == 150
      assert errors_count == 0
    end

    @tag :this
    test "parses results_wpt_mexico_2023_001.html" do
      {:ok, html} =
        [
          File.cwd!(),
          "test",
          "support",
          "fixtures",
          "static_html",
          "results_wpt_mexico_2023_001.html"
        ]
        |> Path.join()
        |> File.read()

      assert {:ok,
              %{
                successes_count: successes_count,
                errors_count: errors_count,
                successes: _successes
              } = _result} = Pista.ResultsParsers.WPTImpl.call(%{html_input: html})

      assert successes_count == 150
      assert errors_count == 0
    end
  end
end
