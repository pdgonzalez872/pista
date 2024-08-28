defmodule Pista.Tournaments.Tournament do
  use Ecto.Schema
  import Ecto.Changeset

  alias Pista.Tournaments

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "tournaments" do
    field :level, :string
    field :url, :string
    field :event_name, :string
    field :city, :string
    field :country, :string
    field :start_date, :date
    field :end_date, :date
    field :tour, :string
    field :tournament_grade, :string
    field :draws_url, :string
    field :status, :string

    timestamps()
  end

  @required [
    :event_name,
    :level,
    :url,
    :start_date,
    :end_date,
    :tour,
    :tournament_grade
  ]

  @optional [
    :city,
    :country,
    :draws_url,
    :status
  ]

  @all @required ++ @optional

  @doc false
  def changeset(tournament, attrs) do
    tournament
    |> cast(attrs, @all)
    |> validate_required(@required)
    |> get_draws_url()
  end

  defp get_draws_url(changeset) do
    changeset
    |> get_change(:url)
    |> case do
      nil ->
        changeset

      url_change ->
        draws_url = Tournaments.derive_draws_url(url_change)
        put_change(changeset, :draws_url, draws_url)
    end
  end
end
