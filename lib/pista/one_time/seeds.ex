defmodule Pista.OneTime.SeedsYoutubeLivestreams do
  def call() do
    # Add as you need
    [
      "@courtinsider",
      "@padelfip",
      "@PremierPadelTV",
      "@propadelleague",
      "@RaquetenaCanela",
      "@A1PADEL"
    ]
    |> Enum.each(fn name ->
      Pista.Livestreams.create_youtube_channel(%{name: name})
    end)
  end
end
