defmodule PistaWeb.HomeLive do
  use PistaWeb, :live_view

  require Logger

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    hi
    """
  end
end
