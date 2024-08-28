defmodule Pista.Repo.Migrations.CreateTeamMatchResults do
  use Ecto.Migration

  def change do
    create table(:team_match_results, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :team_id, references(:teams, on_delete: :nothing, type: :binary_id)
      add :match_result_id, references(:match_results, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create index(:team_match_results, [:team_id])
    create index(:team_match_results, [:match_result_id])
  end
end
