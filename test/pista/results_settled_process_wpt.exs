defmodule ResultsSettledProcessWPTTest do
  use Pista.DataCase

  require Logger

  import Mox

  setup :verify_on_exit!

  describe "WPT results" do
    @tag :skip
    test "processes all the WPT tournaments" do
      {:ok, html_files} =
        ["test", "support", "fixtures", "static_html", "settled"]
        |> Path.join()
        |> File.ls()

      Enum.map(html_files, fn file_name ->
        Logger.info("Start Processing #{file_name}")

        # path =
        {:ok, html} =
          [
            File.cwd!(),
            "test",
            "support",
            "fixtures",
            "static_html",
            "settled",
            file_name
          ]
          |> Path.join()
          |> File.read()

        # require IEx; IEx.pry()

        assert {:ok,
                %{
                  successes_count: successes_count,
                  errors_count: errors_count,
                  successes: _successes
                } = _result} = Pista.ResultsParsers.WPTImpl.call(%{html_input: html})

        assert successes_count > 0

        if errors_count > 0 do
          IO.inspect(errors_count, label: "Errors Count")
        end

        Logger.info("Finish Processing #{file_name}")
      end)

      # require IEx; IEx.pry

      Logger.info("Finish Processing html_files")
    end
  end

  describe "FIP results " do
    @tag :this
    test "returns a data structure from an html doc correctly - where we get the post_id - Alicante 2024" do
      {:ok, html} =
        [
          File.cwd!(),
          "test",
          "support",
          "fixtures",
          "static_html",
          "settled",
          "results_fip_draws_url_alicante_2024.html"
        ]
        |> Path.join()
        |> File.read()

      expect(Pista.RequestsMock, :post_fip, 4, fn body ->
        expected = [
          "action=handle_ajax_request&drawType=WD&gender=W&postID=136495",
          "action=handle_ajax_request&drawType=WQ&gender=W&postID=136495",
          "action=handle_ajax_request&drawType=MQ&gender=M&postID=136495",
          "action=handle_ajax_request&drawType=MD&gender=M&postID=136495"
        ]

        assert body in expected

        {:ok, html} =
          [
            File.cwd!(),
            "test",
            "support",
            "fixtures",
            "static_html",
            "settled",
            "results_fip_draw_ajax_html_men_quali_alicante_2024.html"
          ]
          |> Path.join()
          |> File.read()

        to_encode = %{html: html}

        {:ok, %{body: Jason.encode!(to_encode)}}
      end)

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

      assert {:ok, _} =
               Pista.ResultsParsers.FIPImpl.call(%{html_input: html, tournament_id: tournament_id})
    end

    test "parses the ajax request response - mens draw quali Alicante 2024" do
      {:ok, html} =
        [
          File.cwd!(),
          "test",
          "support",
          "fixtures",
          "static_html",
          "settled",
          "results_fip_draw_ajax_html_men_quali_alicante_2024.html"
        ]
        |> Path.join()
        |> File.read()

      assert {:ok,
              %{
                successes_count: 28,
                errors_count: 0,
                successes: successes
              }} = Pista.ResultsParsers.FIPIndividualAjaxImpl.call(%{html_input: html})

      assert %{
               "gender_drawkind_round_identifier" => "MQ007",
               "match_draw_kind" => "Q",
               "match_gender" => "M",
               "match_round" => "quarters",
               "match_winner" => "team_2",
               "match_winner_derived" => "team_2",
               "team_1_player_1_name" => "Alvaro Bermejo De Alamo",
               "team_1_player_2_name" => "Agustin Reca",
               "team_1_set_1" => 6,
               "team_1_set_2" => 3,
               "team_1_set_3" => 0,
               "team_1_third_party_team_id" => "P201502",
               "team_1_winner_additional_info" => "loser",
               "team_2_player_1_name" => "Renzo Gabriel Nuñez",
               "team_2_player_2_name" => "Juan Pablo Dametto",
               "team_2_set_1" => 7,
               "team_2_set_2" => 6,
               "team_2_set_3" => 0,
               "team_2_third_party_team_id" => "P201323",
               "team_2_winner_additional_info" => "winner"
             } = Enum.at(successes, 0)

      assert %{
               "gender_drawkind_round_identifier" => "MQ016",
               "match_draw_kind" => "Q",
               "match_gender" => "M",
               "match_round" => "round_32",
               "match_winner" => "team_1",
               "match_winner_derived" => "team_1",
               "team_1_player_1_name" => "Lucas Danuzzo",
               "team_1_player_2_name" => "Adrian Abancen Filipiak",
               "team_1_set_1" => 6,
               "team_1_set_2" => 6,
               "team_1_set_3" => 0,
               "team_1_third_party_team_id" => "P100597",
               "team_1_winner_additional_info" => "winner",
               "team_2_player_1_name" => "Francis Langan",
               "team_2_player_2_name" => "Alexander Loughlan",
               "team_2_set_1" => 3,
               "team_2_set_2" => 3,
               "team_2_set_3" => 0,
               "team_2_third_party_team_id" => "P201199",
               "team_2_winner_additional_info" => "loser"
             } = Enum.at(successes, -1)
    end

    test "parses the ajax request response - mens draw main Alicante 2024" do
      {:ok, html} =
        [
          File.cwd!(),
          "test",
          "support",
          "fixtures",
          "static_html",
          "settled",
          "results_fip_draw_ajax_html_men_main_alicante_2024.html"
        ]
        |> Path.join()
        |> File.read()

      assert {:ok,
              %{
                successes_count: 31,
                errors_count: 0,
                successes: successes
              } = _result} = Pista.ResultsParsers.FIPIndividualAjaxImpl.call(%{html_input: html})

      assert %{
               "gender_drawkind_round_identifier" => "MD001",
               "match_draw_kind" => "D",
               "match_gender" => "M",
               "match_round" => "finals",
               "match_winner" => "team_2",
               "match_winner_derived" => "team_2",
               "team_1_player_1_name" => "Marc Sintes Villalonga",
               "team_1_player_2_name" => "Pau Miñano Ortinez",
               "team_1_set_1" => 1,
               "team_1_set_2" => 2,
               "team_1_set_3" => 0,
               "team_1_third_party_team_id" => "P100003",
               "team_1_winner_additional_info" => "loser",
               "team_2_player_1_name" => "Pol Hernandez Alvarez",
               "team_2_player_2_name" => "Ramiro Jesus Valenzuela",
               "team_2_set_1" => 6,
               "team_2_set_2" => 6,
               "team_2_set_3" => 0,
               "team_2_third_party_team_id" => "P100048",
               "team_2_winner_additional_info" => "winner",
               "match_round_identifier" => "01",
               "match_round_int" => 1
             } = Enum.at(successes, 0)

      assert %{
               "gender_drawkind_round_identifier" => "MD016",
               "match_draw_kind" => "D",
               "match_gender" => "M",
               "match_round" => "round_32",
               "match_round_identifier" => "16",
               "match_round_int" => 16,
               "match_winner" => "team_1",
               "match_winner_derived" => "team_1",
               "team_1_player_1_name" => "Alberto Garcia Jimenez",
               "team_1_player_2_name" => "Mario Cerezo Casado",
               "team_1_set_1" => 6,
               "team_1_set_2" => 6,
               "team_1_set_3" => 0,
               "team_1_third_party_team_id" => "P100056",
               "team_1_winner_additional_info" => "winner",
               "team_2_player_1_name" => "Teo Gamondi",
               "team_2_player_2_name" => "Facundo Dehnike",
               "team_2_set_1" => 2,
               "team_2_set_2" => 4,
               "team_2_set_3" => 0,
               "team_2_third_party_team_id" => "P100619",
               "team_2_winner_additional_info" => "loser"
             } = Enum.at(successes, -1)
    end

    test "parses the ajax request response - women main draw Alicante 2024" do
      {:ok, html} =
        [
          File.cwd!(),
          "test",
          "support",
          "fixtures",
          "static_html",
          "settled",
          "results_fip_draw_ajax_html_women_main_alicante_2024.html"
        ]
        |> Path.join()
        |> File.read()

      assert {:ok,
              %{
                successes_count: 31,
                errors_count: 0,
                successes: successes
              } = _result} = Pista.ResultsParsers.FIPIndividualAjaxImpl.call(%{html_input: html})

      assert %{
               "gender_drawkind_round_identifier" => "WD001",
               "match_draw_kind" => "D",
               "match_gender" => "W",
               "match_round" => "finals",
               "match_round_identifier" => "01",
               "match_round_int" => 1,
               "match_winner" => "team_2",
               "match_winner_derived" => "team_2",
               "team_1_player_1_name" => "Liza Groenveld",
               "team_1_player_2_name" => "Bo Luttikhuis",
               "team_1_set_1" => 3,
               "team_1_set_2" => 4,
               "team_1_set_3" => 0,
               "team_1_third_party_team_id" => "P200678",
               "team_1_winner_additional_info" => "loser",
               "team_2_player_1_name" => "Maria De La Paz Hermida Vazquez",
               "team_2_player_2_name" => "Eva Jimenez De La Plata Vargas",
               "team_2_set_1" => 6,
               "team_2_set_2" => 6,
               "team_2_set_3" => 0,
               "team_2_third_party_team_id" => "P203027",
               "team_2_winner_additional_info" => "winner"
             } = Enum.at(successes, 0)

      assert %{
               "gender_drawkind_round_identifier" => "WD016",
               "match_draw_kind" => "D",
               "match_gender" => "W",
               "match_round" => "round_32",
               "match_round_identifier" => "16",
               "match_round_int" => 16,
               "match_winner" => "team_1",
               "match_winner_derived" => "team_1",
               "team_1_player_1_name" => "Liza Groenveld",
               "team_1_player_2_name" => "Bo Luttikhuis",
               "team_1_set_1" => 6,
               "team_1_set_2" => 6,
               "team_1_set_3" => 0,
               "team_1_third_party_team_id" => "P200678",
               "team_1_winner_additional_info" => "winner",
               "team_2_player_1_name" => "Ainara Ruiz Albert",
               "team_2_player_2_name" => "Laura Apaolaza Cimadevilla",
               "team_2_set_1" => 2,
               "team_2_set_2" => 1,
               "team_2_set_3" => 0,
               "team_2_third_party_team_id" => "P201793",
               "team_2_winner_additional_info" => "loser"
             } = Enum.at(successes, -1)
    end
  end
end
