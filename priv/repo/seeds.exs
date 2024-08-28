# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Pista.Repo.insert!(%Pista.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
_fun = fn ->
  [
    "@padelfip"
  ]
  |> Enum.each(fn name ->
    Pista.Livestreams.create_youtube_channel(%{name: name})
  end)
end

# fun.()
