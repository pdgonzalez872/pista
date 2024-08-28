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
    html_input
    |> Floki.parse_document!()
    |> Floki.find("script")
    |> Enum.filter(fn {"script", _nonce_stuff, [goodies]} ->
      String.contains?(goodies, "hqdefault_live.jpg?")
    end)
    |> Enum.map(fn {"script", _nonce_stuff, [goodies]} -> goodies end)
    |> Enum.map(fn el -> handle_element(el) end)
    |> List.flatten()
    |> Enum.map(fn r -> %{video_id: r, channel_name: c} end)
  end

  defp handle_element(el) do
    el
    |> String.split(~S(url":"https://i.ytimg.com/vi/), trim: true)
    |> Enum.filter(fn el -> String.contains?(el, "/hqdefault_live.jpg?") end)
    |> Enum.map(fn el -> String.split(el, "/hqdefault_live.jpg?") end)
    |> List.flatten()
    |> Enum.filter(fn el -> String.length(el) < 20 end)
    |> Enum.uniq()
  end
end
