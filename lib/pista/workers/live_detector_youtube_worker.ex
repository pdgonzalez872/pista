defmodule Pista.Workers.LiveDetectorYouTubeWorker do
  use GenServer

  require Logger

  # Client

  def get_livestreams() do
    GenServer.call({:global, __MODULE__}, :get_livestreams)
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
  def handle_call(:get_livestreams, _from, state) do
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
    Process.send_after(self(), :work, :timer.minutes(20))
  end

  defp do_work(state) do
    Pista.Livestreams.handle_current_youtube_livestreams(state)
  end
end
