defmodule Pista.Repo.Migrations.AddStatusToTournaments do
  use Ecto.Migration

  def change do
    alter table(:tournaments) do
      add(:status, :string)
    end
  end
end
