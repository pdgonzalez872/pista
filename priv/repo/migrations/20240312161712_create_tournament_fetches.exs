defmodule Pista.Repo.Migrations.CreateTournamentFetches do
  use Ecto.Migration

  def change do
    create table(:tournament_fetches, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :fetch_date, :date

      timestamps()
    end
  end
end
