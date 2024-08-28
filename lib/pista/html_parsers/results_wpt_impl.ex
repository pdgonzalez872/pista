defmodule Pista.ResultsParsers.WPTImpl do
  require Logger

  @behaviour Pista.HTMLParsers.HTMLParserBehaviour

  @impl true
  def call(%{html_input: html_input}) do
    action = "processing html"
    Logger.info("Start #{action}")

    with {:ok, document} <- parse_html(html_input),
         {:ok, results_data} <- find_results_data(document),
         {:ok, _result} = success <- get_matches(results_data) do
      Logger.info("Success #{action}")

      success
    else
      error ->
        Logger.error("Error #{action}: #{inspect(error)}")

        error
    end
  end

  defp parse_html(html_input) do
    Floki.parse_document(html_input)
  end

  defp find_results_data(document) do
    data = Floki.find(document, ".accordion-body .row")

    case Floki.text(data) do
      "" -> {:error, "Not able to find data in the html"}
      _found -> {:ok, data}
    end
  end

  defp get_matches(rows) do
    output =
      rows
      |> Enum.reduce(%{successes: [], errors: [], successes_count: 0, errors_count: 0}, fn row,
                                                                                           acc ->
        with {:ok, players} <- get_players(row),
             {:ok, score} <- get_score(row) do
          state =
            %{}
            |> Map.merge(players)
            |> Map.merge(score)

          Logger.info("Success building match result for #{inspect(state)}")

          acc
          |> Map.put(:successes, [state | acc.successes])
          |> Map.put(:successes_count, acc.successes_count + 1)
        else
          error ->
            acc
            |> Map.put(:errors, [error | acc.errors])
            |> Map.put(:errors_count, acc.errors_count + 1)
        end
      end)

    {:ok, output}
  end

  defp get_players(row) do
    row
    |> Floki.find(".names p")
    |> Enum.map(fn
      {_, _, [{_, [{"href", player_url}], [player_name]}]} ->
        output = %{player_url: player_url, player_name: String.trim(player_name)}

        Logger.info("Success getting player: #{inspect(output)}")
        output

      {_, _, [{_, [{"href", _placeholder_url}], [] = _indicates_no_name_but_existing_player}]} =
          input ->
        Logger.error(
          "Error getting players - existing player but no info - for row with input: #{inspect(input)}"
        )

        %{player_url: :no_name_player_url, player_name: :no_name_player_name}

      {_, _, ["Bye"]} =
          input ->
        Logger.warning("Bye round: #{inspect(input)}")

        %{player_url: :bye_round, player_name: :bye_round}

      input ->
        Logger.error("Error getting players for row with input: #{inspect(input)}")

        %{player_url: nil, player_name: nil}
    end)
    |> case do
      [player_team_a_1, player_team_a_2, player_team_b_1, player_team_b_2] = _all_players ->
        output = %{
          player_team_a_1: player_team_a_1,
          player_team_a_2: player_team_a_2,
          player_team_b_1: player_team_b_1,
          player_team_b_2: player_team_b_2
        }

        {:ok, output}

      [%{player_url: :bye_round, player_name: :bye_round}, player_team_b_1, player_team_b_2] =
          input ->
        msg =
          "Warning - Bye Round - incomplete 4 players - got #{Enum.count(input)} - with input: #{inspect(input)}"

        Logger.warning(msg)

        output = %{
          player_team_a_1: :bye_round,
          player_team_a_2: :bye_round,
          player_team_b_1: player_team_b_1,
          player_team_b_2: player_team_b_2
        }

        {:ok, output}

      [player_team_a_1, player_team_a_2, %{player_url: :bye_round, player_name: :bye_round}] =
          input ->
        msg =
          "Warning - Bye Round - incomplete 4 players - got #{Enum.count(input)} - with input: #{inspect(input)}"

        Logger.warning(msg)

        output = %{
          player_team_a_1: player_team_a_1,
          player_team_a_2: player_team_a_2,
          player_team_b_1: :bye_round,
          player_team_b_2: :bye_round
        }

        {:ok, output}

      input ->
        msg =
          "Error - incomplete 4 players - got #{Enum.count(input)} -  getting players with input: #{inspect(input)}"

        Logger.error(msg)

        {:error, msg}
    end
  end

  defp get_score(row) do
    [{_, _, [score]}] = Floki.find(row, ".b-results p")
    {:ok, %{score: score}}
  end
end
