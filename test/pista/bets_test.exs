defmodule Pista.BetsTest do
  use Pista.DataCase

  alias Pista.Bets

  describe "bets" do
    alias Pista.Bets.Bet

    import Pista.BetsFixtures

    @invalid_attrs %{private: nil, description: nil, has_both_betting_sides: nil, settled: nil, outcome_proof: nil, bettor_a_pre_notes: nil, bettor_b_pre_notes: nil, bettor_a_post_notes: nil, bettor_b_post_notes: nil, winner_id: nil, bettor_a_id: nil, bettor_b_id: nil}

    test "list_bets/0 returns all bets" do
      bet = bet_fixture()
      assert Bets.list_bets() == [bet]
    end

    test "get_bet!/1 returns the bet with given id" do
      bet = bet_fixture()
      assert Bets.get_bet!(bet.id) == bet
    end

    test "create_bet/1 with valid data creates a bet" do
      valid_attrs = %{private: true, description: "some description", has_both_betting_sides: true, settled: true, outcome_proof: "some outcome_proof", bettor_a_pre_notes: "some bettor_a_pre_notes", bettor_b_pre_notes: "some bettor_b_pre_notes", bettor_a_post_notes: "some bettor_a_post_notes", bettor_b_post_notes: "some bettor_b_post_notes", winner_id: "7488a646-e31f-11e4-aace-600308960662", bettor_a_id: "7488a646-e31f-11e4-aace-600308960662", bettor_b_id: "7488a646-e31f-11e4-aace-600308960662"}

      assert {:ok, %Bet{} = bet} = Bets.create_bet(valid_attrs)
      assert bet.private == true
      assert bet.description == "some description"
      assert bet.has_both_betting_sides == true
      assert bet.settled == true
      assert bet.outcome_proof == "some outcome_proof"
      assert bet.bettor_a_pre_notes == "some bettor_a_pre_notes"
      assert bet.bettor_b_pre_notes == "some bettor_b_pre_notes"
      assert bet.bettor_a_post_notes == "some bettor_a_post_notes"
      assert bet.bettor_b_post_notes == "some bettor_b_post_notes"
      assert bet.winner_id == "7488a646-e31f-11e4-aace-600308960662"
      assert bet.bettor_a_id == "7488a646-e31f-11e4-aace-600308960662"
      assert bet.bettor_b_id == "7488a646-e31f-11e4-aace-600308960662"
    end

    test "create_bet/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Bets.create_bet(@invalid_attrs)
    end

    test "update_bet/2 with valid data updates the bet" do
      bet = bet_fixture()
      update_attrs = %{private: false, description: "some updated description", has_both_betting_sides: false, settled: false, outcome_proof: "some updated outcome_proof", bettor_a_pre_notes: "some updated bettor_a_pre_notes", bettor_b_pre_notes: "some updated bettor_b_pre_notes", bettor_a_post_notes: "some updated bettor_a_post_notes", bettor_b_post_notes: "some updated bettor_b_post_notes", winner_id: "7488a646-e31f-11e4-aace-600308960668", bettor_a_id: "7488a646-e31f-11e4-aace-600308960668", bettor_b_id: "7488a646-e31f-11e4-aace-600308960668"}

      assert {:ok, %Bet{} = bet} = Bets.update_bet(bet, update_attrs)
      assert bet.private == false
      assert bet.description == "some updated description"
      assert bet.has_both_betting_sides == false
      assert bet.settled == false
      assert bet.outcome_proof == "some updated outcome_proof"
      assert bet.bettor_a_pre_notes == "some updated bettor_a_pre_notes"
      assert bet.bettor_b_pre_notes == "some updated bettor_b_pre_notes"
      assert bet.bettor_a_post_notes == "some updated bettor_a_post_notes"
      assert bet.bettor_b_post_notes == "some updated bettor_b_post_notes"
      assert bet.winner_id == "7488a646-e31f-11e4-aace-600308960668"
      assert bet.bettor_a_id == "7488a646-e31f-11e4-aace-600308960668"
      assert bet.bettor_b_id == "7488a646-e31f-11e4-aace-600308960668"
    end

    test "update_bet/2 with invalid data returns error changeset" do
      bet = bet_fixture()
      assert {:error, %Ecto.Changeset{}} = Bets.update_bet(bet, @invalid_attrs)
      assert bet == Bets.get_bet!(bet.id)
    end

    test "delete_bet/1 deletes the bet" do
      bet = bet_fixture()
      assert {:ok, %Bet{}} = Bets.delete_bet(bet)
      assert_raise Ecto.NoResultsError, fn -> Bets.get_bet!(bet.id) end
    end

    test "change_bet/1 returns a bet changeset" do
      bet = bet_fixture()
      assert %Ecto.Changeset{} = Bets.change_bet(bet)
    end
  end
end
