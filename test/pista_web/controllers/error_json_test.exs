defmodule PistaWeb.ErrorJSONTest do
  use PistaWeb.ConnCase, async: true

  test "renders 404" do
    assert PistaWeb.ErrorJSON.render("404.json", %{}) == %{errors: %{detail: "Not Found"}}
  end

  test "renders 500" do
    assert PistaWeb.ErrorJSON.render("500.json", %{}) ==
             %{errors: %{detail: "Internal Server Error"}}
  end
end
