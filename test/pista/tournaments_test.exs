defmodule Pista.TournamentsTest do
  use Pista.DataCase

  alias Pista.Tournaments

  describe "tournaments" do
    alias Pista.Tournaments.Tournament

    import Pista.TournamentsFixtures

    @invalid_attrs %{
      level: nil,
      url: nil,
      event_name: nil,
      city: nil,
      country: nil,
      start_date: nil,
      end_date: nil,
      tour: nil,
      tournament_grade: nil
    }

    test "list_tournaments/0 returns all tournaments" do
      tournament = tournament_fixture()
      assert Tournaments.list_tournaments() == [tournament]
    end

    test "get_tournament!/1 returns the tournament with given id" do
      tournament = tournament_fixture()
      assert Tournaments.get_tournament!(tournament.id) == tournament
    end

    test "create_tournament/1 with valid data creates a tournament" do
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

      assert {:ok, %Tournament{} = tournament} = Tournaments.create_tournament(valid_attrs)
      assert tournament.level == "some level"
      assert tournament.url == "some url"
      assert tournament.event_name == "some event_name"
      assert tournament.city == "some city"
      assert tournament.country == "some country"
      assert tournament.start_date == ~D[2024-01-26]
      assert tournament.end_date == ~D[2024-01-26]
      assert tournament.tour == "some tour"
      assert tournament.tournament_grade == "some tournament_grade"
      assert tournament.draws_url == "some url"
    end

    test "create_tournament/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Tournaments.create_tournament(@invalid_attrs)
    end

    test "update_tournament/2 with valid data updates the tournament" do
      tournament = tournament_fixture()

      update_attrs = %{
        level: "some updated level",
        url: "some updated url",
        event_name: "some updated event_name",
        city: "some updated city",
        country: "some updated country",
        start_date: ~D[2024-01-27],
        end_date: ~D[2024-01-27],
        tour: "some updated tour",
        tournament_grade: "some updated tournament_grade"
      }

      assert {:ok, %Tournament{} = tournament} =
               Tournaments.update_tournament(tournament, update_attrs)

      assert tournament.level == "some updated level"
      assert tournament.url == "some updated url"
      assert tournament.event_name == "some updated event_name"
      assert tournament.city == "some updated city"
      assert tournament.country == "some updated country"
      assert tournament.start_date == ~D[2024-01-27]
      assert tournament.end_date == ~D[2024-01-27]
      assert tournament.tour == "some updated tour"
      assert tournament.tournament_grade == "some updated tournament_grade"
    end

    test "update_tournament/2 with invalid data returns error changeset" do
      tournament = tournament_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Tournaments.update_tournament(tournament, @invalid_attrs)

      assert tournament == Tournaments.get_tournament!(tournament.id)
    end

    test "delete_tournament/1 deletes the tournament" do
      tournament = tournament_fixture()
      assert {:ok, %Tournament{}} = Tournaments.delete_tournament(tournament)
      assert_raise Ecto.NoResultsError, fn -> Tournaments.get_tournament!(tournament.id) end
    end

    test "change_tournament/1 returns a tournament changeset" do
      tournament = tournament_fixture()
      assert %Ecto.Changeset{} = Tournaments.change_tournament(tournament)
    end
  end

  describe "tournament_fetches" do
    alias Pista.Tournaments.TournamentFetch

    import Pista.TournamentsFixtures

    @invalid_attrs %{fetch_date: nil}

    test "list_tournament_fetches/0 returns all tournament_fetches" do
      tournament_fetch = tournament_fetch_fixture()
      assert Tournaments.list_tournament_fetches() == [tournament_fetch]
    end

    test "get_tournament_fetch!/1 returns the tournament_fetch with given id" do
      tournament_fetch = tournament_fetch_fixture()
      assert Tournaments.get_tournament_fetch!(tournament_fetch.id) == tournament_fetch
    end

    test "create_tournament_fetch/1 with valid data creates a tournament_fetch" do
      valid_attrs = %{fetch_date: ~D[2024-03-11]}

      assert {:ok, %TournamentFetch{} = tournament_fetch} =
               Tournaments.create_tournament_fetch(valid_attrs)

      assert tournament_fetch.fetch_date == ~D[2024-03-11]
    end

    test "create_tournament_fetch/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Tournaments.create_tournament_fetch(@invalid_attrs)
    end

    test "update_tournament_fetch/2 with valid data updates the tournament_fetch" do
      tournament_fetch = tournament_fetch_fixture()
      update_attrs = %{fetch_date: ~D[2024-03-12]}

      assert {:ok, %TournamentFetch{} = tournament_fetch} =
               Tournaments.update_tournament_fetch(tournament_fetch, update_attrs)

      assert tournament_fetch.fetch_date == ~D[2024-03-12]
    end

    test "update_tournament_fetch/2 with invalid data returns error changeset" do
      tournament_fetch = tournament_fetch_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Tournaments.update_tournament_fetch(tournament_fetch, @invalid_attrs)

      assert tournament_fetch == Tournaments.get_tournament_fetch!(tournament_fetch.id)
    end

    test "delete_tournament_fetch/1 deletes the tournament_fetch" do
      tournament_fetch = tournament_fetch_fixture()
      assert {:ok, %TournamentFetch{}} = Tournaments.delete_tournament_fetch(tournament_fetch)

      assert_raise Ecto.NoResultsError, fn ->
        Tournaments.get_tournament_fetch!(tournament_fetch.id)
      end
    end

    test "change_tournament_fetch/1 returns a tournament_fetch changeset" do
      tournament_fetch = tournament_fetch_fixture()
      assert %Ecto.Changeset{} = Tournaments.change_tournament_fetch(tournament_fetch)
    end
  end

  describe "derive_draws_url/1" do
    test "works as expected" do
      valid_attrs = %{
        level: "some level",
        event_name: "some event_name",
        city: "some city",
        country: "some country",
        start_date: ~D[2024-01-26],
        end_date: ~D[2024-01-26],
        tour: "some tour",
        tournament_grade: "some tournament_grade"
      }

      [
        {"https://app.ultimatepadeltour.com/torneosHYR.aspx?idTorneo=2270",
         "https://app.ultimatepadeltour.com/torneoscuadros.aspx?idTorneo=2270"},
        {"https://www.a1padelglobal.com/torneo.aspx?idTorneo=2313",
         "https://www.a1padelglobal.com/torneoCuadros.aspx?idTorneo=2313"},
        {"https://www.padelfip.com/events/fip-gold-dubai-2023",
         "https://www.padelfip.com/events/fip-gold-dubai-2023/?tab=Draws"},
        {"https://dog.com", "https://dog.com"}
      ]
      |> Enum.each(fn {input, output} ->
        {:ok, tournament} =
          valid_attrs
          |> Map.put(:url, input)
          |> Tournaments.create_tournament()

        assert output == Tournaments.derive_draws_url(tournament.url)
      end)
    end
  end

  describe "derive_url/1" do
    @tag :this
    test "works as expected" do
      valid_attrs = %{
        level: "some level",
        url: "https://app.ultimatepadeltour.com/torneosHYR.aspx?idTorneo=2270",
        event_name: "some event_name",
        city: "some city",
        country: "some country",
        start_date: ~D[2024-01-26],
        end_date: ~D[2024-01-26],
        tour: "some tour",
        tournament_grade: "some tournament_grade"
      }

      assert {:ok, tournament} = Tournaments.create_tournament(valid_attrs)

      assert {:ok,
              %{draws_url: "https://app.ultimatepadeltour.com/torneoscuadros.aspx?idTorneo=2270"}} =
               Tournaments.derive_url_and_update_tournament(
                 tournament,
                 :draws_url,
                 &Tournaments.derive_draws_url/1
               )
    end
  end

  describe "tournament_draws" do
    alias Pista.Tournaments.TournamentDraw

    import Pista.TournamentsFixtures

    @invalid_attrs %{status: nil, url: nil}

    test "list_tournament_draws/0 returns all tournament_draws" do
      tournament_draw = tournament_draw_fixture()
      assert Tournaments.list_tournament_draws() == [tournament_draw]
    end

    test "get_tournament_draw!/1 returns the tournament_draw with given id" do
      tournament_draw = tournament_draw_fixture()
      assert Tournaments.get_tournament_draw!(tournament_draw.id) == tournament_draw
    end

    test "create_tournament_draw/1 with valid data creates a tournament_draw" do
      valid_attrs = %{status: "some status", url: "some url"}

      assert {:ok, %TournamentDraw{} = tournament_draw} =
               Tournaments.create_tournament_draw(valid_attrs)

      assert tournament_draw.status == "some status"
      assert tournament_draw.url == "some url"
    end

    test "create_tournament_draw/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Tournaments.create_tournament_draw(@invalid_attrs)
    end

    test "update_tournament_draw/2 with valid data updates the tournament_draw" do
      tournament_draw = tournament_draw_fixture()
      update_attrs = %{status: "some updated status", url: "some updated url"}

      assert {:ok, %TournamentDraw{} = tournament_draw} =
               Tournaments.update_tournament_draw(tournament_draw, update_attrs)

      assert tournament_draw.status == "some updated status"
      assert tournament_draw.url == "some updated url"
    end

    test "update_tournament_draw/2 with invalid data returns error changeset" do
      tournament_draw = tournament_draw_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Tournaments.update_tournament_draw(tournament_draw, @invalid_attrs)

      assert tournament_draw == Tournaments.get_tournament_draw!(tournament_draw.id)
    end

    test "delete_tournament_draw/1 deletes the tournament_draw" do
      tournament_draw = tournament_draw_fixture()
      assert {:ok, %TournamentDraw{}} = Tournaments.delete_tournament_draw(tournament_draw)

      assert_raise Ecto.NoResultsError, fn ->
        Tournaments.get_tournament_draw!(tournament_draw.id)
      end
    end

    test "change_tournament_draw/1 returns a tournament_draw changeset" do
      tournament_draw = tournament_draw_fixture()
      assert %Ecto.Changeset{} = Tournaments.change_tournament_draw(tournament_draw)
    end
  end
end
