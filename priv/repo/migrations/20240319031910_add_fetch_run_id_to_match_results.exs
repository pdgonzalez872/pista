defmodule Pista.Repo.Migrations.AddFetchRunIdToMatchResults do
  use Ecto.Migration

  def change do
    alter table(:match_results) do
      add(:fetch_run_id, :uuid)
    end
  end
end
