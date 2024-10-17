defmodule PistaWeb.BetLiveTest do
  use PistaWeb.ConnCase

  import Phoenix.LiveViewTest
  import Pista.BetsFixtures

  @create_attrs %{
    private: true,
    description: "some description",
    has_both_betting_sides: true,
    settled: true,
    outcome_proof: "some outcome_proof",
    bettor_a_pre_notes: "some bettor_a_pre_notes",
    bettor_b_pre_notes: "some bettor_b_pre_notes",
    bettor_a_post_notes: "some bettor_a_post_notes",
    bettor_b_post_notes: "some bettor_b_post_notes",
    winner_id: "7488a646-e31f-11e4-aace-600308960662",
    bettor_a_id: "7488a646-e31f-11e4-aace-600308960662",
    bettor_b_id: "7488a646-e31f-11e4-aace-600308960662"
  }
  @update_attrs %{
    private: false,
    description: "some updated description",
    has_both_betting_sides: false,
    settled: false,
    outcome_proof: "some updated outcome_proof",
    bettor_a_pre_notes: "some updated bettor_a_pre_notes",
    bettor_b_pre_notes: "some updated bettor_b_pre_notes",
    bettor_a_post_notes: "some updated bettor_a_post_notes",
    bettor_b_post_notes: "some updated bettor_b_post_notes",
    winner_id: "7488a646-e31f-11e4-aace-600308960668",
    bettor_a_id: "7488a646-e31f-11e4-aace-600308960668",
    bettor_b_id: "7488a646-e31f-11e4-aace-600308960668"
  }
  @invalid_attrs %{
    private: false,
    description: nil,
    has_both_betting_sides: false,
    settled: false,
    outcome_proof: nil,
    bettor_a_pre_notes: nil,
    bettor_b_pre_notes: nil,
    bettor_a_post_notes: nil,
    bettor_b_post_notes: nil,
    winner_id: nil,
    bettor_a_id: nil,
    bettor_b_id: nil
  }

  defp create_bet(_) do
    bet = bet_fixture()
    %{bet: bet}
  end

  describe "Index" do
    setup [:create_bet]

    test "lists all bets", %{conn: conn, bet: bet} do
      {:ok, _index_live, html} = live(conn, ~p"/bets")

      assert html =~ "Listing Bets"
      assert html =~ bet.description
    end

    test "saves new bet", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/bets")

      assert index_live |> element("a", "New Bet") |> render_click() =~
               "New Bet"

      assert_patch(index_live, ~p"/bets/new")

      assert index_live
             |> form("#bet-form", bet: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#bet-form", bet: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/bets")

      html = render(index_live)
      assert html =~ "Bet created successfully"
      assert html =~ "some description"
    end

    test "updates bet in listing", %{conn: conn, bet: bet} do
      {:ok, index_live, _html} = live(conn, ~p"/bets")

      assert index_live |> element("#bets-#{bet.id} a", "Edit") |> render_click() =~
               "Edit Bet"

      assert_patch(index_live, ~p"/bets/#{bet}/edit")

      assert index_live
             |> form("#bet-form", bet: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#bet-form", bet: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/bets")

      html = render(index_live)
      assert html =~ "Bet updated successfully"
      assert html =~ "some updated description"
    end

    test "deletes bet in listing", %{conn: conn, bet: bet} do
      {:ok, index_live, _html} = live(conn, ~p"/bets")

      assert index_live |> element("#bets-#{bet.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#bets-#{bet.id}")
    end
  end

  describe "Show" do
    setup [:create_bet]

    test "displays bet", %{conn: conn, bet: bet} do
      {:ok, _show_live, html} = live(conn, ~p"/bets/#{bet}")

      assert html =~ "Show Bet"
      assert html =~ bet.description
    end

    test "updates bet within modal", %{conn: conn, bet: bet} do
      {:ok, show_live, _html} = live(conn, ~p"/bets/#{bet}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Bet"

      assert_patch(show_live, ~p"/bets/#{bet}/show/edit")

      assert show_live
             |> form("#bet-form", bet: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#bet-form", bet: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/bets/#{bet}")

      html = render(show_live)
      assert html =~ "Bet updated successfully"
      assert html =~ "some updated description"
    end
  end
end
