defmodule Pista.ResultsParsers.FIPIndividualAjaxImpl do
  @moduledoc """
  # tourney_id,tourney_name,surface,draw_size,tourney_level,tourney_date,match_num,winner_id,winner_seed,winner_entry,winner_name,winner_hand,winner_ht,winner_ioc,winner_age,loser_id,loser_seed,loser_entry,loser_name,loser_hand,loser_ht,loser_ioc,loser_age,score,best_of,round,minutes,w_ace,w_df,w_svpt,w_1stIn,w_1stWon,w_2ndWon,w_SvGms,w_bpSaved,w_bpFaced,l_ace,l_df,l_svpt,l_1stIn,l_1stWon,l_2ndWon,l_SvGms,l_bpSaved,l_bpFaced,winner_rank,winner_rank_points,loser_rank,loser_rank_points
  """
  require Logger

  @behaviour Pista.HTMLParsers.HTMLParserBehaviour

  @impl true
  def call(%{html_input: html_input, tournament_draw_id: tournament_draw_id}) do
    triple = """
    \\\
    """

    single = """
    \
    """

    html_input =
      html_input
      |> String.replace("\n", "")
      |> String.replace("\\n", "")
      |> String.replace("\t", "")
      |> String.replace("\\t", "")
      |> String.replace(triple, "")
      |> String.replace(single, "")
      |> String.replace("\"", ~s("))
      |> String.replace("u00f1", "ñ")

    action = "processing html"
    Logger.info("Start #{action}")

    with {:ok, document} <- parse_html(html_input),
         {:ok, results_data} <- find_results_data(document),
         {:ok, _result} = success <- get_matches(results_data, tournament_draw_id) do
      Logger.info("Success #{action}")

      success
    else
      error ->
        Logger.error("Error #{action}: #{inspect(error)}")

        error
    end
  end

  defp parse_html(html_input) do
    Floki.parse_document(html_input)
  end

  defp find_results_data(document) do
    data = Floki.find(document, ".singleMatch")

    case Floki.text(data) do
      "" -> {:error, "Not able to find data in the html"}
      _found -> {:ok, data}
    end
  end

  defp get_matches(matches, tournament_draw_id) do
    output =
      matches
      |> Enum.reduce(%{successes: [], errors: [], successes_count: 0, errors_count: 0}, fn match,
                                                                                           acc ->
        with {:ok, gender_drawkind_round_identifier} <-
               get_gender_drawkind_round_identifier(match),
             {:ok, match_details} <-
               handle_match(match, String.split(gender_drawkind_round_identifier, "", trim: true)) do
          state =
            Map.merge(match_details, %{
              "gender_drawkind_round_identifier" => gender_drawkind_round_identifier,
              "tournament_draw_id" => tournament_draw_id
            })

          acc
          |> Map.put(:successes, [state | acc.successes])
          |> Map.put(:successes_count, acc.successes_count + 1)
        else
          error ->
            acc
            |> Map.put(:errors, [error | acc.errors])
            |> Map.put(:errors_count, acc.errors_count + 1)
        end
      end)

    {:ok, output}
  end

  defp handle_match(match, gender_drawkind_round_identifier) do
    [_top_team, _bottom_team] = both_teams = Floki.find(match, ".singleMatch__team ")

    result =
      both_teams
      |> Enum.map(fn team ->
        team
        |> handle_team()
        |> case do
          {:ok, success} ->
            success

          error ->
            Logger.error("Error handling team #{inspect(team)}")
            error
        end
      end)
      |> Enum.with_index()
      |> Enum.reduce(%{}, fn {team, index}, acc ->
        target_index = index + 1

        [
          %{player_name: player_1_name, country_flag: player_1_country_flag},
          %{player_name: player_2_name, country_flag: player_2_country_flag}
        ] = team.players

        [first_set, second_set, third_set] =
          case team.sets do
            [] ->
              msg =
                "Parsing sets for team: #{inspect(team)}. Gotta look for another way of determining a winner, if any"

              Logger.warning(msg)
              [0, 0, 0]

            [_a, _b] = success ->
              result = Enum.map(success, fn el -> String.to_integer(el) end)
              result ++ [0]

            [_a, _b, _c] = success ->
              Enum.map(success, fn el -> String.to_integer(el) end)

            other ->
              Logger.error("Error parsing sets for team #{inspect(team)}, got #{inspect(other)}")
              [0, 0, 0]
          end

        _team_structure =
          acc
          |> Map.put("team_#{target_index}_player_1_name", player_1_name)
          |> Map.put("team_#{target_index}_player_2_name", player_2_name)
          |> Map.put("team_#{target_index}_player_1_country_flag", player_1_country_flag)
          |> Map.put("team_#{target_index}_player_2_country_flag", player_2_country_flag)
          |> Map.put("team_#{target_index}_third_party_team_id", team.team_id)
          |> Map.put("team_#{target_index}_set_1", first_set)
          |> Map.put("team_#{target_index}_set_2", second_set)
          |> Map.put("team_#{target_index}_set_3", third_set)
          |> Map.put("team_#{target_index}_winner_additional_info", team.winner)
          |> dbg()
      end)
      |> get_winner()
      |> get_winner_derived()
      |> get_round(gender_drawkind_round_identifier)
      |> get_gender(gender_drawkind_round_identifier)
      |> get_draw_kind(gender_drawkind_round_identifier)

    {:ok, result}
  end

  defp get_gender_drawkind_round_identifier(match) do
    get_attribute(match, "data-match-id")
  end

  defp get_team_id(team) do
    get_attribute(team, "data-single-team")
  end

  defp get_attribute(element, attribute) do
    case Floki.attribute(element, attribute) do
      [] -> {:error, "Can't find attribute #{attribute}"}
      [found] -> {:ok, found}
    end
  end

  defp handle_team(team) do
    with {:ok, team_id} <- get_team_id(team),
         {:ok, players} <- handle_players(team),
         {:ok, sets} <- get_sets_for_team(team),
         {:ok, potential_winner} <- get_additional_info(team) do
      success = %{
        team_id: team_id,
        players: players,
        sets: sets,
        winner: potential_winner
      }

      {:ok, success}
    else
      error ->
        Logger.error("Error processing matches: #{inspect(error)}")
        error
    end
  end

  defp handle_players(team) do
    players =
      team
      |> Floki.find(".singleMatch__team--item")
      |> Enum.map(fn player -> handle_player(player) end)

    {:ok, players}
  end

  defp handle_player(player) do
    country_flag = player |> Floki.find("img") |> Floki.attribute("src") |> Floki.text()
    player_name = player |> Floki.find("p.singleMatch__team--itemName") |> Floki.text()

    %{country_flag: country_flag, player_name: player_name}
  end

  defp get_sets_for_team(team) do
    sets =
      team
      |> Floki.find(".singleMatch__tableSet")
      |> Floki.text()
      |> String.split(" ", trim: true)

    {:ok, sets}
  end

  defp get_winner(
         %{"team_1_winner_additional_info" => "winner", "team_2_winner_additional_info" => _} =
           match_data
       ) do
    Map.put(match_data, "match_winner", "team_1")
  end

  defp get_winner(
         %{"team_1_winner_additional_info" => _, "team_2_winner_additional_info" => "winner"} =
           match_data
       ) do
    Map.put(match_data, "match_winner", "team_2")
  end

  defp get_winner(match_data) do
    Map.put(match_data, "match_winner", "no_winner_additional_info")
  end

  defp get_winner_derived(match_data) do
    team_1_sets = [
      Map.get(match_data, "team_1_set_1"),
      Map.get(match_data, "team_1_set_2"),
      Map.get(match_data, "team_1_set_3")
    ]

    team_2_sets = [
      Map.get(match_data, "team_2_set_1"),
      Map.get(match_data, "team_2_set_2"),
      Map.get(match_data, "team_2_set_3")
    ]

    case compare_results(team_1_sets, team_2_sets) do
      :t1 ->
        Map.put(match_data, "match_winner_derived", "team_1")

      :t2 ->
        Map.put(match_data, "match_winner_derived", "team_2")

      other ->
        Logger.warning("Error deriving winner, for #{inspect(match_data)}, got #{inspect(other)}")

        Map.put(match_data, "match_winner_derived", "cannot_derive_winner")
    end
  end

  def compare_results([t1s1, t1s2, t1s3], [t2s1, t2s2, t2s3]) do
    compare_two_fun = fn t1, t2 ->
      if t1 > t2 do
        :t1
      else
        :t2
      end
    end

    result =
      [
        [t1s1, t2s1],
        [t1s2, t2s2],
        [t1s3, t2s3]
      ]
      |> Enum.map(fn
        [0, 0] ->
          :nobody

        [t1, t2] ->
          compare_two_fun.(t1, t1)

          if t1 > t2 do
            :t1
          else
            :t2
          end
      end)
      |> Enum.group_by(& &1)

    compare_two_fun.(Map.get(result, :t1, []), Map.get(result, :t2, []))
  end

  defp get_additional_info(team) do
    team
    |> Floki.find(".additionalInfo")
    |> Floki.text()
    |> String.contains?("✓")
    |> case do
      true -> {:ok, "winner"}
      _ -> {:ok, "loser"}
    end
  end

  defp get_round(
         match_data,
         [_gender, _draw_kind, _, first_digit, second_digit] = _gender_drawkind_round_identifier
       ) do
    combined = first_digit <> second_digit
    int = String.to_integer(combined)

    match_round =
      cond do
        int in 16..31 ->
          "round_32"

        int in 8..15 ->
          "round_16"

        int in 4..7 ->
          "quarters"

        int in 2..3 ->
          "semis"

        int == 1 ->
          "finals"

        true ->
          Logger.warning("Unable to derive round for #{inspect(binding())}")
          "NA"
      end

    match_data
    |> Map.put("match_round", match_round)
    |> Map.put("match_round_identifier", combined)
    |> Map.put("match_round_int", int)
  end

  defp get_gender(
         match_data,
         [gender, _draw_kind, _, _first_digit, _second_digit] = _gender_drawkind_round_identifier
       ) do
    Map.merge(match_data, %{"match_gender" => gender})
  end

  defp get_draw_kind(
         match_data,
         [_gender, draw_kind, _, _first_digit, _second_digit] = _gender_drawkind_round_identifier
       ) do
    Map.merge(match_data, %{"match_draw_kind" => draw_kind})
  end
end
