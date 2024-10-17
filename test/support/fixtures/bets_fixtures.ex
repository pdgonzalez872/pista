defmodule Pista.BetsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Pista.Bets` context.
  """

  @doc """
  Generate a bet.
  """
  def bet_fixture(attrs \\ %{}) do
    {:ok, bet} =
      attrs
      |> Enum.into(%{
        bettor_a_id: "7488a646-e31f-11e4-aace-600308960662",
        bettor_a_post_notes: "some bettor_a_post_notes",
        bettor_a_pre_notes: "some bettor_a_pre_notes",
        bettor_b_id: "7488a646-e31f-11e4-aace-600308960662",
        bettor_b_post_notes: "some bettor_b_post_notes",
        bettor_b_pre_notes: "some bettor_b_pre_notes",
        description: "some description",
        has_both_betting_sides: true,
        outcome_proof: "some outcome_proof",
        private: true,
        settled: true,
        winner_id: "7488a646-e31f-11e4-aace-600308960662"
      })
      |> Pista.Bets.create_bet()

    bet
  end
end
