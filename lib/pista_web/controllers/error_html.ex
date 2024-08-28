defmodule PistaWeb.ErrorHTML do
  use PistaWeb, :html

  # If you want to customize your error pages,
  # uncomment the embed_templates/1 call below
  # and add pages to the error directory:
  #
  #   * lib/pista_web/controllers/error_html/404.html.heex
  #   * lib/pista_web/controllers/error_html/500.html.heex
  #
  embed_templates "error_html/*"

  def render(template, _assigns) do
    Phoenix.Controller.status_message_from_template(template)
  end
end
