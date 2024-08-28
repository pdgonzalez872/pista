defmodule Pista.Results.Team do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "teams" do
    field :player_1_id, :binary_id
    field :player_2_id, :binary_id

    timestamps()
  end

  @required [:player_1_id, :player_2_id]

  @doc false
  def changeset(team, attrs) do
    team
    |> cast(attrs, @required)
    |> validate_required(@required)
  end
end
