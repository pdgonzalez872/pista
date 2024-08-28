defmodule Pista.Tournaments.TournamentDraw do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "tournament_draws" do
    field :status, :string
    field :url, :string
    field :tour, :string
    field :tournament_id, :binary_id
    field :gender, :string
    field :draw_kind, :string

    timestamps()
  end

  @required [:url, :status]
  @optional [:tour, :tournament_id, :gender, :draw_kind]
  @all @required ++ @optional

  @doc false
  def changeset(tournament_draw, attrs) do
    tournament_draw
    |> cast(attrs, @all)
    |> validate_required(@required)
    |> unique_constraint(:url)
  end
end
