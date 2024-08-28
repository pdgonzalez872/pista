defmodule Pista.Repo.Migrations.AddStatusToMatchResults do
  use Ecto.Migration

  def change do
    alter table(:match_results) do
      add(:status, :string)
    end
  end
end
