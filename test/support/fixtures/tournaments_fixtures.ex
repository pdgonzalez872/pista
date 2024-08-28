defmodule Pista.TournamentsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Pista.Tournaments` context.
  """

  @doc """
  Generate a tournament.
  """
  def tournament_fixture(attrs \\ %{}) do
    {:ok, tournament} =
      attrs
      |> Enum.into(%{
        level: "some level",
        url: "some url",
        event_name: "some event_name",
        city: "some city",
        country: "some country",
        start_date: ~D[2024-01-26],
        end_date: ~D[2024-01-26],
        tour: "some tour",
        tournament_grade: "some tournament_grade"
      })
      |> Pista.Tournaments.create_tournament()

    tournament
  end

  @doc """
  Generate a tournament_fetch.
  """
  def tournament_fetch_fixture(attrs \\ %{}) do
    {:ok, tournament_fetch} =
      attrs
      |> Enum.into(%{
        fetch_date: ~D[2024-03-11]
      })
      |> Pista.Tournaments.create_tournament_fetch()

    tournament_fetch
  end

  @doc """
  Generate a tournament_draw.
  """
  def tournament_draw_fixture(attrs \\ %{}) do
    {:ok, tournament_draw} =
      attrs
      |> Enum.into(%{
        status: "some status",
        url: "some url"
      })
      |> Pista.Tournaments.create_tournament_draw()

    tournament_draw
  end
end
