defmodule Pista.AuditLogsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Pista.AuditLogs` context.
  """

  @doc """
  Generate a audit_log.
  """
  def audit_log_fixture(attrs \\ %{}) do
    {:ok, audit_log} =
      attrs
      |> Enum.into(%{
        event_name: "some event_name"
      })
      |> Pista.AuditLogs.create_audit_log()

    audit_log
  end
end
