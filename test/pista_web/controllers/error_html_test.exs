defmodule PistaWeb.ErrorHTMLTest do
  use PistaWeb.ConnCase, async: true

  # Bring render_to_string/4 for testing custom views
  import Phoenix.Template

  test "renders 404.html" do
    assert String.contains?(render_to_string(PistaWeb.ErrorHTML, "404", "html", []), "Sorry")
  end

  test "renders 500.html" do
    assert render_to_string(PistaWeb.ErrorHTML, "500", "html", []) == "Internal Server Error"
  end
end
