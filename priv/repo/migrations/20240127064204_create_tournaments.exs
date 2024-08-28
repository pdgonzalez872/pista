defmodule Pista.Repo.Migrations.CreateTournaments do
  use Ecto.Migration

  def change do
    create table(:tournaments, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :event_name, :string
      add :city, :string
      add :country, :string
      add :level, :string
      add :url, :string
      add :start_date, :date
      add :end_date, :date
      add :tour, :string
      add :tournament_grade, :string

      timestamps()
    end
  end
end
