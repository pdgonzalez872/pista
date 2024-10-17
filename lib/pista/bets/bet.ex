defmodule Pista.Bets.Bet do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "bets" do
    field :private, :boolean, default: false
    field :description, :string
    field :has_both_betting_sides, :boolean, default: false
    field :settled, :boolean, default: false
    field :outcome_proof, :string
    field :bettor_a_pre_notes, :string
    field :bettor_b_pre_notes, :string
    field :bettor_a_post_notes, :string
    field :bettor_b_post_notes, :string
    field :winner_id, Ecto.UUID
    field :bettor_a_id, Ecto.UUID
    field :bettor_b_id, Ecto.UUID

    timestamps()
  end

  @optional [
    :has_both_betting_sides,
    :settled,
    :outcome_proof,
    :bettor_a_pre_notes,
    :bettor_b_pre_notes,
    :bettor_a_post_notes,
    :bettor_b_post_notes,
    :winner_id,
    :bettor_a_id,
    :bettor_b_id
  ]
  @required [:private, :description]
  @all @required ++ @optional

  @doc false
  def changeset(bet, attrs) do
    bet
    |> cast(attrs, @all)
    |> validate_required(@required)
  end
end
