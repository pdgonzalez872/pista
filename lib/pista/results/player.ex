defmodule Pista.Results.Player do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "players" do
    field :name, :string
    field :country_flag, :string
    field :pseudo_unique, :string

    timestamps()
  end

  @doc false
  def changeset(player, attrs) do
    player
    |> cast(attrs, [:name, :country_flag, :pseudo_unique])
    |> validate_required([:name, :country_flag, :pseudo_unique])
  end
end
