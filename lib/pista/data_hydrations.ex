defmodule Pista.DataHydrations do
  @moduledoc """
  Hydrations are about settleling a record, making a record whole. Once we do
  so, we can close the books on it and move on.

  This cascades, but upwards :)

  Meaning that all records that spawn other records (tournament_draw spawns
  match_results) need to have the children settled before we can settled
  itself. Eg: you must settle the match_results first, then, the
  tournament_draw.
  """

  alias Pista.Tournaments
  alias Pista.Tournaments.TournamentDraw
  alias Pista.Results
  alias Pista.Results.MatchResult

  require Logger

  def settle(%MatchResult{}) do
  end

  def settle(%TournamentDraw{}) do
  end

  def hydrate(%MatchResult{} = match_result) do
    with {:ok, tournament_draw} <-
           get_fun(&Tournaments.get_tournament_draw/1, match_result.tournament_draw_id),
         {:ok, tournament} <-
           get_fun(&Tournaments.get_tournament/1, tournament_draw.tournament_id),
         {:ok, match_result} <-
           Results.update_match_result(match_result, %{tournament_id: tournament.id}),
         {:ok, %{error_count: 0}} <- find_or_create_players(match_result),
         {:ok, match_result} <- get_fun(&Results.get_match_result/1, match_result.id),
         {:ok, %{error_count: 0}} <- find_or_create_teams(match_result),
         {:ok, match_result} <- get_fun(&Results.get_match_result/1, match_result.id),
         {:ok, match_result} = success <-
           Results.update_match_result(match_result, %{status: "settled"}),
         {:ok, %{error_count: 0}} <- create_player_match_results(match_result),
         {:ok, %{error_count: 0}} <- create_team_match_results(match_result) do
      Logger.info("Successfully hydrated match_result: id #{match_result.id}")
      success
    else
      error ->
        Logger.error("Error hydrating match_result: #{inspect(error)}")
        error
    end
  end

  def hydrate(%TournamentDraw{}) do
    # check all match_results for the tournament draw
    dbg()
  end

  defp get_fun(fun, args) do
    case fun.(args) do
      nil ->
        msg = "Error reading resource: fun: #{fun} args: #{args}"
        Logger.error(msg)

        {:error, msg}

      found ->
        {:ok, found}
    end
  end

  def find_or_create_players(match_result) do
    results =
      [
        {:team_1_player_1_name, :team_1_player_1_country_flag, :team_1_player_1_id},
        {:team_1_player_2_name, :team_1_player_2_country_flag, :team_1_player_2_id},
        {:team_2_player_1_name, :team_2_player_1_country_flag, :team_2_player_1_id},
        {:team_2_player_2_name, :team_2_player_2_country_flag, :team_2_player_2_id}
      ]
      |> Enum.reduce(%{success_count: 0, error_count: 0}, fn {name_key, country_flag_key, id},
                                                             acc ->
        name = Map.get(match_result, name_key)
        country_flag = Map.get(match_result, country_flag_key)

        {:ok, player} = find_or_create_player(name, country_flag)

        args =
          %{}
          |> Map.put(name_key, player.name)
          |> Map.put(country_flag_key, player.country_flag)
          |> Map.put(id, player.id)

        case Pista.Results.update_match_result(match_result, args) do
          {:ok, _} -> Map.put(acc, :success_count, acc.success_count + 1)
          _ -> Map.put(acc, :error_count, acc.error_count + 1)
        end
      end)

    {:ok, results}
  end

  defp find_or_create_player(name, country_flag) do
    name
    |> Pista.Results.get_player_by_name_and_country_flag(country_flag)
    |> case do
      {:error, :not_found} ->
        pseudo_unique = String.replace("#{name}_#{country_flag}", " ", "_")

        Pista.Results.create_player(%{
          name: name,
          country_flag: country_flag,
          pseudo_unique: pseudo_unique
        })

      {:ok, _found} = success ->
        success
    end
  end

  def find_or_create_teams(match_result) do
    result =
      [
        {Map.get(match_result, :team_1_player_1_id), Map.get(match_result, :team_1_player_2_id),
         :team_1_id},
        {Map.get(match_result, :team_2_player_1_id), Map.get(match_result, :team_2_player_2_id),
         :team_2_id}
      ]
      |> Enum.reduce(%{success_count: 0, error_count: 0}, fn {player_1_id, player_2_id,
                                                              target_team_id},
                                                             acc ->
        {:ok, team} =
          %{player_1_id: player_1_id, player_2_id: player_2_id}
          |> Pista.Results.get_team_by_players()
          |> case do
            {:error, :not_found} ->
              Pista.Results.create_team(%{
                player_1_id: player_1_id,
                player_2_id: player_2_id
              })

            {:ok, _found} = success ->
              success
          end

        args = Map.put(%{}, target_team_id, team.id)

        case Pista.Results.update_match_result(match_result, args) do
          {:ok, _} -> Map.put(acc, :success_count, acc.success_count + 1)
          _ -> Map.put(acc, :error_count, acc.error_count + 1)
        end
      end)

    {:ok, result}
  end

  def create_player_match_results(match_result) do
    result =
      [
        :team_1_player_1_id,
        :team_1_player_2_id,
        :team_2_player_1_id,
        :team_2_player_2_id
      ]
      |> Enum.reduce(%{success_count: 0, error_count: 0}, fn target_id, acc ->
        player_id = Map.get(match_result, target_id)

        case Pista.Results.create_player_match_result(%{
               player_id: player_id,
               match_result_id: match_result.id
             }) do
          {:ok, _} -> Map.put(acc, :success_count, acc.success_count + 1)
          _ -> Map.put(acc, :error_count, acc.error_count + 1)
        end
      end)

    {:ok, result}
  end

  def create_team_match_results(match_result) do
    result =
      [
        :team_1_id,
        :team_2_id
      ]
      |> Enum.reduce(%{success_count: 0, error_count: 0}, fn target_id, acc ->
        team_id = Map.get(match_result, target_id)

        case Pista.Results.create_team_match_result(%{
               team_id: team_id,
               match_result_id: match_result.id
             }) do
          {:ok, _} -> Map.put(acc, :success_count, acc.success_count + 1)
          _ -> Map.put(acc, :error_count, acc.error_count + 1)
        end
      end)

    {:ok, result}
  end

  def hydrate_countryless_tournaments() do
    # refactor with
    with {:ok, %{body: body}} <-
           Pista.Requests.get("https://www.a1padelglobal.com/calendario.aspx"),
         {:ok, tournaments_from_calendar} <-
           Pista.HTMLParsers.parse_tournaments_calendar_a1(%{html_input: body}) do
      # call hydrate for all of the countryless tournaments we have in the db - use tournaments_from_calendar
      Pista.Tournaments.list_tournaments_a1()
      |> Enum.each(fn el ->
        hydrate_countryless_tournament(el, tournaments_from_calendar)
      end)
    else
      error ->
        Logger.error("Error countryless tournaments: #{inspect(error)}")
        error
    end

    # target_list = Pista.HTMLParsers.parse_tournaments_calendar_a1()
  end

  def hydrate_countryless_tournament(
        %Pista.Tournaments.Tournament{country: "-", event_name: event_name} = tournament,
        target_list
      ) do
    Logger.info("Should hydrate")

    target_list
    |> Enum.find(fn %{event_name: el_event_name} ->
      String.jaro_distance(String.downcase(event_name), String.downcase(el_event_name)) > 0.70
    end)
    |> case do
      %{country: country} ->
        Pista.Tournaments.update_tournament(tournament, %{country: country})

      error ->
        Logger.info(
          "Tried but could not find a name similat to #{event_name}, error: #{inspect(error)}"
        )

        {:ok, tournament}
    end
  end

  def hydrate_countryless_tournament(tournament, _) do
    Logger.info("noop")
    {:ok, tournament}
  end
end
