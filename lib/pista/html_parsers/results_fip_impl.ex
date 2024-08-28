defmodule Pista.ResultsParsers.FIPImpl do
  @moduledoc """
  The goal for this module is to extract a post_id for a given tournament

  And then, issue 4 calls to each of the draws
  """
  require Logger

  @behaviour Pista.HTMLParsers.HTMLParserBehaviour

  @impl true
  def call(%{html_input: html_input, tournament_id: tournament_id}) do
    action = "processing html"
    Logger.info("Start #{action}")

    with {:ok, document} <- Floki.parse_document(html_input),
         {:ok, %{"post_id" => post_id}} <- find_post_id(document),
         {:ok, responses} <- issue_draw_requests(post_id, tournament_id),
         {:ok, results} <- handle_responses(responses) do
      Logger.info("Success #{action} for post_id #{post_id}")

      {:ok, %{results: results}}
    else
      error ->
        Logger.error("Error #{action}: #{inspect(error)}")

        error
    end
  end

  defp find_post_id(document) do
    {_, _, [content]} =
      document
      |> Floki.find("script")
      |> Enum.find(fn {"script", _, [content]} -> String.contains?(content, "post_id") end)

    [_, target] = content |> String.split("=")

    Jason.decode(target)
  end

  defp issue_draw_requests(post_id, tournament_id) do
    results =
      [
        %{gender: "M", draw_kind: "D"},
        %{gender: "M", draw_kind: "Q"},
        %{gender: "W", draw_kind: "D"},
        %{gender: "W", draw_kind: "Q"}
      ]
      |> Enum.reduce([], fn %{gender: gender, draw_kind: draw_kind}, acc ->
        body =
          "action=handle_ajax_request&drawType=#{gender}#{draw_kind}&gender=#{gender}&postID=#{post_id}"

        with {:ok, response} <- Pista.Requests.post_fip(body),
             {:ok, td} <-
               Pista.Tournaments.upsert_tournaments_draw(%{
                 url: body,
                 tournament_id: tournament_id
               }) do
          # TODO: add the td.id here
          dbg(response)
          acc ++ [{response, td.id}]
        else
          {:error, _} ->
            Logger.error("Unable to get a draw for #{body}, skipping this draw")
            acc
        end
      end)

    {:ok, results}
  end

  defp handle_responses(responses) do
    results =
      Enum.reduce(responses, [], fn {response, tournament_draw_id}, acc ->
        {:ok, %{"html" => html}} = Jason.decode(response.body)

        case Pista.ResultsParsers.FIPIndividualAjaxImpl.call(%{
               html_input: html,
               tournament_draw_id: tournament_draw_id
             }) do
          {:ok, result} ->
            acc ++ [result]

          _error ->
            Logger.error("Unable to handle response, likely there is no HTML to parse")
            acc
        end
      end)

    {:ok, results}
  end
end
