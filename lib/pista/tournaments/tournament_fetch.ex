defmodule Pista.Tournaments.TournamentFetch do
  @moduledoc """
  We use this to keep track of how often we check for new tournaments
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "tournament_fetches" do
    field :fetch_date, :date

    timestamps()
  end

  @doc false
  def changeset(tournament_fetch, attrs) do
    tournament_fetch
    |> cast(attrs, [:fetch_date])
    |> validate_required([:fetch_date])
  end
end
