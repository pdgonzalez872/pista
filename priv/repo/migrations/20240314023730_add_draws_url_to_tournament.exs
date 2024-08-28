defmodule Pista.Repo.Migrations.AddDrawsUrlToTournament do
  use Ecto.Migration

  def change do
    alter table(:tournaments) do
      add(:draws_url, :string)
    end
  end
end
