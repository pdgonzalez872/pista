defmodule Pista.LivestreamsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Pista.Livestreams` context.
  """

  @doc """
  Generate a youtube_channel.
  """
  def youtube_channel_fixture(attrs \\ %{}) do
    {:ok, youtube_channel} =
      attrs
      |> Enum.into(%{
        name: "some name",
        status: "some status",
        third_party_channel_id: "some third_party_channel_id",
        cadence_seconds: 42,
        last_fetched: ~N[2023-08-10 16:31:00],
        should_hydrate: true
      })
      |> Pista.Livestreams.create_youtube_channel()

    youtube_channel
  end

  @doc """
  Generate a youtube_channel_livestream_fetches.
  """
  def youtube_channel_livestream_fetches_fixture(attrs \\ %{}) do
    {:ok, youtube_channel_livestream_fetches} =
      attrs
      |> Enum.into(%{
        status: "some status",
        response: %{}
      })
      |> Pista.Livestreams.create_youtube_channel_livestream_fetches()

    youtube_channel_livestream_fetches
  end

  @doc """
  Generate a youtube_channel_livestream.
  """
  def youtube_channel_livestream_fixture(attrs \\ %{}) do
    {:ok, youtube_channel_livestream} =
      attrs
      |> Enum.into(%{
        status: "some status",
        url: "some url",
        embed_url: "some embed_url",
        video_id: "some video_id"
      })
      |> Pista.Livestreams.create_youtube_channel_livestream()

    youtube_channel_livestream
  end
end
