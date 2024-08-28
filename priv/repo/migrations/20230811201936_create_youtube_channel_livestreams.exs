defmodule Pista.Repo.Migrations.CreateYoutubeChannelLivestreams do
  use Ecto.Migration

  def change do
    create table(:youtube_channel_livestreams, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :url, :string
      add :embed_url, :string
      add :video_id, :string
      add :status, :string

      add :youtube_channel_id,
          references(:youtube_channels, on_delete: :nothing, type: :binary_id)

      add :youtube_channel_livestream_fetches_id,
          references(:youtube_channel_livestream_fetches, on_delete: :nothing, type: :binary_id)

      add :stale_at, :naive_datetime

      timestamps()
    end

    create index(:youtube_channel_livestreams, [:youtube_channel_id])
    create index(:youtube_channel_livestreams, [:youtube_channel_livestream_fetches_id])
  end
end
