defmodule Pista.Repo.Migrations.AddKindToYoutubeChannel do
  use Ecto.Migration

  def change do
    alter table(:youtube_channel_livestreams) do
      add(:kind, :string)
    end

    alter table(:youtube_channels) do
      add(:kind, :string)
    end
  end
end
