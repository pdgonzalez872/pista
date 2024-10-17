defmodule Pista.Repo.Migrations.CreateBets do
  use Ecto.Migration

  def change do
    create table(:bets, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :private, :boolean, default: false, null: false
      add :description, :string
      add :has_both_betting_sides, :boolean, default: false, null: false
      add :settled, :boolean, default: false, null: false
      add :outcome_proof, :string
      add :bettor_a_pre_notes, :string
      add :bettor_b_pre_notes, :string
      add :bettor_a_post_notes, :string
      add :bettor_b_post_notes, :string
      add :winner_id, :uuid
      add :bettor_a_id, :uuid
      add :bettor_b_id, :uuid

      timestamps()
    end
  end
end
