defmodule Pista.Results.PlayerMatchResult do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "player_match_results" do
    field :player_id, :binary_id
    field :match_result_id, :binary_id

    timestamps()
  end

  @required [:player_id, :match_result_id]

  @doc false
  def changeset(player_match_result, attrs) do
    player_match_result
    |> cast(attrs, @required)
    |> validate_required(@required)
  end
end
