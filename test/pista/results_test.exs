defmodule Pista.ResultsTest do
  use Pista.DataCase

  alias Pista.Results

  describe "match_results" do
    alias Pista.Results.MatchResult

    import Pista.ResultsFixtures

    test "list_match_results/0 returns all match_results" do
      match_result = match_result_fixture()
      assert Results.list_match_results() == [match_result]
    end

    test "get_match_result!/1 returns the match_result with given id" do
      match_result = match_result_fixture()
      assert Results.get_match_result!(match_result.id) == match_result
    end

    test "create_match_result/1 with valid data creates a match_result" do
      valid_attrs = %{
        match_draw_kind: "some match_draw_kind",
        match_gender: "some match_gender",
        match_round: "some match_round",
        match_round_identifier: "some match_round_identifier",
        match_winner: "some match_winner",
        match_winner_derived: "some match_winner_derived",
        team_1_player_1_name: "some team_1_player_1_name",
        team_1_player_2_name: "some team_1_player_2_name",
        team_1_set_1: 2,
        team_1_set_2: 2,
        team_1_set_3: 2,
        team_1_third_party_team_id: "some team_1_third_party_team_id",
        team_1_winner_additional_info: "some team_1_winner_additional_info",
        team_2_set_1: 6,
        team_2_set_2: 6,
        team_2_set_3: 6,
        team_2_third_party_team_id: "some team_2_third_party_team_id",
        team_2_winner_additional_info: "some team_2_winner_additional_info",
        team_1_player_1_id: "7488a646-e31f-11e4-aace-600308960662",
        team_1_player_2_id: "7488a646-e31f-11e4-aace-600308960662",
        team_2_player_1_id: "7488a646-e31f-11e4-aace-600308960662",
        team_2_player_2_id: "7488a646-e31f-11e4-aace-600308960662",
        team_1_id: "7488a646-e31f-11e4-aace-600308960662",
        team_2_id: "7488a646-e31f-11e4-aace-600308960662",
        tournament_draw_id: "7488a646-e31f-11e4-aace-600308960662",
        tournament_id: "7488a646-e31f-11e4-aace-600308960662",
        fetch_trigger_kind: "some fetch_trigger_kind"
      }

      assert {:ok, %MatchResult{} = match_result} = Results.create_match_result(valid_attrs)
      assert match_result.match_draw_kind == "some match_draw_kind"
      assert match_result.match_gender == "some match_gender"
      assert match_result.match_round == "some match_round"
      assert match_result.match_round_identifier == "some match_round_identifier"
      assert match_result.match_winner == "some match_winner"
      assert match_result.match_winner_derived == "some match_winner_derived"
      assert match_result.team_1_player_1_name == "some team_1_player_1_name"
      assert match_result.team_1_player_2_name == "some team_1_player_2_name"
      assert match_result.team_1_set_1 == 2
      assert match_result.team_1_set_2 == 2
      assert match_result.team_1_set_3 == 2
      assert match_result.team_1_third_party_team_id == "some team_1_third_party_team_id"
      assert match_result.team_1_winner_additional_info == "some team_1_winner_additional_info"
      assert match_result.team_2_set_1 == 6
      assert match_result.team_2_set_2 == 6
      assert match_result.team_2_set_3 == 6
      assert match_result.team_2_third_party_team_id == "some team_2_third_party_team_id"
      assert match_result.team_2_winner_additional_info == "some team_2_winner_additional_info"
      assert match_result.team_1_player_1_id == "7488a646-e31f-11e4-aace-600308960662"
      assert match_result.team_1_player_2_id == "7488a646-e31f-11e4-aace-600308960662"
      assert match_result.team_2_player_1_id == "7488a646-e31f-11e4-aace-600308960662"
      assert match_result.team_2_player_2_id == "7488a646-e31f-11e4-aace-600308960662"
      assert match_result.team_1_id == "7488a646-e31f-11e4-aace-600308960662"
      assert match_result.team_2_id == "7488a646-e31f-11e4-aace-600308960662"
      assert match_result.tournament_draw_id == "7488a646-e31f-11e4-aace-600308960662"
      assert match_result.tournament_id == "7488a646-e31f-11e4-aace-600308960662"
      assert match_result.fetch_trigger_kind == "some fetch_trigger_kind"
    end

    test "update_match_result/2 with valid data updates the match_result" do
      match_result = match_result_fixture()

      update_attrs = %{
        match_draw_kind: "some updated match_draw_kind",
        match_gender: "some updated match_gender",
        match_round: "some updated match_round",
        match_round_identifier: "some updated match_round_identifier",
        match_winner: "some updated match_winner",
        match_winner_derived: "some updated match_winner_derived",
        team_1_player_1_name: "some updated team_1_player_1_name",
        team_1_player_2_name: "some updated team_1_player_2_name",
        team_1_set_1: 6,
        team_1_set_2: 6,
        team_1_set_3: 6,
        team_1_third_party_team_id: "some updated team_1_third_party_team_id",
        team_1_winner_additional_info: "some updated team_1_winner_additional_info",
        team_2_set_1: 1,
        team_2_set_2: 1,
        team_2_set_3: 1,
        team_2_third_party_team_id: "some updated team_2_third_party_team_id",
        team_2_winner_additional_info: "some updated team_2_winner_additional_info",
        team_1_player_1_id: "7488a646-e31f-11e4-aace-600308960668",
        team_1_player_2_id: "7488a646-e31f-11e4-aace-600308960668",
        team_2_player_1_id: "7488a646-e31f-11e4-aace-600308960668",
        team_2_player_2_id: "7488a646-e31f-11e4-aace-600308960668",
        team_1_id: "7488a646-e31f-11e4-aace-600308960668",
        team_2_id: "7488a646-e31f-11e4-aace-600308960668",
        tournament_draw_id: "7488a646-e31f-11e4-aace-600308960668",
        tournament_id: "7488a646-e31f-11e4-aace-600308960668",
        fetch_trigger_kind: "some updated fetch_trigger_kind"
      }

      assert {:ok, %MatchResult{} = match_result} =
               Results.update_match_result(match_result, update_attrs)

      assert match_result.match_draw_kind == "some updated match_draw_kind"
      assert match_result.match_gender == "some updated match_gender"
      assert match_result.match_round == "some updated match_round"
      assert match_result.match_round_identifier == "some updated match_round_identifier"
      assert match_result.match_winner == "some updated match_winner"
      assert match_result.match_winner_derived == "some updated match_winner_derived"
      assert match_result.team_1_player_1_name == "some updated team_1_player_1_name"
      assert match_result.team_1_player_2_name == "some updated team_1_player_2_name"
      assert match_result.team_1_set_1 == 6
      assert match_result.team_1_set_2 == 6
      assert match_result.team_1_set_3 == 6
      assert match_result.team_1_third_party_team_id == "some updated team_1_third_party_team_id"

      assert match_result.team_1_winner_additional_info ==
               "some updated team_1_winner_additional_info"

      assert match_result.team_2_set_1 == 1
      assert match_result.team_2_set_2 == 1
      assert match_result.team_2_set_3 == 1
      assert match_result.team_2_third_party_team_id == "some updated team_2_third_party_team_id"

      assert match_result.team_2_winner_additional_info ==
               "some updated team_2_winner_additional_info"

      assert match_result.team_1_player_1_id == "7488a646-e31f-11e4-aace-600308960668"
      assert match_result.team_1_player_2_id == "7488a646-e31f-11e4-aace-600308960668"
      assert match_result.team_2_player_1_id == "7488a646-e31f-11e4-aace-600308960668"
      assert match_result.team_2_player_2_id == "7488a646-e31f-11e4-aace-600308960668"
      assert match_result.team_1_id == "7488a646-e31f-11e4-aace-600308960668"
      assert match_result.team_2_id == "7488a646-e31f-11e4-aace-600308960668"
      assert match_result.tournament_draw_id == "7488a646-e31f-11e4-aace-600308960668"
      assert match_result.tournament_id == "7488a646-e31f-11e4-aace-600308960668"
      assert match_result.fetch_trigger_kind == "some updated fetch_trigger_kind"
    end

    test "delete_match_result/1 deletes the match_result" do
      match_result = match_result_fixture()
      assert {:ok, %MatchResult{}} = Results.delete_match_result(match_result)
      assert_raise Ecto.NoResultsError, fn -> Results.get_match_result!(match_result.id) end
    end

    test "change_match_result/1 returns a match_result changeset" do
      match_result = match_result_fixture()
      assert %Ecto.Changeset{} = Results.change_match_result(match_result)
    end
  end

  describe "persist_results/3" do
    @tag :this
    test "persists results as expected" do
      valid_attrs = %{
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

      assert {:ok, %{id: tournament_id}} = Pista.Tournaments.create_tournament(valid_attrs)

      results = [
        %{
          errors: [],
          successes_count: 31,
          errors_count: 0,
          successes: [
            %{
              "gender_drawkind_round_identifier" => "WD001",
              "match_draw_kind" => "D",
              "match_gender" => "W",
              "match_round" => "finals",
              "match_round_identifier" => "01",
              "match_round_int" => 1,
              "match_winner" => "team_2",
              "match_winner_derived" => "team_2",
              "team_1_player_1_name" => "Amanda Girdo",
              "team_1_player_2_name" => "Carla Rodriguez Sanchez",
              "team_1_set_1" => 4,
              "team_1_set_2" => 1,
              "team_1_set_3" => 0,
              "team_1_third_party_team_id" => "P200116",
              "team_1_winner_additional_info" => "loser",
              "team_2_player_1_name" => "Jessica Ginier Barbier",
              "team_2_player_2_name" => "Carla Touly",
              "team_2_set_1" => 6,
              "team_2_set_2" => 6,
              "team_2_set_3" => 0,
              "team_2_third_party_team_id" => "P200919",
              "team_2_winner_additional_info" => "winner"
            }
          ]
        }
      ]

      assert %{successes: [_one], errors: []} =
               _result =
               Pista.Results.persist_results(
                 results,
                 tournament_id,
                 Ecto.UUID.generate(),
                 "manual"
               )
    end
  end

  describe "players" do
    alias Pista.Results.Player

    import Pista.ResultsFixtures

    @invalid_attrs %{name: nil, country_flag: nil, pseudo_unique: nil}

    test "list_players/0 returns all players" do
      player = player_fixture()
      assert Results.list_players() == [player]
    end

    test "get_player!/1 returns the player with given id" do
      player = player_fixture()
      assert Results.get_player!(player.id) == player
    end

    test "create_player/1 with valid data creates a player" do
      valid_attrs = %{
        name: "some name",
        country_flag: "some country_flag",
        pseudo_unique: "some pseudo_unique"
      }

      assert {:ok, %Player{} = player} = Results.create_player(valid_attrs)
      assert player.name == "some name"
      assert player.country_flag == "some country_flag"
      assert player.pseudo_unique == "some pseudo_unique"
    end

    test "create_player/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Results.create_player(@invalid_attrs)
    end

    test "update_player/2 with valid data updates the player" do
      player = player_fixture()

      update_attrs = %{
        name: "some updated name",
        country_flag: "some updated country_flag",
        pseudo_unique: "some updated pseudo_unique"
      }

      assert {:ok, %Player{} = player} = Results.update_player(player, update_attrs)
      assert player.name == "some updated name"
      assert player.country_flag == "some updated country_flag"
      assert player.pseudo_unique == "some updated pseudo_unique"
    end

    test "update_player/2 with invalid data returns error changeset" do
      player = player_fixture()
      assert {:error, %Ecto.Changeset{}} = Results.update_player(player, @invalid_attrs)
      assert player == Results.get_player!(player.id)
    end

    test "delete_player/1 deletes the player" do
      player = player_fixture()
      assert {:ok, %Player{}} = Results.delete_player(player)
      assert_raise Ecto.NoResultsError, fn -> Results.get_player!(player.id) end
    end

    test "change_player/1 returns a player changeset" do
      player = player_fixture()
      assert %Ecto.Changeset{} = Results.change_player(player)
    end
  end
end
