defmodule Pista.Repo.Migrations.RemovePlayerIdsFromPlayerMatchResults do
  use Ecto.Migration

  def change do
    alter table(:player_match_results) do
      remove :player_1_id
      remove :player_2_id
      add(:player_id, :uuid)
    end
  end
end
