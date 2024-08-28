ExUnit.start(limit: :infinity)
Mox.defmock(Pista.RequestsMock, for: Pista.RequestsBehaviour)
Ecto.Adapters.SQL.Sandbox.mode(Pista.Repo, :manual)
