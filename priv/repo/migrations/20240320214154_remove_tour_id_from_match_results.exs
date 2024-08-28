defmodule Pista.Repo.Migrations.RemoveTourIdFromMatchResults do
  use Ecto.Migration

  def change do
    alter table(:match_results) do
      remove :tour_id
    end
  end
end
