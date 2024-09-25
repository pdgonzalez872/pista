defmodule Pista.DataHydrationsTest do
  use Pista.DataCase

  describe "settle/1" do
    test "settles the different schemas correctly - match_result" do
      count_pre_players = Pista.Results.list_players() |> Enum.count()
      count_pre_teams = Pista.Results.list_teams() |> Enum.count()
      count_pre_player_match_results = Pista.Results.list_player_match_results() |> Enum.count()
      count_pre_team_match_results = Pista.Results.list_team_match_results() |> Enum.count()

      assert {:ok, %{id: tournament_id}} =
               %{
                 level: "some level",
                 url: "some url",
                 event_name: "some event_name",
                 city: "some city",
                 country: "some country",
                 start_date: ~D[2024-01-26],
                 end_date: ~D[2024-01-26],
                 tour: "some tour",
                 tournament_grade: "some tournament_grade"
               }
               |> Pista.Tournaments.create_tournament()

      assert {:ok, %{id: tournament_draw_id}} =
               Pista.Tournaments.create_tournament_draw(%{
                 status: "some status",
                 url: "some url",
                 tournament_id: tournament_id
               })

      match_result_args = %{
        match_draw_kind: "D",
        match_gender: "M",
        match_round: "finals",
        match_round_identifier: "01",
        match_winner: "team_2",
        match_winner_derived: "team_2",
        team_1_player_1_name: "Miguel Yanguas",
        team_1_player_2_name: "Javier Garrido",
        team_2_player_1_name: "Arturo Coello",
        team_2_player_2_name: "Agustin Tapia",
        team_1_player_1_country_flag: "Spain",
        team_1_player_2_country_flag: "Spain",
        team_2_player_1_country_flag: "Spain",
        team_2_player_2_country_flag: "Argentina",
        team_1_set_1: 0,
        team_1_set_2: 2,
        team_1_set_3: 0,
        team_1_third_party_team_id: "P000018",
        team_1_winner_additional_info: "loser",
        team_2_set_1: 6,
        team_2_set_2: 6,
        team_2_set_3: 0,
        team_2_third_party_team_id: "P000010",
        team_2_winner_additional_info: "winner",
        tournament_draw_id: tournament_draw_id,
        fetch_trigger_kind: "manual",
        fetch_run_id: "b469b671-6708-45ee-835f-a33f14162008",
        status: nil
      }

      assert {:ok, match_result} = Pista.Results.create_match_result(match_result_args)
      assert {:ok, match_result} = Pista.DataHydrations.hydrate(match_result)

      assert (Pista.Results.list_players() |> Enum.count()) - count_pre_players == 4
      assert (Pista.Results.list_teams() |> Enum.count()) - count_pre_teams == 2

      assert (Pista.Results.list_player_match_results() |> Enum.count()) -
               count_pre_player_match_results == 4

      assert (Pista.Results.list_team_match_results() |> Enum.count()) -
               count_pre_team_match_results == 2

      assert match_result.status == "settled"
    end

    @tag :skip
    test "settles the different schemas correctly - tournament_draw" do
      raise "HERE"

      assert {:ok, %{id: tournament_id}} =
               %{
                 level: "some level",
                 url: "some url",
                 event_name: "some event_name",
                 city: "some city",
                 country: "some country",
                 start_date: ~D[2024-01-26],
                 end_date: ~D[2024-01-26],
                 tour: "some tour",
                 tournament_grade: "some tournament_grade"
               }
               |> Pista.Tournaments.create_tournament()

      assert {:ok, %{id: tournament_draw_id}} =
               Pista.Tournaments.create_tournament_draw(%{
                 status: "some status",
                 url: "some url",
                 tournament_id: tournament_id
               })

      match_result_args = %{
        match_draw_kind: "D",
        match_gender: "M",
        match_round: "finals",
        match_round_identifier: "01",
        match_winner: "team_2",
        match_winner_derived: "team_2",
        team_1_player_1_name: "Miguel Yanguas",
        team_1_player_2_name: "Javier Garrido",
        team_2_player_1_name: "Arturo Coello",
        team_2_player_2_name: "Agustin Tapia",
        team_1_player_1_country_flag: "Spain",
        team_1_player_2_country_flag: "Spain",
        team_2_player_1_country_flag: "Spain",
        team_2_player_2_country_flag: "Argentina",
        team_1_set_1: 0,
        team_1_set_2: 2,
        team_1_set_3: 0,
        team_1_third_party_team_id: "P000018",
        team_1_winner_additional_info: "loser",
        team_2_set_1: 6,
        team_2_set_2: 6,
        team_2_set_3: 0,
        team_2_third_party_team_id: "P000010",
        team_2_winner_additional_info: "winner",
        tournament_draw_id: tournament_draw_id,
        fetch_trigger_kind: "manual",
        fetch_run_id: "b469b671-6708-45ee-835f-a33f14162008",
        status: nil
      }

      assert {:ok, _match_result} = Pista.Results.create_match_result(match_result_args)
    end
  end

  describe "hydrate_countryless_tournament/2" do
    @tag :this
    test "hydrates a tournament from A1 when there is no country" do
      valid_attrs = %{
        level: "some level",
        url: "some url",
        event_name: "Puebla",
        city: "some city",
        country: "some country",
        start_date: ~D[2024-01-26],
        end_date: ~D[2024-01-26],
        tour: "A1",
        tournament_grade: "some tournament_grade"
      }

      assert {:ok, tournament_with_country} = Pista.Tournaments.create_tournament(valid_attrs)

      assert {:ok, tournament_without_country} =
               Pista.Tournaments.create_tournament(Map.put(valid_attrs, :country, "-"))

      target_list = [
        %{event_name: "PUEBLA", country: "México"},
        %{event_name: "MONACO", country: "Mónaco"},
        %{event_name: "CHILE", country: "Chile"},
        %{event_name: "FRANCE", country: "Francia"},
        %{event_name: "SANLÚCAR DE BARRAMEDA", country: "España"}
      ]

      assert {:ok, %{country: "some country"}} =
               Pista.DataHydrations.hydrate_countryless_tournament(
                 tournament_with_country,
                 target_list
               )

      assert {:ok, %{country: "México"}} =
               Pista.DataHydrations.hydrate_countryless_tournament(
                 tournament_without_country,
                 target_list
               )
    end
  end
end
