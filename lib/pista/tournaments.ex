defmodule Pista.Tournaments do
  @moduledoc """
  The Tournaments context.
  """

  import Ecto.Query

  alias Pista.Repo
  alias Pista.Tournaments.Tournament
  alias Pista.Tournaments.TournamentFetch
  alias Pista.Tournaments.TournamentDraw

  require Logger

  @targets [
    %{
      url: "https://www.padelfip.com/calendar-premier-padel/?events-year=2024",
      parse_fun: &Pista.HTMLParsers.parse_tournaments_fip/1
    },
    %{
      url: "https://www.padelfip.com/calendar-cupra-fip-tour/?events-year=2024",
      parse_fun: &Pista.HTMLParsers.parse_tournaments_fip/1
    },
    %{
      url: "https://www.padelfip.com/calendar-premier-padel/?events-year=2023",
      parse_fun: &Pista.HTMLParsers.parse_tournaments_fip/1
    },
    %{
      url: "https://www.padelfip.com/calendar-cupra-fip-tour/?events-year=2023",
      parse_fun: &Pista.HTMLParsers.parse_tournaments_fip/1
    },
    %{
      url: "https://www.a1padelglobal.com/torneos.aspx",
      parse_fun: &Pista.HTMLParsers.parse_tournaments_a1/1
    },
    %{
      url: "https://app.ultimatepadeltour.com/torneo.aspx",
      parse_fun: &Pista.HTMLParsers.parse_tournaments_upt/1
    }
  ]

  @doc """
  Returns the list of tournaments.

  ## Examples

      iex> list_tournaments()
      [%Tournament{}, ...]

  """
  def list_tournaments do
    Repo.all(Tournament)
  end

  @doc """
  Gets a single tournament.

  Raises `Ecto.NoResultsError` if the Tournament does not exist.

  ## Examples

      iex> get_tournament!(123)
      %Tournament{}

      iex> get_tournament!(456)
      ** (Ecto.NoResultsError)

  """
  def get_tournament!(id), do: Repo.get!(Tournament, id)

  def get_tournament(id), do: Repo.get(Tournament, id)

  def get_by_url(url) do
    query =
      from t in Tournament,
        where: t.url == ^url,
        select: t

    query
    |> Repo.one()
    |> case do
      nil -> :not_found
      found -> {:ok, found}
    end
  end

  def tournament_count() do
    Repo.one(from t in Tournament, select: count(t.id))
  end

  @doc """
  Creates a tournament.

  ## Examples

      iex> create_tournament(%{field: value})
      {:ok, %Tournament{}}

      iex> create_tournament(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_tournament(attrs \\ %{}) do
    %Tournament{}
    |> Tournament.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a tournament.

  ## Examples

      iex> update_tournament(tournament, %{field: new_value})
      {:ok, %Tournament{}}

      iex> update_tournament(tournament, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_tournament(%Tournament{} = tournament, attrs) do
    tournament
    |> Tournament.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a tournament.

  ## Examples

      iex> delete_tournament(tournament)
      {:ok, %Tournament{}}

      iex> delete_tournament(tournament)
      {:error, %Ecto.Changeset{}}

  """
  def delete_tournament(%Tournament{} = tournament) do
    Repo.delete(tournament)
  end

  def delete_all() do
    Repo.delete_all(Tournament)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking tournament changes.

  ## Examples

      iex> change_tournament(tournament)
      %Ecto.Changeset{data: %Tournament{}}

  """
  def change_tournament(%Tournament{} = tournament, attrs \\ %{}) do
    Tournament.changeset(tournament, attrs)
  end

  @doc """
  Returns the list of tournament_fetches.

  ## Examples

      iex> list_tournament_fetches()
      [%TournamentFetch{}, ...]

  """
  def list_tournament_fetches do
    Repo.all(TournamentFetch)
  end

  @doc """
  Gets a single tournament_fetch.

  Raises `Ecto.NoResultsError` if the Tournament fetch does not exist.

  ## Examples

      iex> get_tournament_fetch!(123)
      %TournamentFetch{}

      iex> get_tournament_fetch!(456)
      ** (Ecto.NoResultsError)

  """
  def get_tournament_fetch!(id), do: Repo.get!(TournamentFetch, id)

  @doc """
  Creates a tournament_fetch.

  ## Examples

      iex> create_tournament_fetch(%{field: value})
      {:ok, %TournamentFetch{}}

      iex> create_tournament_fetch(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_tournament_fetch(attrs \\ %{}) do
    %TournamentFetch{}
    |> TournamentFetch.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a tournament_fetch.

  ## Examples

      iex> update_tournament_fetch(tournament_fetch, %{field: new_value})
      {:ok, %TournamentFetch{}}

      iex> update_tournament_fetch(tournament_fetch, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_tournament_fetch(%TournamentFetch{} = tournament_fetch, attrs) do
    tournament_fetch
    |> TournamentFetch.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a tournament_fetch.

  ## Examples

      iex> delete_tournament_fetch(tournament_fetch)
      {:ok, %TournamentFetch{}}

      iex> delete_tournament_fetch(tournament_fetch)
      {:error, %Ecto.Changeset{}}

  """
  def delete_tournament_fetch(%TournamentFetch{} = tournament_fetch) do
    Repo.delete(tournament_fetch)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking tournament_fetch changes.

  ## Examples

      iex> change_tournament_fetch(tournament_fetch)
      %Ecto.Changeset{data: %TournamentFetch{}}

  """
  def change_tournament_fetch(%TournamentFetch{} = tournament_fetch, attrs \\ %{}) do
    TournamentFetch.changeset(tournament_fetch, attrs)
  end

  def fetch_tournaments() do
    today = Date.utc_today()

    query =
      from f in TournamentFetch,
        order_by: [desc: f.inserted_at],
        limit: 1

    query
    |> Repo.one()
    |> case do
      nil ->
        Logger.info(
          "Deleting existing tournaments, they change quite often and upserting is not worth it"
        )

        _ = Pista.Tournaments.delete_all()

        Logger.info("Fetching tournaments")
        _ = fetch_new_tournaments()
        {:ok, _} = create_tournament_fetch(%{fetch_date: today})

      tournament_fetch ->
        case Date.compare(tournament_fetch.fetch_date, today) do
          :lt ->
            Logger.info(
              "Deleting existing tournaments, they change quite often and upserting is not worth it"
            )

            _ = Pista.Tournaments.delete_all()

            Logger.info("Creating tournament fetch and fetching tournaments")
            _ = fetch_new_tournaments()
            {:ok, _} = create_tournament_fetch(%{fetch_date: today})

          _greater ->
            Logger.info("Already fetched tournaments today, skipping")
        end
    end
  end

  @doc """
  Tournaments.derive_url_and_update_tournament(tournament, :draws_url, Tournaments.derive_draws_url/1)
  """
  def derive_url_and_update_tournament(tournament, field, fun) do
    target = Map.get(tournament, :url)
    result = fun.(target)
    args = Map.put(%{}, field, result)
    update_tournament(tournament, args)
  end

  def derive_draws_url(nil) do
    "/"
  end

  def derive_draws_url(url) do
    cond do
      String.contains?(url, "ultimatepadeltour") ->
        String.replace(url, "torneosHYR.", "torneoscuadros.")

      String.contains?(url, "padelfip") ->
        result = url <> "/?tab=Draws"
        String.replace(result, "//?", "/?")

      String.contains?(url, "a1padelglobal") ->
        String.replace(url, "torneo.", "torneoCuadros.")

      true ->
        Logger.warning("Unable to derive_draws_url for: #{url}")

        url
    end
  end

  @doc """
  Returns the list of tournament_draws.

  ## Examples

      iex> list_tournament_draws()
      [%TournamentDraw{}, ...]

  """
  def list_tournament_draws do
    Repo.all(TournamentDraw)
  end

  @doc """
  Gets a single tournament_draw.

  Raises `Ecto.NoResultsError` if the Tournament draw does not exist.

  ## Examples

      iex> get_tournament_draw!(123)
      %TournamentDraw{}

      iex> get_tournament_draw!(456)
      ** (Ecto.NoResultsError)

  """
  def get_tournament_draw!(id), do: Repo.get!(TournamentDraw, id)

  def get_tournament_draw(id), do: Repo.get(TournamentDraw, id)

  @doc """
  Creates a tournament_draw.

  ## Examples

      iex> create_tournament_draw(%{field: value})
      {:ok, %TournamentDraw{}}

      iex> create_tournament_draw(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_tournament_draw(attrs \\ %{}) do
    %TournamentDraw{}
    |> TournamentDraw.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a tournament_draw.

  ## Examples

      iex> update_tournament_draw(tournament_draw, %{field: new_value})
      {:ok, %TournamentDraw{}}

      iex> update_tournament_draw(tournament_draw, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_tournament_draw(%TournamentDraw{} = tournament_draw, attrs) do
    tournament_draw
    |> TournamentDraw.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a tournament_draw.

  ## Examples

      iex> delete_tournament_draw(tournament_draw)
      {:ok, %TournamentDraw{}}

      iex> delete_tournament_draw(tournament_draw)
      {:error, %Ecto.Changeset{}}

  """
  def delete_tournament_draw(%TournamentDraw{} = tournament_draw) do
    Repo.delete(tournament_draw)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking tournament_draw changes.

  ## Examples

      iex> change_tournament_draw(tournament_draw)
      %Ecto.Changeset{data: %TournamentDraw{}}

  """
  def change_tournament_draw(%TournamentDraw{} = tournament_draw, attrs \\ %{}) do
    TournamentDraw.changeset(tournament_draw, attrs)
  end

  def get_tournament_draw_by_url(url) do
    query =
      from t in TournamentDraw,
        where: t.url == ^url,
        select: t

    query
    |> Repo.one()
    |> case do
      nil -> {:error, :not_found}
      found -> {:ok, found}
    end
  end

  def upsert_tournaments_draw(%{url: url} = args) do
    Logger.info("Upserting: #{url} url")

    query =
      from td in TournamentDraw,
        where: td.url == ^url,
        select: td

    query
    |> Repo.one()
    |> case do
      nil ->
        Logger.info("Upserting: #{url} not found, creating it")

        {:ok, created} =
          success =
          args
          |> Map.put(:status, "in_progress")
          |> create_tournament_draw()

        Logger.info("Upserting: #{url} success, created #{created.id} for #{url}")
        success

      found ->
        Logger.info("Upserting: #{url} found updating it")

        found
        |> update_tournament_draw(%{status: "active"})
        |> case do
          {:ok, _updated} = success ->
            Logger.info("Upserting: #{url} updated successfully")
            success

          error ->
            error
        end
    end
  end

  def fetch_new_tournaments() do
    Logger.info("Fetching new tournaments")

    tournaments =
      @targets
      |> Enum.flat_map(fn target -> handle_target(target) end)
      |> Enum.map(fn tournament ->
        with :not_found <- Pista.Tournaments.get_by_url(tournament.url),
             {:ok, _} = success <- Pista.Tournaments.create_tournament(tournament) do
          Logger.info("Success processing tournament: #{tournament.url}")

          Pista.AuditLogs.create_audit_log(%{event_name: "tournaments.create | #{tournament.url}"})

          success
        else
          {:ok, %Pista.Tournaments.Tournament{url: url}} ->
            Logger.info("Tournament already exists, url: #{inspect(url)}")

          error ->
            Logger.error("Error handling tournament: #{inspect(tournament)}")
            error
        end
      end)

    Logger.info("Got #{Enum.count(tournaments)} from this run")
    :ok
  end

  defp handle_target(%{url: url, parse_fun: parse_fun}) do
    with {:ok, html} <- fetch_tournaments(url),
         {:ok, tournaments} = _result <- parse_fun.(%{html_input: html}) do
      Logger.info("Got #{Enum.count(tournaments)} from this url (#{url})")
      tournaments
    else
      error ->
        Logger.info("Error: #{inspect(error)}")
        error
    end
  end

  defp fetch_tournaments(url) do
    {:ok, %{body: body} = _response} = Pista.Requests.get(url)

    {:ok, body}
  end
end
