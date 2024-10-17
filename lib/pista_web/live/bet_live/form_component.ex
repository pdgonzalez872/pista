defmodule PistaWeb.BetLive.FormComponent do
  use PistaWeb, :live_component

  alias Pista.Bets

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage bet records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="bet-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:private]} type="checkbox" label="Private" />
        <.input field={@form[:description]} type="text" label="Description" />
        <.input field={@form[:has_both_betting_sides]} type="checkbox" label="Has both betting sides" />
        <.input field={@form[:settled]} type="checkbox" label="Settled" />
        <.input field={@form[:outcome_proof]} type="text" label="Outcome proof" />
        <.input field={@form[:bettor_a_pre_notes]} type="text" label="Bettor a pre notes" />
        <.input field={@form[:bettor_b_pre_notes]} type="text" label="Bettor b pre notes" />
        <.input field={@form[:bettor_a_post_notes]} type="text" label="Bettor a post notes" />
        <.input field={@form[:bettor_b_post_notes]} type="text" label="Bettor b post notes" />
        <.input field={@form[:winner_id]} type="text" label="Winner" />
        <.input field={@form[:bettor_a_id]} type="text" label="Bettor a" />
        <.input field={@form[:bettor_b_id]} type="text" label="Bettor b" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Bet</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{bet: bet} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Bets.change_bet(bet))
     end)}
  end

  @impl true
  def handle_event("validate", %{"bet" => bet_params}, socket) do
    changeset = Bets.change_bet(socket.assigns.bet, bet_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"bet" => bet_params}, socket) do
    save_bet(socket, socket.assigns.action, bet_params)
  end

  defp save_bet(socket, :edit, bet_params) do
    case Bets.update_bet(socket.assigns.bet, bet_params) do
      {:ok, bet} ->
        notify_parent({:saved, bet})

        {:noreply,
         socket
         |> put_flash(:info, "Bet updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_bet(socket, :new, bet_params) do
    dbg()
    case Bets.create_bet(bet_params) do
      {:ok, bet} ->
        notify_parent({:saved, bet})

        {:noreply,
         socket
         |> put_flash(:info, "Bet created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
