defmodule Pista.ResultsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Pista.Results` context.
  """

  @doc """
  Generate a match_result.
  """
  def match_result_fixture(attrs \\ %{}) do
    {:ok, match_result} =
      attrs
      |> Enum.into(%{
        fetch_trigger_kind: "some fetch_trigger_kind",
        match_draw_kind: "some match_draw_kind",
        match_gender: "some match_gender",
        match_round: "some match_round",
        match_round_identifier: "some match_round_identifier",
        match_winner: "some match_winner",
        match_winner_derived: "some match_winner_derived",
        team_1_id: "7488a646-e31f-11e4-aace-600308960662",
        team_1_player_1_id: "7488a646-e31f-11e4-aace-600308960662",
        team_1_player_1_name: "some team_1_player_1_name",
        team_1_player_2_id: "7488a646-e31f-11e4-aace-600308960662",
        team_1_player_2_name: "some team_1_player_2_name",
        team_1_set_1: Enum.random(0..7),
        team_1_set_2: Enum.random(0..7),
        team_1_set_3: Enum.random(0..7),
        team_1_third_party_team_id: "some team_1_third_party_team_id",
        team_1_winner_additional_info: "some team_1_winner_additional_info",
        team_2_id: "7488a646-e31f-11e4-aace-600308960662",
        team_2_player_1_id: "7488a646-e31f-11e4-aace-600308960662",
        team_2_player_2_id: "7488a646-e31f-11e4-aace-600308960662",
        team_2_set_1: Enum.random(0..7),
        team_2_set_2: Enum.random(0..7),
        team_2_set_3: Enum.random(0..7),
        team_2_third_party_team_id: "some team_2_third_party_team_id",
        team_2_winner_additional_info: "some team_2_winner_additional_info",
        tournament_draw_id: "7488a646-e31f-11e4-aace-600308960662",
        tournament_id: "7488a646-e31f-11e4-aace-600308960662"
      })
      |> Pista.Results.create_match_result()

    match_result
  end

  @doc """
  Generate a player.
  """
  def player_fixture(attrs \\ %{}) do
    {:ok, player} =
      attrs
      |> Enum.into(%{
        country_flag: "some country_flag",
        name: "some name",
        pseudo_unique: "some pseudo_unique"
      })
      |> Pista.Results.create_player()

    player
  end

  @doc """
  Generate a team.
  """
  def team_fixture(attrs \\ %{}) do
    {:ok, team} =
      attrs
      |> Enum.into(%{})
      |> Pista.Results.create_team()

    team
  end

  @doc """
  Generate a player_match_result.
  """
  def player_match_result_fixture(attrs \\ %{}) do
    {:ok, player_match_result} =
      attrs
      |> Enum.into(%{})
      |> Pista.Results.create_player_match_result()

    player_match_result
  end

  @doc """
  Generate a team_match_result.
  """
  def team_match_result_fixture(attrs \\ %{}) do
    {:ok, team_match_result} =
      attrs
      |> Enum.into(%{})
      |> Pista.Results.create_team_match_result()

    team_match_result
  end
end
