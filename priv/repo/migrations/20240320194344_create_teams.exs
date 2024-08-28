defmodule Pista.Repo.Migrations.CreateTeams do
  use Ecto.Migration

  def change do
    create table(:teams, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :player_1_id, references(:players, on_delete: :nothing, type: :binary_id)
      add :player_2_id, references(:players, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create index(:teams, [:player_1_id])
    create index(:teams, [:player_2_id])
  end
end
