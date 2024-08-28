defmodule Pista.Repo.Migrations.CreateTournamentDraws do
  use Ecto.Migration

  def change do
    create table(:tournament_draws, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :url, :string
      add :tour, :string
      add :status, :string
      add :tournament_id, references(:tournaments, on_delete: :nothing, type: :binary_id)
      add :gender, :string
      add :draw_kind, :string

      timestamps()
    end

    create index(:tournament_draws, [:tournament_id])
  end
end
