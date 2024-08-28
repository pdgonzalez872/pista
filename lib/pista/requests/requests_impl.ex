defmodule Pista.RequestsReqImpl do
  @behaviour Pista.RequestsBehaviour

  @impl true
  def get(url) do
    Req.get(url)
  end

  @impl true
  def post_fip(body) do
    Req.post("https://www.padelfip.com/wp-admin/admin-ajax.php",
      headers: [
        {"User-Agent",
         "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:122.0) Gecko/20100101 Firefox/122.0"},
        {"Accept", "*/*"},
        {"Accept-Language", "en-US,en;q=0.5"},
        {"Accept-Encoding", "gzip, deflate, br"},
        {"Content-Type", "application/x-www-form-urlencoded; charset=UTF-8"},
        {"Origin", "null"},
        {"DNT", "1"},
        {"Connection", "keep-alive"},
        {"Sec-Fetch-Dest", "empty"},
        {"Sec-Fetch-Mode", "cors"},
        {"Sec-Fetch-Site", "cross-site"},
        {"TE", "trailers"}
      ],
      body: body
    )
  end
end
