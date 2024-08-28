defmodule Pista.Livestreams.YoutubeChannel do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "youtube_channels" do
    field :name, :string
    field :status, :string, default: "active"
    field :third_party_channel_id, :string
    field :cadence_seconds, :integer, default: 86400
    field :last_fetched, :naive_datetime
    field :should_hydrate, :boolean, default: true
    field :kind, :string
    has_many :youtube_channel_livestreams, Pista.Livestreams.YoutubeChannelLivestream

    timestamps()
  end

  @required [:name]
  @optional [
    :cadence_seconds,
    :last_fetched,
    :should_hydrate,
    :kind,
    :status,
    :third_party_channel_id
  ]
  @all @required ++ @optional

  @doc false
  def changeset(youtube_channel, attrs) do
    youtube_channel
    |> cast(attrs, @all)
    |> validate_required(@required)
  end
end
