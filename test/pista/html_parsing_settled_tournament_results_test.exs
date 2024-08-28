defmodule HtmlParsingSettledTournamentResultsTest do
  use ExUnit.Case

  describe "results" do
    @tag :skip
    test "parses results_wpt_boss-barcelona-master-final-2023.html" do
      {:ok, html} =
        [
          File.cwd!(),
          "test",
          "support",
          "fixtures",
          "static_html",
          "settled",
          "results_wpt_boss-barcelona-master-final-2023.html"
        ]
        |> Path.join()
        |> File.read()

      assert {:ok,
              %{
                successes_count: successes_count,
                errors_count: errors_count,
                successes: successes
              } = _result} = Pista.ResultsParsers.WPTImpl.call(%{html_input: html})

      Enum.each(successes, fn s -> IO.inspect(s) end)

      assert successes_count == 150
      assert errors_count == 0
    end
  end
end
