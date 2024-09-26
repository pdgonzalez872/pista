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

  describe "YouTube Livestream check" do
    test "returns a data structure for youtube channel if it is livestreaming" do
      {:ok, html} = read_file("youtube_live.html")

      assert [%{video_id: "mH-s2G8KIpc", channel_name: "@A1PADEL"}] =
               Pista.HTMLParsers.parse_live_youtube_channel(%{
                 html_input: html,
                 channel: "@A1PADEL"
               })
    end

    test "returns a data structure if a channel is live and has multiple live videos" do
      {:ok, html} = read_file("youtube_live_multiple.html")

      assert [_, _] =
               _only_two =
               Pista.HTMLParsers.parse_live_youtube_channel(%{
                 html_input: html,
                 channel: "@RelaxationChannel"
               })
    end

    test "does not return anything if the returns a data structure for youtube channel that if it is livestreaming" do
      {:ok, html} = read_file("youtube_not_live.html")

      assert [] =
               Pista.HTMLParsers.parse_live_youtube_channel(%{
                 html_input: html,
                 channel: "@Premier"
               })
    end
  end

  defp read_file(file_name) do
    [
      File.cwd!(),
      "test",
      "support",
      "fixtures",
      "static_html",
      file_name
    ]
    |> Path.join()
    |> File.read()
  end
end
