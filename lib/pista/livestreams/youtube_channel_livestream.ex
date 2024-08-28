defmodule Pista.Livestreams.YoutubeChannelLivestream do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "youtube_channel_livestreams" do
    field :status, :string, default: "inactive"
    field :url, :string
    field :embed_url, :string
    field :video_id, :string
    field :youtube_channel_livestream_fetches_id, :binary_id
    field :stale_at, :naive_datetime
    field :kind, :string, default: "padel"
    belongs_to :youtube_channel, Pista.Livestreams.YoutubeChannel

    timestamps()
  end

  @required [:status]
  @optional [:url, :embed_url, :stale_at, :kind, :video_id, :youtube_channel_id]

  @all @required ++ @optional

  @doc false
  def changeset(youtube_channel_livestream, attrs) do
    youtube_channel_livestream
    |> cast(attrs, @all)
    |> validate_required(@required)
    |> case do
      %{valid?: true, changes: %{video_id: video_id} = changes} = changeset ->
        hydrated = %{
          embed_url: "https://www.youtube.com/embed/#{video_id}",
          url: "https://www.youtube.com/watch?v=#{video_id}"
        }

        %{changeset | changes: Map.merge(changes, hydrated)}

      changeset ->
        changeset
    end
    |> unique_constraint(:embed_url)
  end
end
