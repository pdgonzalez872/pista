defmodule HTMLParsersLiveTest do
  use ExUnit.Case

  describe "RedBullTv Livestream check" do
    test "returns true if a tournament is livestreaming at the moment on RedBullTv" do
      {:ok, html} =
        [
          File.cwd!(),
          "test",
          "support",
          "fixtures",
          "static_html",
          "redbull_tv_live.html"
        ]
        |> Path.join()
        |> File.read()

      assert {:ok, %{results: true}} =
               Pista.HTMLParsers.parse_live_redbull_tv(%{html_input: html})

      {:ok, html} =
        [
          File.cwd!(),
          "test",
          "support",
          "fixtures",
          "static_html",
          "redbulltv_not_live.html"
        ]
        |> Path.join()
        |> File.read()

      assert {:ok, %{results: false}} =
               Pista.HTMLParsers.parse_live_redbull_tv(%{html_input: html})
    end
  end
end
