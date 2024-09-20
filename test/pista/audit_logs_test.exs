defmodule Pista.AuditLogsTest do
  use Pista.DataCase

  alias Pista.AuditLogs

  describe "audit_logs" do
    alias Pista.AuditLogs.AuditLog

    import Pista.AuditLogsFixtures

    @invalid_attrs %{event_name: nil}

    test "list_audit_logs/0 returns all audit_logs" do
      _audit_log = audit_log_fixture()
      refute Enum.empty?(AuditLogs.list_audit_logs())
    end

    test "get_audit_log!/1 returns the audit_log with given id" do
      audit_log = audit_log_fixture()
      assert AuditLogs.get_audit_log!(audit_log.id) == audit_log
    end

    test "create_audit_log/1 with valid data creates a audit_log" do
      valid_attrs = %{event_name: "some event_name"}

      assert {:ok, %AuditLog{} = audit_log} = AuditLogs.create_audit_log(valid_attrs)
      assert audit_log.event_name == "some event_name"
    end

    test "create_audit_log/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = AuditLogs.create_audit_log(@invalid_attrs)
    end

    test "update_audit_log/2 with valid data updates the audit_log" do
      audit_log = audit_log_fixture()
      update_attrs = %{event_name: "some updated event_name"}

      assert {:ok, %AuditLog{} = audit_log} = AuditLogs.update_audit_log(audit_log, update_attrs)
      assert audit_log.event_name == "some updated event_name"
    end

    test "update_audit_log/2 with invalid data returns error changeset" do
      audit_log = audit_log_fixture()
      assert {:error, %Ecto.Changeset{}} = AuditLogs.update_audit_log(audit_log, @invalid_attrs)
      assert audit_log == AuditLogs.get_audit_log!(audit_log.id)
    end

    test "delete_audit_log/1 deletes the audit_log" do
      audit_log = audit_log_fixture()
      assert {:ok, %AuditLog{}} = AuditLogs.delete_audit_log(audit_log)
      assert_raise Ecto.NoResultsError, fn -> AuditLogs.get_audit_log!(audit_log.id) end
    end

    test "change_audit_log/1 returns a audit_log changeset" do
      audit_log = audit_log_fixture()
      assert %Ecto.Changeset{} = AuditLogs.change_audit_log(audit_log)
    end
  end
end
