defmodule PistaWeb.HomeLive do
  # In Phoenix v1.6+ apps, the line is typically: use MyAppWeb, :live_view
  use Phoenix.LiveView

  require Logger

  def mount(_params, _session, socket) do
    # Logger.info("Handling first mount, full html page")

    if connected?(socket) do
      Logger.info("Handling second mount, connected mount")
      :timer.send_interval(:timer.minutes(1), self(), :tick)
    end

    socket = assign_state(socket)
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="relative isolate pt-14">
      <div
        class="absolute inset-x-0 -top-40 -z-10 transform-gpu overflow-hidden blur-3xl sm:-top-80"
        aria-hidden="true"
      >
      </div>
      <div class="py-24 sm:py-32 lg:pb-40">
        <div class="mx-auto max-w-7xl px-6 lg:px-8">
          <div class="mx-auto max-w-2xl text-center">
            <a href="/">
              <img
                class="col-span-2 max-h-16 w-full object-contain lg:col-span-1"
                src="/images/pista_1.jpeg"
                alt="Pista"
                width="158"
                height="48"
              />
            </a>
            <p class="mt-6 text-sm leading-8 text-gray-400">
              Professional Padel focused content
            </p>
            <p class="mt-6 text-base leading-8 text-gray-600">Brought to you by</p>

            <div class="py-3">
              <a
                phx-click="sponsors"
                phx-value-sponsor="hcasports"
                href="https://hcasports.com"
                target="_blank"
              >
                <img
                  class="col-span-2 max-h-16 w-full object-contain lg:col-span-1"
                  src="/images/hcasports.jpeg"
                  alt="Home Court Advantage"
                  width="158"
                  height="48"
                />
              </a>
            </div>

            <div class="py-1">
              <a
                phx-click="sponsors"
                phx-value-sponsor="cata_brand"
                href="https://www.instagram.com/cata.brand"
                target="_blank"
              >
                <img
                  class="col-span-2 max-h-24 w-full object-contain lg:col-span-1"
                  src="/images/cata_brand.jpeg"
                  alt="Cata Brand"
                  width="158"
                  height="48"
                />
              </a>
            </div>

            <div class="py-6">
              <a
                phx-click="sponsors"
                phx-value-sponsor="real_turf"
                href="https://realturf.com/us"
                target="_blank"
              >
                <img
                  class="col-span-2 max-h-16 w-full object-contain lg:col-span-1"
                  src="/images/real_turf.jpeg"
                  alt="Reform"
                  width="158"
                  height="48"
                />
              </a>
            </div>

            <p class="mt-6 text-base leading-8 text-gray-600">Sending ❤️  from the 🇺🇸</p>
          </div>

          <div class="py-12 lg:pb-40">
            <div class="mx-auto max-w-7xl px-6 lg:px-8">
              <%= list_tournaments_helper(
                @socket.assigns,
                @current_tournaments,
                "Current Tournaments",
                "",
                true
              ) %>

              <div class="py-6 mx-auto max-w-2xl text-center">
                <h1 class="text-2xl font-bold tracking-tight text-gray-900">
                  <div>
                    <span class="text-indigo-600">
                      <%= Enum.count(@pro_leagues) %>
                    </span>
                    <span>
                      Padel Tours
                    </span>
                  </div>
                </h1>
              </div>

              <div class="mt-8 flow-root">
                <div class="-mx-3 -my-2 overflow-x-auto sm:-mx-6 lg:-mx-8">
                  <div class="inline-block min-w-full py-2 align-middle sm:px-6 lg:px-8">
                    <table class="min-w-full divide-y divide-gray-300">
                      <thead>
                        <tr>
                          <th
                            scope="col"
                            class="py-3.5 pl-4 pr-3 text-center text-sm font-semibold text-gray-900 sm:pl-0"
                          >
                            Name
                          </th>
                          <th
                            scope="col"
                            class="px-3 py-3.5 text-center text-sm font-semibold text-gray-900"
                          >
                            Schedule and Tournaments
                          </th>
                        </tr>
                      </thead>
                      <tbody class="divide-y divide-gray-200">
                        <%= for pro_league <- @pro_leagues do %>
                          <%= list_pro_league_helper(
                            @socket.assigns,
                            pro_league.name,
                            pro_league.url,
                            pro_league.schedule_link,
                            pro_league.tournaments_link
                          ) %>
                        <% end %>
                      </tbody>
                    </table>

                    <a href="mailto:contact@pista.cloud?subject=Pista%20|%20Suggestions&body=Hi!">
                      <p class="py-4 mt-2 text-center text-base leading-8 text-gray-600">
                        (Something missing? Email us! ✉️)
                      </p>
                    </a>
                  </div>
                </div>
              </div>

              <div class="py-6 mx-auto max-w-2xl text-center">
                <h1 class="text-2xl font-bold tracking-tight text-gray-900">
                  <div>
                    <span class="text-teal-600">
                      Livestreams:
                    </span>
                    <span class="text-indigo-600">
                      <%= Enum.count(@padel_embeds) %>
                    </span>
                    <span>
                      on YouTube
                    </span>

                    <span class="text-indigo-600">
                      out of <%= @livestream_sources_count %> sources
                    </span>
                  </div>
                </h1>
              </div>

              <div class="my-5 text-base text-black-400 max-w-prose mx-auto lg:max-w-none">
                <div class="px-3 sm:px-6 lg:px-8">
                  <%= if Enum.empty?(@padel_embeds) do %>
                    <p class="py-10 mt-6 text-center text-base leading-8 text-gray-600">
                      None at the moment!
                    </p>
                  <% else %>
                    <%= if @diplay_click_full_screen_notice do %>
                      <p class="py-6 mt-6 text-center text-base text-gray-600">
                        <%= @click_full_screen_notice %>
                      </p>
                    <% end %>
                    <div class="my-5 text-base text-black-400 max-w-prose mx-auto lg:max-w-none">
                      <ul>
                        <%= for embed <- @padel_embeds do %>
                          <%= if embed.channel_name == "@PremierPadelTV" do %>
                            <p class="py-3 mt-6 text-center text-base leading-8 text-gray-600">
                              <span>
                                This is live, but you have to watch this on
                                <a
                                  href={embed.url}
                                  class="font-medium text-indigo-600 hover:text-indigo-500 md:block"
                                  target="_blank"
                                >
                                  YouTube directly
                                </a>
                                (<%= embed.channel_name %>'s preferences)
                              </span>
                            </p>
                          <% else %>
                            <li class="my-5">
                              <iframe
                                class="w-full aspect-video"
                                src={embed.embed_url}
                                title="YouTube video player"
                                frameborder="0"
                                allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share"
                                allowfullscreen
                              >
                              </iframe>
                            </li>
                          <% end %>
                        <% end %>
                      </ul>
                    </div>
                  <% end %>
                </div>
              </div>

              <%= if @redbulltv_is_live do %>
                <!-- RedBullTv... -->
                <a href="https://www.redbull.com/int-en/event-series/premier-padel" target="_blank">
                  <div class="py-6 mx-auto max-w-2xl text-center">
                    <h1 class="text-2xl font-bold tracking-tight text-gray-900">
                      <div>
                        <span class="text-teal-600">
                          Livestreams:
                        </span>
                        <span>
                          RedBullTv is
                        </span>
                        <span class="text-red-600">
                          LIVE!
                        </span>
                        <span>
                          Click here to watch it.
                        </span>
                      </div>
                      <div>
                        <span></span>
                      </div>
                    </h1>
                  </div>
                </a>
              <% end %>
              <%= list_tournaments_helper(
                @socket.assigns,
                @upcoming_tournaments,
                "Upcoming Tournaments #{@today.year} #{@toggle_sign_upcoming_tournaments}",
                "upcoming_tournaments",
                @show_upcoming_tournaments
              ) %>

              <%= list_tournaments_helper(
                @socket.assigns,
                @past_tournaments,
                "Finished Tournaments #{@today.year} #{@toggle_sign_past_tournaments}",
                "past_tournaments",
                @show_past_tournaments
              ) %>
              <!-- end div ... -->

              <!-- Merch start... -->
              <div class="py-6 mx-auto max-w-2xl text-center">
                <h1 class="text-2xl font-bold tracking-tight text-gray-900">
                  <div>
                    <span class="text-indigo-600">
                      <%= Enum.count(@products) %>
                    </span>
                    <span>
                      Merch
                    </span>
                  </div>
                  <div>
                    <span></span>
                  </div>
                </h1>
              </div>

              <div class="md:flex md:items-center md:justify-between">
                <h2 class="font-bold tracking-tight text-gray-900">Trending products</h2>
                <a
                  href="https://pista.printify.me/products/1"
                  class="hidden text-sm font-medium text-indigo-600 hover:text-indigo-500 md:block"
                  target="_blank"
                >
                  Shop the collection <span aria-hidden="true"> &rarr;</span>
                </a>
              </div>

              <div class="mt-6 grid grid-cols-2 gap-x-4 gap-y-10 sm:gap-x-6 md:grid-cols-4 md:gap-y-0 lg:gap-x-8">
                <%= for product <- @products do %>
                  <%= list_product(
                    @socket.assigns,
                    product
                  ) %>
                <% end %>
              </div>

              <div class="mt-8 text-sm md:hidden">
                <a
                  href="https://pista.printify.me/products/1"
                  class="font-medium text-indigo-600 hover:text-indigo-500"
                  target="_blank"
                >
                  Shop the collection <span aria-hidden="true"> &rarr;</span>
                </a>
              </div>
              <!-- Merch end... -->
            </div>
          </div>
        </div>
      </div>
    </div>
    """
  end

  def handle_event("sponsors", %{"sponsor" => sponsor}, socket) do
    case sponsor in ["kc", "real_turf", "hcasports", "cata_brand"] do
      true ->
        Logger.info("User clicked on sponsor: #{sponsor}")
        Pista.AuditLogs.create_audit_log(%{event_name: "sponsors.outbound.click.#{sponsor}"})

      false ->
        Logger.warning("Unknown sponsor, maybe malicious: #{inspect(sponsor)}")
    end

    {:noreply, socket}
  end

  def handle_event("sponsors", params, socket) do
    Logger.warning("Unknown sponsor, weird payload: #{inspect(params)}")

    {:noreply, socket}
  end

  def handle_event("products", %{"product" => product}, socket) do
    Logger.info("User clicked on product: #{product}")
    Pista.AuditLogs.create_audit_log(%{event_name: "products.outbound.click.#{product}"})

    {:noreply, socket}
  end

  def handle_event("past_tournaments", _params, socket) do
    toggle_sign = get_toggle_sign(socket.assigns.show_past_tournaments)

    socket =
      socket
      |> assign(:show_past_tournaments, !socket.assigns.show_past_tournaments)
      |> assign(:toggle_sign_past_tournaments, toggle_sign)

    {:noreply, socket}
  end

  def handle_event("upcoming_tournaments", _params, socket) do
    toggle_sign = get_toggle_sign(socket.assigns.show_upcoming_tournaments)

    socket =
      socket
      |> assign(:show_upcoming_tournaments, !socket.assigns.show_upcoming_tournaments)
      |> assign(:toggle_sign_upcoming_tournaments, toggle_sign)

    {:noreply, socket}
  end

  def handle_info(:tick, socket) do
    Logger.info("Updating browser with latest data")

    {:noreply, assign_state(socket)}
  end

  defp list_tournaments_helper(assigns, tournaments, heading, click_event_name, show) do
    assigns =
      assigns
      |> assign(:tournaments, tournaments)
      |> assign(:heading, heading)
      |> assign(:click_event_name, click_event_name)
      |> assign(:show, show)

    ~H"""
    <div class="py-6 mx-auto max-w-2xl text-center">
      <h1 phx-click={@click_event_name} class="text-2xl font-bold tracking-tight text-gray-900">
        <div>
          <span class="text-indigo-600">
            <%= Enum.count(@tournaments) %>
          </span>
          <span>
            <%= @heading %>
          </span>
        </div>
      </h1>
    </div>

    <%= if Enum.empty?(@tournaments) do %>
      <p class="py-10 mt-6 text-center text-base leading-8 text-gray-600">
        None at the moment!
      </p>
    <% else %>
      <%= if @show do %>
        <div class="my-4 px-4 sm:px-6 lg:px-8">
          <div class="-mx-4 mt-8 overflow-hidden shadow ring-1 ring-black ring-opacity-5 sm:-mx-6 md:mx-0 md:rounded-lg">
            <table class="min-w-full divide-y divide-gray-300">
              <thead class="bg-gray-50">
                <tr>
                  <th
                    scope="col"
                    class="py-3.5 pl-4 pr-3 text-left text-sm font-semibold text-gray-900 sm:pl-6"
                  >
                    Name
                  </th>
                  <th
                    scope="col"
                    class="px-3 py-3.5 text-left text-sm font-semibold text-gray-900 lg:table-cell"
                  >
                    Draws
                  </th>
                  <th
                    scope="col"
                    class="hidden px-3 py-3.5 text-left text-sm font-semibold text-gray-900 lg:table-cell"
                  >
                    Dates
                  </th>
                  <th scope="col" class="px-3 py-3.5 text-left text-sm font-semibold text-gray-900">
                    Country
                  </th>
                </tr>
              </thead>

              <tbody class="divide-y divide-gray-200 bg-white">
                <%= for tournament <- @tournaments do %>
                  <tr>
                    <td class="w-full max-w-0 py-4 pl-4 pr-3 text-sm font-medium text-indigo-400 sm:w-auto sm:max-w-none sm:pl-6">
                      <a href={tournament.url} target="_blank">
                        <%= "(#{tournament.tour}) #{tournament.event_name}" %>

                        <dl class="font-normal lg:hidden">
                          <dt class="sr-only">Start Date</dt>
                          <dd class="mt-1 truncate text-gray-700">
                            <%= "#{tournament.start_date.month}/#{tournament.start_date.day} - #{tournament.end_date.month}/#{tournament.end_date.day}" %>
                          </dd>
                          <dt class="sr-only sm:hidden">End Date</dt>
                          <dd class="mt-1 truncate text-gray-500 sm:hidden">
                            <%= tournament.tournament_grade %>
                          </dd>
                        </dl>
                      </a>
                    </td>

                    <td class="px-3 py-4 text-sm text-gray-500 lg:table-cell">
                      <a href={tournament.draws_url} target="_blank">
                        <img
                          class="col-span-2 max-h-16 object-contain lg:col-span-1"
                          src="/images/draw.png"
                          alt="Draw Ling"
                        />
                      </a>
                    </td>

                    <td class="hidden px-3 py-4 text-sm text-gray-500 lg:table-cell">
                      <%= "#{tournament.start_date.month}/#{tournament.start_date.day} - #{tournament.end_date.month}/#{tournament.end_date.day}" %>
                    </td>

                    <td class="px-3 py-4 text-sm text-gray-500">
                      <%= tournament.country %>
                    </td>
                  </tr>
                <% end %>
              </tbody>
            </table>
          </div>
        </div>
      <% end %>
    <% end %>
    """
  end

  defp list_product(assigns, product) do
    assigns = assign(assigns, :product, product)

    ~H"""
    <div class="group relative" phx-click="products" phx-value-product={@product.id}>
      <div class="h-56 w-full overflow-hidden rounded-md bg-gray-200 group-hover:opacity-75 lg:h-72 xl:h-80">
        <img
          src={@product.img_src}
          alt="Product"
          target="_blank"
          class="h-full w-full object-cover object-center"
        />
      </div>
      <h3 class="mt-4 text-sm text-center text-gray-700">
        <a href={@product.url} target="_blank">
          <span class="absolute inset-0"></span>
          <%= "#{@product.name}" %>
        </a>
      </h3>
    </div>
    """
  end

  defp list_pro_league_helper(assigns, name, url, schedule_link, tournaments_link) do
    assigns =
      assigns
      |> assign(:name, name)
      |> assign(:url, url)
      |> assign(:schedule_link, schedule_link)
      |> assign(:tournaments_link, tournaments_link)

    ~H"""
    <tr>
      <td class="whitespace-nowrap py-4 pl-4 pr-3 text-center text-sm font-medium text-gray-900 sm:pl-0">
        <a href={@url} target="_blank">
          <%= @name %>
        </a>
      </td>

      <td class="whitespace-nowrap px-3 py-4 text-center text-sm text-gray-500">
        <a href={@schedule_link} target="_blank">
          🗓️
        </a>
        |
        <a href={@tournaments_link} target="_blank">
          🏆
        </a>
      </td>
    </tr>
    """
  end

  defp assign_state(socket) do
    today = Date.utc_today()

    tournaments =
      Pista.Tournaments.list_tournaments()
      |> Enum.sort_by(fn t -> t.start_date end, {:asc, Date})

    grouped = tournaments |> Enum.group_by(fn t -> t.tour end)

    padel_embeds =
      Pista.Livestreams.list_active_padel_youtube_channel_livestreams()
      |> Enum.map(fn el ->
        %{channel_name: el.youtube_channel.name, embed_url: el.embed_url, url: el.url}
      end)

    current_tournaments =
      tournaments
      |> Enum.filter(fn t ->
        if Date.compare(t.start_date, t.end_date) == :gt do
          Logger.warning("Silly tournament with bad dates oh boy... #{t.event_name}...")
          false
        else
          today in Date.range(t.start_date, t.end_date)
        end
      end)

    upcoming_tournaments =
      tournaments
      |> Enum.filter(fn t ->
        case Date.compare(today, t.start_date) do
          :lt -> true
          _ -> false
        end
      end)

    past_tournaments = (tournaments -- upcoming_tournaments) -- current_tournaments
    past_tournaments = Enum.filter(past_tournaments, fn t -> today.year == t.end_date.year end)

    pro_leagues = [
      %{
        name: "Premier Padel",
        url: "https://premierpadel.com",
        schedule_link:
          "https://premierpadel.com/wp-content/themes/premierpadel/img/comming-soon-bg-dsk3.png",
        tournaments_link: "https://www.padelfip.com/calendar-premier-padel/?events-year=2024"
      },
      %{
        name: "FIP",
        url: "https://www.padelfip.com",
        schedule_link: "https://www.padelfip.com/calendar-cupra-fip-tour/?events-year=2024",
        tournaments_link: "https://www.padelfip.com/calendar-cupra-fip-tour/?events-year=2024"
      },
      %{
        name: "A1",
        url: "https://www.a1padelglobal.com/index.aspx?lang=EN",
        schedule_link: "https://www.a1padelglobal.com/calendario.aspx",
        tournaments_link: "https://www.a1padelglobal.com/torneos.aspx"
      },
      %{
        name: "UPT",
        url: "https://www.ultimatepadeltour.com",
        schedule_link: "https://www.ultimatepadeltour.com/#circuito",
        tournaments_link: "https://www.ultimatepadeltour.com/#torneos"
      }
    ]

    livestream_sources_count =
      Pista.Livestreams.list_youtube_channels_should_hydrate() |> Enum.count()

    products = [
      %{
        name: "Pronounced Padel T-Shirt",
        id: "pronounced_padel",
        url: "https://pista.printify.me/product/6531287/padel-unisex-moisture-wicking-tee",
        img_src:
          "https://images-api.printify.com/mockup/65f4acbc7e4ee53c3d051399/83037/72796/padel-unisex-moisture-wicking-tee_1710533979660.jpg?camera_label=front&s=400"
      },
      %{
        name: "Pista T-Shirt",
        id: "qr_code",
        url: "https://pista.printify.me/product/8747105/pista-padel-moisture-wicking-tee",
        img_src:
          "https://images-api.printify.com/mockup/665b69f7ea6a231d4a0e17fb/83024/72783/pista-padel-moisture-wicking-tee_1717267111425.jpg?camera_label=front&s=400"
      },
      %{
        name: "Pista Cap - Navy",
        id: "cap_navy",
        url: "https://pista.printify.me/product/8746763/pista-padel-baseball-cap",
        img_src:
          "https://images-api.printify.com/mockup/665b66f1827f135bf201c57a/104280/53890/pista-padel-baseball-cap_1717266278331.jpg?camera_label=front&s=400"
      },
      %{
        name: "Pista Cap - White",
        id: "cap_white",
        url: "https://pista.printify.me/product/8746914/pista-white-baseball-cap",
        img_src:
          "https://images-api.printify.com/mockup/665b689c1f7dc13919030daa/82434/53890/pista-white-baseball-cap_1717266626372.jpg?camera_label=front&s=400"
      },
      %{
        name: "Pista Cap - Dark Green",
        id: "cap_dark_green",
        url: "https://pista.printify.me/product/8746763/pista-padel-baseball-cap",
        img_src:
          "https://images-api.printify.com/mockup/665b66f1827f135bf201c57a/104279/53890/pista-padel-baseball-cap_1717266278331.jpg?camera_label=front&s=400"
      },
      %{
        name: "Pista Cap - Black",
        id: "cap_black",
        url: "https://pista.printify.me/product/8746763/pista-padel-baseball-cap",
        img_src:
          "https://images-api.printify.com/mockup/665b66f1827f135bf201c57a/104278/53890/pista-padel-baseball-cap_1717266278331.jpg?camera_label=front&s=400"
      }
    ]

    all_premier =
      Enum.all?(padel_embeds, fn embed ->
        embed.channel_name == "@PremierPadelTV"
      end)

    click_full_screen_notice =
      if all_premier do
        ""
      else
        "Click play on the livestream you want and click fullscreen!"
      end

    socket
    |> assign(:tournaments, tournaments)
    |> assign(:grouped, grouped)
    |> assign(:padel_embeds, padel_embeds)
    |> assign(:current_tournaments, current_tournaments)
    |> assign(:upcoming_tournaments, upcoming_tournaments)
    |> assign(:past_tournaments, past_tournaments)
    |> assign(:show_text, false)
    |> assign(:show_past_tournaments, Map.get(socket.assigns, :show_past_tournaments, false))
    |> assign(
      :show_upcoming_tournaments,
      Map.get(socket.assigns, :show_upcoming_tournaments, false)
    )
    |> assign(:toggle_sign_upcoming_tournaments, get_toggle_sign(true))
    |> assign(:toggle_sign_past_tournaments, get_toggle_sign(true))
    |> assign(:today, today)
    |> assign(:pro_leagues, pro_leagues)
    |> assign(:livestream_sources_count, livestream_sources_count)
    |> assign(:products, products)
    |> assign(:click_full_screen_notice, click_full_screen_notice)
    |> assign(:diplay_click_full_screen_notice, !all_premier)
    |> assign(:redbulltv_is_live, Pista.Livestreams.redbulltv_is_live?())
  end

  defp get_toggle_sign(should) do
    if should do
      "⇲"
    else
      "⇱"
    end
  end
end
