defmodule Pista.Repo.Migrations.AddCountryFlag do
  use Ecto.Migration

  def change do
    alter table(:match_results) do
      add(:team_1_player_1_country_flag, :string)
      add(:team_1_player_2_country_flag, :string)
      add(:team_2_player_1_country_flag, :string)
      add(:team_2_player_2_country_flag, :string)
    end
  end
end
