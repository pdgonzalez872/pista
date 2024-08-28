defmodule Pista.Results.MatchResult do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "match_results" do
    field :match_draw_kind, :string
    field :match_gender, :string
    field :match_round, :string
    field :match_round_identifier, :string
    field :match_winner, :string
    field :match_winner_derived, :string
    field :team_1_player_1_name, :string
    field :team_1_player_2_name, :string
    field :team_2_player_1_name, :string
    field :team_2_player_2_name, :string
    field :team_1_set_1, :integer
    field :team_1_set_2, :integer
    field :team_1_set_3, :integer
    field :team_1_third_party_team_id, :string
    field :team_1_winner_additional_info, :string
    field :team_2_set_1, :integer
    field :team_2_set_2, :integer
    field :team_2_set_3, :integer
    field :team_2_third_party_team_id, :string
    field :team_2_winner_additional_info, :string
    field :team_1_player_1_id, Ecto.UUID
    field :team_1_player_2_id, Ecto.UUID
    field :team_2_player_1_id, Ecto.UUID
    field :team_2_player_2_id, Ecto.UUID
    field :team_1_id, Ecto.UUID
    field :team_2_id, Ecto.UUID
    field :tournament_draw_id, Ecto.UUID
    field :tournament_id, Ecto.UUID
    field :fetch_trigger_kind, :string
    field :fetch_run_id, Ecto.UUID
    field :status, :string
    field :team_1_player_1_country_flag, :string
    field :team_1_player_2_country_flag, :string
    field :team_2_player_1_country_flag, :string
    field :team_2_player_2_country_flag, :string

    timestamps()
  end

  @required []
  @optional [
    :match_draw_kind,
    :match_gender,
    :match_round,
    :match_round_identifier,
    :match_winner,
    :match_winner_derived,
    :team_1_player_1_name,
    :team_1_player_2_name,
    :team_2_player_1_name,
    :team_2_player_2_name,
    :team_1_set_1,
    :team_1_set_2,
    :team_1_set_3,
    :team_1_third_party_team_id,
    :team_1_winner_additional_info,
    :team_2_set_1,
    :team_2_set_2,
    :team_2_set_3,
    :team_2_third_party_team_id,
    :team_2_winner_additional_info,
    :team_1_player_1_id,
    :team_1_player_2_id,
    :team_2_player_1_id,
    :team_2_player_2_id,
    :team_1_id,
    :team_2_id,
    :tournament_draw_id,
    :tournament_id,
    :fetch_trigger_kind,
    :fetch_run_id,
    :status,
    :team_1_player_1_country_flag,
    :team_1_player_2_country_flag,
    :team_2_player_1_country_flag,
    :team_2_player_2_country_flag
  ]
  @all @required ++ @optional

  @doc false
  def changeset(match_result, attrs) do
    match_result
    |> cast(attrs, @all)
    |> validate_required(@required)
  end
end
