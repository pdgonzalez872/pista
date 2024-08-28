defmodule Pista.Repo.Migrations.CreateMatchResults do
  use Ecto.Migration

  def change do
    create table(:match_results, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :match_draw_kind, :string
      add :match_gender, :string
      add :match_round, :string
      add :match_round_identifier, :string
      add :match_winner, :string
      add :match_winner_derived, :string
      add :team_1_player_1_name, :string
      add :team_1_player_2_name, :string
      add :team_2_player_1_name, :string
      add :team_2_player_2_name, :string
      add :team_1_set_1, :integer
      add :team_1_set_2, :integer
      add :team_1_set_3, :integer
      add :team_1_third_party_team_id, :string
      add :team_1_winner_additional_info, :string
      add :team_2_set_1, :integer
      add :team_2_set_2, :integer
      add :team_2_set_3, :integer
      add :team_2_third_party_team_id, :string
      add :team_2_winner_additional_info, :string
      add :team_1_player_1_id, :uuid
      add :team_1_player_2_id, :uuid
      add :team_2_player_1_id, :uuid
      add :team_2_player_2_id, :uuid
      add :team_1_id, :uuid
      add :team_2_id, :uuid
      add :tournament_draw_id, :uuid
      add :tournament_id, :uuid
      add :fetch_trigger_kind, :string
      add :tour_id, :uuid

      timestamps()
    end
  end
end
