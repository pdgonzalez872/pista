defmodule Pista.Livestreams do
  @moduledoc """
  The Livestreams context.
  """

  import Ecto.Query

  alias Pista.Livestreams.YoutubeChannel
  alias Pista.Livestreams.YoutubeChannelLivestream
  alias Pista.Livestreams.YoutubeChannelLivestreamFetches
  alias Pista.Repo

  require Logger

  @doc """
  Returns the list of youtube_channels.

  ## Examples

      iex> list_youtube_channels()
      [%YoutubeChannel{}, ...]

  """
  def list_youtube_channels do
    Repo.all(YoutubeChannel)
  end

  @doc """
  Gets a single youtube_channel.

  Raises `Ecto.NoResultsError` if the Youtube channel does not exist.

  ## Examples

      iex> get_youtube_channel!(123)
      %YoutubeChannel{}

      iex> get_youtube_channel!(456)
      ** (Ecto.NoResultsError)

  """
  def get_youtube_channel!(id), do: Repo.get!(YoutubeChannel, id)

  def get_youtube_channel(id) do
    YoutubeChannel
    |> Repo.get(id)
    |> case do
      nil -> {:error, "not found"}
      found -> {:ok, found}
    end
  end

  def upsert_youtube_channel_livestream_by_video_id(video_id, channel_name) do
    Logger.info("Upserting: #{video_id} video_id")

    channel = Repo.get_by(YoutubeChannel, name: channel_name)

    query =
      from ycl in YoutubeChannelLivestream,
        where: ycl.video_id == ^video_id,
        select: ycl

    query
    |> Repo.one()
    |> case do
      nil ->
        Logger.info("Upserting: #{video_id} not found, creating it")

        {:ok, created} =
          success =
          create_youtube_channel_livestream(%{
            video_id: video_id,
            status: "active",
            kind: "padel",
            youtube_channel_id: channel.id
          })

        Logger.info("Upserting: #{video_id} success, created #{created.id} for #{video_id}")
        success

      found ->
        Logger.info("Upserting: #{video_id} found updating it")

        found
        # potential issue with having orphan livestreams
        # |> update_youtube_channel_livestream(%{status: "active", youtube_channel_id: channel.id})
        |> update_youtube_channel_livestream(%{status: "active"})
        |> case do
          {:ok, _updated} = success ->
            Logger.info("Upserting: #{video_id} updated successfully")
            success

          error ->
            error
        end
    end
  end

  @doc """
  Creates a youtube_channel.

  ## Examples

      iex> create_youtube_channel(%{field: value})
      {:ok, %YoutubeChannel{}}

      iex> create_youtube_channel(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_youtube_channel(attrs \\ %{}) do
    %YoutubeChannel{}
    |> YoutubeChannel.changeset(attrs)
    |> Repo.insert()
    |> case do
      {:ok, created} = success ->
        Pista.AuditLogs.create_audit_log(%{event_name: "livestreams.create | #{created.name}"})
        success

      error ->
        error
    end
  end

  @doc """
  Updates a youtube_channel.

  ## Examples

      iex> update_youtube_channel(youtube_channel, %{field: new_value})
      {:ok, %YoutubeChannel{}}

      iex> update_youtube_channel(youtube_channel, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_youtube_channel(%YoutubeChannel{} = youtube_channel, attrs) do
    youtube_channel
    |> YoutubeChannel.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a youtube_channel.

  ## Examples

      iex> delete_youtube_channel(youtube_channel)
      {:ok, %YoutubeChannel{}}

      iex> delete_youtube_channel(youtube_channel)
      {:error, %Ecto.Changeset{}}

  """
  def delete_youtube_channel(%YoutubeChannel{} = youtube_channel) do
    Repo.delete(youtube_channel)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking youtube_channel changes.

  ## Examples

      iex> change_youtube_channel(youtube_channel)
      %Ecto.Changeset{data: %YoutubeChannel{}}

  """
  def change_youtube_channel(%YoutubeChannel{} = youtube_channel, attrs \\ %{}) do
    YoutubeChannel.changeset(youtube_channel, attrs)
  end

  def list_youtube_channels_should_hydrate() do
    query =
      from yc in YoutubeChannel,
        where: yc.should_hydrate == true,
        select: yc.name

    Repo.all(query)
  end

  @doc """
  Returns the list of youtube_channel_livestream_fetches.

  ## Examples

      iex> list_youtube_channel_livestream_fetches()
      [%YoutubeChannelLivestreamFetches{}, ...]

  """
  def list_youtube_channel_livestream_fetches do
    Repo.all(YoutubeChannelLivestreamFetches)
  end

  @doc """
  Gets a single youtube_channel_livestream_fetches.

  Raises `Ecto.NoResultsError` if the Youtube channel livestream fetches does not exist.

  ## Examples

      iex> get_youtube_channel_livestream_fetches!(123)
      %YoutubeChannelLivestreamFetches{}

      iex> get_youtube_channel_livestream_fetches!(456)
      ** (Ecto.NoResultsError)

  """
  def get_youtube_channel_livestream_fetches!(id),
    do: Repo.get!(YoutubeChannelLivestreamFetches, id)

  @doc """
  Creates a youtube_channel_livestream_fetches.

  ## Examples

      iex> create_youtube_channel_livestream_fetches(%{field: value})
      {:ok, %YoutubeChannelLivestreamFetches{}}

      iex> create_youtube_channel_livestream_fetches(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_youtube_channel_livestream_fetches(attrs \\ %{}) do
    %YoutubeChannelLivestreamFetches{}
    |> YoutubeChannelLivestreamFetches.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a youtube_channel_livestream_fetches.

  ## Examples

      iex> update_youtube_channel_livestream_fetches(youtube_channel_livestream_fetches, %{field: new_value})
      {:ok, %YoutubeChannelLivestreamFetches{}}

      iex> update_youtube_channel_livestream_fetches(youtube_channel_livestream_fetches, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_youtube_channel_livestream_fetches(
        %YoutubeChannelLivestreamFetches{} = youtube_channel_livestream_fetches,
        attrs
      ) do
    youtube_channel_livestream_fetches
    |> YoutubeChannelLivestreamFetches.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a youtube_channel_livestream_fetches.

  ## Examples

      iex> delete_youtube_channel_livestream_fetches(youtube_channel_livestream_fetches)
      {:ok, %YoutubeChannelLivestreamFetches{}}

      iex> delete_youtube_channel_livestream_fetches(youtube_channel_livestream_fetches)
      {:error, %Ecto.Changeset{}}

  """
  def delete_youtube_channel_livestream_fetches(
        %YoutubeChannelLivestreamFetches{} = youtube_channel_livestream_fetches
      ) do
    Repo.delete(youtube_channel_livestream_fetches)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking youtube_channel_livestream_fetches changes.

  ## Examples

      iex> change_youtube_channel_livestream_fetches(youtube_channel_livestream_fetches)
      %Ecto.Changeset{data: %YoutubeChannelLivestreamFetches{}}

  """
  def change_youtube_channel_livestream_fetches(
        %YoutubeChannelLivestreamFetches{} = youtube_channel_livestream_fetches,
        attrs \\ %{}
      ) do
    YoutubeChannelLivestreamFetches.changeset(youtube_channel_livestream_fetches, attrs)
  end

  @doc """
  Returns the list of youtube_channel_livestreams.

  ## Examples

      iex> list_youtube_channel_livestreams()
      [%YoutubeChannelLivestream{}, ...]

  """
  def list_youtube_channel_livestreams do
    Repo.all(YoutubeChannelLivestream)
  end

  def list_active_padel_youtube_channel_livestreams_embeds do
    query =
      from ycl in YoutubeChannelLivestream,
        where: ycl.status == "active" and ycl.kind == "padel",
        select: ycl.embed_url

    Repo.all(query)
  end

  def list_active_padel_youtube_channel_livestreams do
    query =
      from ycl in YoutubeChannelLivestream,
        where: ycl.status == "active" and ycl.kind == "padel",
        select: ycl,
        preload: :youtube_channel

    Repo.all(query, preload: [:youtube_channel])
  end

  def list_inactive_padel_youtube_channel_livestreams_embeds do
    query =
      from ycl in YoutubeChannelLivestream,
        where: ycl.status != "active" and ycl.kind == "padel",
        order_by: [desc: :inserted_at],
        select: ycl.embed_url

    Repo.all(query)
  end

  def list_active_others_youtube_channel_livestreams_embeds do
    query =
      from ycl in YoutubeChannelLivestream,
        where: ycl.status == "active" and ycl.kind != "padel",
        select: ycl.embed_url

    Repo.all(query)
  end

  def count_padel_livestreams() do
    query =
      from ycl in YoutubeChannelLivestream,
        where: ycl.status == "active" and ycl.kind == "padel",
        select: count(ycl.id)

    live = Repo.one(query)

    query =
      from ycl in YoutubeChannelLivestream,
        where: ycl.status != "active" and ycl.kind == "padel",
        select: count(ycl.id)

    not_live = Repo.one(query)
    {live, not_live}
  end

  @doc """
  Gets a single youtube_channel_livestream.

  Raises `Ecto.NoResultsError` if the Youtube channel livestream does not exist.

  ## Examples

      iex> get_youtube_channel_livestream!(123)
      %YoutubeChannelLivestream{}

      iex> get_youtube_channel_livestream!(456)
      ** (Ecto.NoResultsError)

  """
  def get_youtube_channel_livestream!(id), do: Repo.get!(YoutubeChannelLivestream, id)

  @doc """
  Creates a youtube_channel_livestream.

  ## Examples

      iex> create_youtube_channel_livestream(%{field: value})
      {:ok, %YoutubeChannelLivestream{}}

      iex> create_youtube_channel_livestream(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_youtube_channel_livestream(attrs \\ %{}) do
    %YoutubeChannelLivestream{}
    |> YoutubeChannelLivestream.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a youtube_channel_livestream.

  ## Examples

      iex> update_youtube_channel_livestream(youtube_channel_livestream, %{field: new_value})
      {:ok, %YoutubeChannelLivestream{}}

      iex> update_youtube_channel_livestream(youtube_channel_livestream, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_youtube_channel_livestream(
        %YoutubeChannelLivestream{} = youtube_channel_livestream,
        attrs
      ) do
    youtube_channel_livestream
    |> YoutubeChannelLivestream.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a youtube_channel_livestream.

  ## Examples

      iex> delete_youtube_channel_livestream(youtube_channel_livestream)
      {:ok, %YoutubeChannelLivestream{}}

      iex> delete_youtube_channel_livestream(youtube_channel_livestream)
      {:error, %Ecto.Changeset{}}

  """
  def delete_youtube_channel_livestream(%YoutubeChannelLivestream{} = youtube_channel_livestream) do
    Repo.delete(youtube_channel_livestream)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking youtube_channel_livestream changes.

  ## Examples

      iex> change_youtube_channel_livestream(youtube_channel_livestream)
      %Ecto.Changeset{data: %YoutubeChannelLivestream{}}

  """
  def change_youtube_channel_livestream(
        %YoutubeChannelLivestream{} = youtube_channel_livestream,
        attrs \\ %{}
      ) do
    YoutubeChannelLivestream.changeset(youtube_channel_livestream, attrs)
  end

  @doc """
  We are also deleting them from the database as they add no value.
  """
  def get_youtube_channel_livestream_by_embed_url_and_set_to_inactive(embed_url) do
    query =
      from ycl in YoutubeChannelLivestream,
        where: ycl.embed_url == ^embed_url,
        select: ycl

    query
    |> Pista.Repo.all()
    |> case do
      [] ->
        Logger.warning(
          "embed_url #{embed_url} not found. Must check how we got here, likely a bug"
        )

        :ok

      [found] ->
        Logger.info("Setting #{embed_url} (#{found.id}) to inactive")

        {:ok, _} =
          Pista.Livestreams.update_youtube_channel_livestream(found, %{status: "inactive"})

        delete_youtube_channel_livestream(found)

      # We get here when livestreams are scheduled and then rescheduled for the
      # next day, that's the theory at least.
      [_found | _dupe] = all ->
        Enum.each(all, fn found ->
          Logger.info("Setting #{embed_url} (#{found.id}) to inactive")

          {:ok, _} =
            Pista.Livestreams.update_youtube_channel_livestream(found, %{status: "inactive"})

          delete_youtube_channel_livestream(found)
        end)
    end
  end

  @doc """
  Why do we do this database dance? Because we started wanting to watch the
  replays of the livestreams so it was cool to keep around the records.

  Now, I don't think it matters much.
  """
  def handle_current_youtube_livestreams(state) do
    livestreams_current = check_live_youtube()

    livestreams_current_pretty =
      Enum.map(livestreams_current, fn %{embed_url: embed_url} -> embed_url end)

    active_livestreams_in_db =
      list_active_padel_youtube_channel_livestreams()
      |> Enum.map(fn l ->
        l.embed_url
      end)

    inactive_livestreams = active_livestreams_in_db -- livestreams_current

    _deletes =
      Enum.each(inactive_livestreams, fn embed_url ->
        get_youtube_channel_livestream_by_embed_url_and_set_to_inactive(embed_url)
      end)

    _updates =
      Enum.map(livestreams_current, fn el ->
        el.embed_url
        |> String.split("/", trim: true)
        |> Enum.at(-1)
        |> upsert_youtube_channel_livestream_by_video_id(el.channel_name)
      end)

    Pista.AuditLogs.create_audit_log(%{
      event_name:
        "livestreams.count | #{Enum.count(livestreams_current_pretty)}| #{Enum.join(livestreams_current_pretty, ":")}"
    })

    Map.put(state, :livestreams, livestreams_current)
  end

  def redbulltv_is_live?() do
    %{results: result} = check_live_redbull_tv_cache()
    # add scape hatch to be able to turn on with feature flag
    result || System.get_env("FLAGS_REDBULL") == "1"
  end

  def check_live_youtube() do
    Logger.info("Checking on YouTube livestreams")

    livestreams =
      Pista.Livestreams.list_youtube_channels_should_hydrate()
      |> Enum.map(fn c ->
        {:ok, %{body: html}} = Pista.Requests.get("https://www.youtube.com/#{c}")
        Pista.HTMLParsers.LiveYoutubeImpl.call(%{html_input: html, channel: c})
      end)
      |> List.flatten()
      |> Enum.map(fn el ->
        Map.put(el, :embed_url, "https://www.youtube.com/embed/#{el.video_id}")
      end)

    Logger.info("Finished getting livestreams, got #{Enum.count(livestreams)}")

    livestreams
  end

  def check_live_redbull_tv_cache() do
    Pista.Workers.LiveDetectorRedbullWorker.redbulltv_is_live?()
  end

  def check_live_redbull_tv() do
    Logger.info("Checking on RedBullTv livestreams")

    with {:ok, %{body: body}} <-
           Pista.Requests.get("https://www.redbull.com/int-en/event-series/premier-padel"),
         {:ok, %{results: result} = state} <-
           Pista.HTMLParsers.parse_live_redbull_tv(%{html_input: body}) do
      Logger.info("Checking on RedBullTv, is it live? -> #{inspect(result)}")
      state
    else
      error ->
        Logger.error("Error checking on RedBullTv: #{inspect(error)}")
        %{results: false}
    end
  end
end
