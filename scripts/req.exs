Mix.install([
  {:req, "~> 0.3.4"}
])

defmodule Fetcher do
  def fetch do
    IO.puts("Starting fetch")

    headers = [
      {"User-Agent", "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:109.0) Gecko/20100101 Firefox/119.0"},
      {"Accept", "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8"},
      {"Accept-Language", "en-US,en;q=0.5"},
      {"Accept-Encoding", "gzip, deflate, br"},
      {"DNT", "1"},
      {"Connection", "keep-alive"},
      {"Cookie", "ci_session=e3b8d8634b81be0d529a07c593c3290bb963de9e; CookieConsent={stamp:%27xPVfaUYNBq2rJM/b1L5l/wFk2iMD9DnnnvRfEChktrSPtuaDld5OvA==%27%2Cnecessary:true%2Cpreferences:true%2Cstatistics:true%2Cmarketing:true%2Cmethod:%27explicit%27%2Cver:1%2Cutc:1700943182883%2Cregion:%27us%27}; _gcl_au=1.1.1878869129.1700943184"},
      {"Upgrade-Insecure-Requests", "1"},
      {"Sec-Fetch-Dest", "document"},
      {"Sec-Fetch-Mode", "navigate"},
      {"Sec-Fetch-Site", "cross-site"},
      {"Sec-GPC", "1"},
      {"TE", "trailers"}
    ]

    url = "https://worldpadeltour.com/torneos/skechers-mexico-padel-open-2023/2023?tab=results"

    case Req.get(url, headers: headers) do
      {:ok, %{body: body}} ->
        dbg(body)
        File.write!("output.html", body)
        IO.puts("Finished fetch, check output.html")
      {:error, reason} ->
        IO.puts("Error: #{inspect(reason)}")
    end
  end
end

Fetcher.fetch()
