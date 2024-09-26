defmodule Pista.HTMLParsers.LiveYoutubeImpl do
  @moduledoc """
  This one in particular goes to YouTube and parses html to get videos that are
  live.

  I went this route because YouTube didn't give me enough credits to use the
  search api enough to have a good user experience and answer the question:
  "What's live now?"
  """

  require Logger

  @behaviour Pista.HTMLParsers.HTMLParserBehaviour

  @impl true
  def call(%{html_input: html_input, channel: c}) do
    Logger.info("Processing #{c}")

    html_input
    |> Floki.parse_document!()
    |> Floki.find("script")
    |> Enum.filter(fn {"script", _nonce_stuff, [goodies]} ->
      String.contains?(goodies, ~S({"text":" watching"}))
    end)
    |> log()
    |> Enum.map(fn {"script", _nonce_stuff, [goodies]} -> goodies end)
    |> Enum.map(fn el -> handle_element(el, c) end)
    |> List.flatten()
    |> Enum.map(fn r -> %{video_id: r, channel_name: c} end)
  end

  defp handle_element(el, c) do
    el
    |> String.split(~S(url":"https://i.ytimg.com/vi/), trim: true)
    |> Enum.filter(fn el ->
      String.contains?(el, "/hqdefault.jpg?") && String.contains?(el, ~S({"text":" watching"})) &&
        String.contains?(el, c)
    end)
    |> log()
    |> Enum.map(fn el ->
      el
      |> String.split("/hqdefault.jpg?")
      |> Enum.at(0)
    end)
    |> List.flatten()
    |> Enum.filter(fn el -> String.length(el) < 20 end)
    |> Enum.uniq()
  end

  def log(el) when is_list(el) do
    Logger.info("Got #{Enum.count(el)} sub-strings")
    el
  end
end
