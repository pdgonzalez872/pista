defmodule Pista.Livestreams.YoutubeChannelLivestreamFetches do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "youtube_channel_livestream_fetches" do
    field :status, :string
    field :response, :map
    field :youtube_channel_id, :binary_id

    timestamps()
  end

  @doc false
  def changeset(youtube_channel_livestream_fetches, attrs) do
    youtube_channel_livestream_fetches
    |> cast(attrs, [:response, :status])
    |> validate_required([:response, :status])
  end
end
