defmodule Pista.Workers.TournamentsWorker do
  use GenServer

  require Logger

  # Client

  def fetch_tournaments() do
    GenServer.call({:global, __MODULE__}, :fetch_tournaments)
  end

  # Server

  def start_link(_) do
    GenServer.start_link(__MODULE__, %{}, name: {:global, __MODULE__})
  end

  @impl true
  def init(state) do
    state = do_work(state)
    schedule_work()

    {:ok, state}
  end

  @impl true
  def handle_call(:fetch_tournaments, _from, state) do
    Logger.info("Inside Server, getting state")

    Logger.info("Server state: #{inspect(state)}")

    {:reply, state, state}
  end

  @impl true
  def handle_info(:work, state) do
    state = do_work(state)

    schedule_work()

    {:noreply, state}
  end

  defp schedule_work do
    Process.send_after(self(), :work, :timer.minutes(60))
  end

  defp do_work(_state) do
    Logger.info("Fetching new tournaments")
    _ = Pista.Tournaments.fetch_tournaments()
  end
end
