defmodule Pista.Results do
  @moduledoc """
  Context for Results
  """
  import Ecto.Query, warn: false

  alias Pista.Repo
  alias Pista.Results.MatchResult
  alias Pista.Results.Player
  alias Pista.Results.PlayerMatchResult
  alias Pista.Results.Team
  alias Pista.Results.TeamMatchResult

  require Logger

  def handle_tournament(
        %{tour: tour, draws_url: draws_url, id: tournament_id},
        "manual" = fetch_trigger_kind
      )
      when tour in ["FIP", "Premier"] do
    with html_input <- make_request(draws_url),
         {:ok, %{results: results}} <-
           Pista.ResultsParsers.FIPImpl.call(%{
             html_input: html_input,
             tournament_id: tournament_id
           }),
         {:ok, %{}} = success <-
           persist_results(results, tournament_id, Ecto.UUID.generate(), fetch_trigger_kind) do
      # Concept of hydrating the tournaments, the results and . A sweeper
      #
      #
      success
      # TODO:
      # - create a tournament_draw in the database
      #   - status -> complete, incomplete
      # - persist the results in the db
      # - persist a result fetch with the output (maybe encode it to json?)
      # - if there is a final and a winner, update the tournament with

      # Process:
      # - get a tournament
      #   - check if the tournament is finished ->
      #     - this should be set if all the tournament_draws for a tournament have a "complete" status
      #     - Quali tournament draws are complete if there are winners in the last matches
      #     - upsert tournament_draws for a tournament if they are not themselves "complete" (status)
    else
      error ->
        Logger.error("Error getting results for #{draws_url}")
        error
    end
  end

  def handle_tournament(%{tour: tour, draws_url: _draws_url} = tournament)
      when tour not in ["FIP"] do
    msg = "Not yet implemented for #{tournament.tour}, #{tournament.event_name}"
    Logger.warning(msg)
    {:error, %{message: msg}}
  end

  defp make_request(url) do
    case Pista.Requests.get(url) do
      {:ok, %{body: html}} = _result ->
        html

      error ->
        Logger.error("Error getting #{url}")
        error
    end
  end

  # def set_complete_tournament_draw(td) do
  #
  # end
  #
  # def set_complete_tournament_draw(tournament) do
  #
  # end

  @doc """
  Returns the list of match_results.

  ## Examples

      iex> list_match_results()
      [%MatchResult{}, ...]

  """
  def list_match_results do
    Repo.all(MatchResult)
  end

  @doc """
  Gets a single match_result.

  Raises `Ecto.NoResultsError` if the Match result does not exist.

  ## Examples

      iex> get_match_result!(123)
      %MatchResult{}

      iex> get_match_result!(456)
      ** (Ecto.NoResultsError)

  """
  def get_match_result!(id), do: Repo.get!(MatchResult, id)
  def get_match_result(id), do: Repo.get(MatchResult, id)

  @doc """
  Creates a match_result.

  ## Examples

      iex> create_match_result(%{field: value})
      {:ok, %MatchResult{}}

      iex> create_match_result(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_match_result(attrs \\ %{}) do
    %MatchResult{}
    |> MatchResult.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a match_result.

  ## Examples

      iex> update_match_result(match_result, %{field: new_value})
      {:ok, %MatchResult{}}

      iex> update_match_result(match_result, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_match_result(%MatchResult{} = match_result, attrs) do
    match_result
    |> MatchResult.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a match_result.

  ## Examples

      iex> delete_match_result(match_result)
      {:ok, %MatchResult{}}

      iex> delete_match_result(match_result)
      {:error, %Ecto.Changeset{}}

  """
  def delete_match_result(%MatchResult{} = match_result) do
    Repo.delete(match_result)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking match_result changes.

  ## Examples

      iex> change_match_result(match_result)
      %Ecto.Changeset{data: %MatchResult{}}

  """
  def change_match_result(%MatchResult{} = match_result, attrs \\ %{}) do
    MatchResult.changeset(match_result, attrs)
  end

  def persist_results(results, tournament_id, fetch_run_id, fetch_trigger_kind) do
    results
    |> Enum.map(fn r -> r.successes end)
    |> List.flatten()
    |> Enum.reduce(%{successes: [], errors: []}, fn s, acc ->
      s
      |> Map.put("tournament_id", tournament_id)
      |> Map.put("fetch_run_id", fetch_run_id)
      |> Map.put("fetch_trigger_kind", fetch_trigger_kind)
      |> create_match_result()
      |> case do
        {:ok, match_result} ->
          Map.put(acc, :successes, acc.successes ++ [match_result])

        error ->
          Map.put(acc, :errors, acc.errors ++ [error])
      end
    end)
  end

  @doc """
  Returns the list of players.

  ## Examples

      iex> list_players()
      [%Player{}, ...]

  """
  def list_players do
    Repo.all(Player)
  end

  @doc """
  Gets a single player.

  Raises `Ecto.NoResultsError` if the Player does not exist.

  ## Examples

      iex> get_player!(123)
      %Player{}

      iex> get_player!(456)
      ** (Ecto.NoResultsError)

  """
  def get_player!(id), do: Repo.get!(Player, id)

  def get_player_by_name_and_country_flag(name, country_flag) do
    query =
      from p in Player,
        where: p.name == ^name and p.country_flag == ^country_flag,
        select: p

    query
    |> Repo.one()
    |> case do
      nil -> {:error, :not_found}
      found -> {:ok, found}
    end
  end

  @doc """
  Creates a player.

  ## Examples

      iex> create_player(%{field: value})
      {:ok, %Player{}}

      iex> create_player(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_player(attrs \\ %{}) do
    %Player{}
    |> Player.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a player.

  ## Examples

      iex> update_player(player, %{field: new_value})
      {:ok, %Player{}}

      iex> update_player(player, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_player(%Player{} = player, attrs) do
    player
    |> Player.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a player.

  ## Examples

      iex> delete_player(player)
      {:ok, %Player{}}

      iex> delete_player(player)
      {:error, %Ecto.Changeset{}}

  """
  def delete_player(%Player{} = player) do
    Repo.delete(player)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking player changes.

  ## Examples

      iex> change_player(player)
      %Ecto.Changeset{data: %Player{}}

  """
  def change_player(%Player{} = player, attrs \\ %{}) do
    Player.changeset(player, attrs)
  end

  @doc """
  Returns the list of teams.

  ## Examples

      iex> list_teams()
      [%Team{}, ...]

  """
  def list_teams do
    Repo.all(Team)
  end

  @doc """
  Gets a single team.

  Raises `Ecto.NoResultsError` if the Team does not exist.

  ## Examples

      iex> get_team!(123)
      %Team{}

      iex> get_team!(456)
      ** (Ecto.NoResultsError)

  """
  def get_team!(id), do: Repo.get!(Team, id)

  def get_team_by_players(%{player_1_id: player_1_id, player_2_id: player_2_id}) do
    query =
      from t in Team,
        where: t.player_1_id == ^player_1_id and t.player_2_id == ^player_2_id,
        select: t

    query
    |> Repo.one()
    |> case do
      nil -> {:error, :not_found}
      found -> {:ok, found}
    end
  end

  @doc """
  Creates a team.

  ## Examples

      iex> create_team(%{field: value})
      {:ok, %Team{}}

      iex> create_team(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_team(attrs \\ %{}) do
    %Team{}
    |> Team.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a team.

  ## Examples

      iex> update_team(team, %{field: new_value})
      {:ok, %Team{}}

      iex> update_team(team, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_team(%Team{} = team, attrs) do
    team
    |> Team.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a team.

  ## Examples

      iex> delete_team(team)
      {:ok, %Team{}}

      iex> delete_team(team)
      {:error, %Ecto.Changeset{}}

  """
  def delete_team(%Team{} = team) do
    Repo.delete(team)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking team changes.

  ## Examples

      iex> change_team(team)
      %Ecto.Changeset{data: %Team{}}

  """
  def change_team(%Team{} = team, attrs \\ %{}) do
    Team.changeset(team, attrs)
  end

  @doc """
  Returns the list of player_match_results.

  ## Examples

      iex> list_player_match_results()
      [%PlayerMatchResult{}, ...]

  """
  def list_player_match_results do
    Repo.all(PlayerMatchResult)
  end

  @doc """
  Gets a single player_match_result.

  Raises `Ecto.NoResultsError` if the Player match result does not exist.

  ## Examples

      iex> get_player_match_result!(123)
      %PlayerMatchResult{}

      iex> get_player_match_result!(456)
      ** (Ecto.NoResultsError)

  """
  def get_player_match_result!(id), do: Repo.get!(PlayerMatchResult, id)

  @doc """
  Creates a player_match_result.

  ## Examples

      iex> create_player_match_result(%{field: value})
      {:ok, %PlayerMatchResult{}}

      iex> create_player_match_result(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_player_match_result(attrs \\ %{}) do
    %PlayerMatchResult{}
    |> PlayerMatchResult.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a player_match_result.

  ## Examples

      iex> update_player_match_result(player_match_result, %{field: new_value})
      {:ok, %PlayerMatchResult{}}

      iex> update_player_match_result(player_match_result, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_player_match_result(%PlayerMatchResult{} = player_match_result, attrs) do
    player_match_result
    |> PlayerMatchResult.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a player_match_result.

  ## Examples

      iex> delete_player_match_result(player_match_result)
      {:ok, %PlayerMatchResult{}}

      iex> delete_player_match_result(player_match_result)
      {:error, %Ecto.Changeset{}}

  """
  def delete_player_match_result(%PlayerMatchResult{} = player_match_result) do
    Repo.delete(player_match_result)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking player_match_result changes.

  ## Examples

      iex> change_player_match_result(player_match_result)
      %Ecto.Changeset{data: %PlayerMatchResult{}}

  """
  def change_player_match_result(%PlayerMatchResult{} = player_match_result, attrs \\ %{}) do
    PlayerMatchResult.changeset(player_match_result, attrs)
  end

  @doc """
  Returns the list of team_match_results.

  ## Examples

      iex> list_team_match_results()
      [%TeamMatchResult{}, ...]

  """
  def list_team_match_results do
    Repo.all(TeamMatchResult)
  end

  @doc """
  Gets a single team_match_result.

  Raises `Ecto.NoResultsError` if the Team match result does not exist.

  ## Examples

      iex> get_team_match_result!(123)
      %TeamMatchResult{}

      iex> get_team_match_result!(456)
      ** (Ecto.NoResultsError)

  """
  def get_team_match_result!(id), do: Repo.get!(TeamMatchResult, id)

  @doc """
  Creates a team_match_result.

  ## Examples

      iex> create_team_match_result(%{field: value})
      {:ok, %TeamMatchResult{}}

      iex> create_team_match_result(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_team_match_result(attrs \\ %{}) do
    %TeamMatchResult{}
    |> TeamMatchResult.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a team_match_result.

  ## Examples

      iex> update_team_match_result(team_match_result, %{field: new_value})
      {:ok, %TeamMatchResult{}}

      iex> update_team_match_result(team_match_result, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_team_match_result(%TeamMatchResult{} = team_match_result, attrs) do
    team_match_result
    |> TeamMatchResult.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a team_match_result.

  ## Examples

      iex> delete_team_match_result(team_match_result)
      {:ok, %TeamMatchResult{}}

      iex> delete_team_match_result(team_match_result)
      {:error, %Ecto.Changeset{}}

  """
  def delete_team_match_result(%TeamMatchResult{} = team_match_result) do
    Repo.delete(team_match_result)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking team_match_result changes.

  ## Examples

      iex> change_team_match_result(team_match_result)
      %Ecto.Changeset{data: %TeamMatchResult{}}

  """
  def change_team_match_result(%TeamMatchResult{} = team_match_result, attrs \\ %{}) do
    TeamMatchResult.changeset(team_match_result, attrs)
  end
end
