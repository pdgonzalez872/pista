defmodule Pista.Repo.Migrations.ChangeAuditLogsToText do
  use Ecto.Migration

  def change do
    alter table(:audit_logs) do
      modify :event_name, :text
    end
  end
end
