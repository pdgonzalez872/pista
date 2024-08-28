defmodule Pista.Repo.Migrations.CreateYoutubeChannelLivestreamFetches do
  use Ecto.Migration

  def change do
    create table(:youtube_channel_livestream_fetches, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :response, :map
      add :status, :string

      add :youtube_channel_id,
          references(:youtube_channels, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create index(:youtube_channel_livestream_fetches, [:youtube_channel_id])
  end
end
