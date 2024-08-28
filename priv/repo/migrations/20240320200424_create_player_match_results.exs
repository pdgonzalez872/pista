defmodule Pista.Repo.Migrations.CreatePlayerMatchResults do
  use Ecto.Migration

  def change do
    create table(:player_match_results, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :player_1_id, references(:players, on_delete: :nothing, type: :binary_id)
      add :player_2_id, references(:players, on_delete: :nothing, type: :binary_id)
      add :match_result_id, references(:match_results, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create index(:player_match_results, [:player_1_id])
    create index(:player_match_results, [:player_2_id])
    create index(:player_match_results, [:match_result_id])
  end
end
