defmodule PistaWeb.RedirectPlug do
  import Plug.Conn
  import Phoenix.Controller

  def init(opts) do
    opts
  end

  def call(conn, opts) do
    to = Keyword.get(opts, :to, "/")

    conn
    |> redirect(to: to)
    |> halt()
  end
end
