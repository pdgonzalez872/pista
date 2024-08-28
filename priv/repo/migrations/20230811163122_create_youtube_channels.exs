defmodule Pista.Repo.Migrations.CreateYoutubeChannels do
  use Ecto.Migration

  def change do
    create table(:youtube_channels, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :status, :string
      add :third_party_channel_id, :string
      add :cadence_seconds, :integer
      add :last_fetched, :naive_datetime, default: fragment("CURRENT_TIMESTAMP")
      add :should_hydrate, :boolean, default: true, null: false

      timestamps()
    end
  end
end
