defmodule Pista.Results.TeamMatchResult do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "team_match_results" do
    field :team_id, :binary_id
    field :match_result_id, :binary_id

    timestamps()
  end

  @required [:team_id, :match_result_id]

  @doc false
  def changeset(team_match_result, attrs) do
    team_match_result
    |> cast(attrs, @required)
    |> validate_required(@required)
  end
end
