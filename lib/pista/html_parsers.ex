defmodule Pista.HTMLParsers do
  @moduledoc """
  Context for HTML parsers. We use it quite a bit.

  Some of the parsers are simple, others are a bit more involved.

  All are tested somewhere, it's how sanity happened.
  """

  defdelegate parse_live_redbull_tv(args), to: Pista.HTMLParsers.LiveRedBullTvImpl, as: :call
  defdelegate parse_live_youtube_channel(args), to: Pista.HTMLParsers.LiveYoutubeImpl, as: :call

  defdelegate parse_results_fip(args), to: Pista.ResultsParsers.FIPImpl, as: :call

  defdelegate parse_results_fip_individual_ajax(args),
    to: Pista.ResultsParsers.FIPIndividualAjaxImpl,
    as: :call

  defdelegate parse_tournaments_a1(args), to: Pista.HTMLParsers.TournamentsA1Impl, as: :call

  defdelegate parse_tournaments_calendar_a1(args),
    to: Pista.HTMLParsers.TournamentsA1CalendarImpl,
    as: :call

  defdelegate parse_tournaments_a1_individual_tournament(args),
    to: Pista.HTMLParsers.TournamentsA1IndividualTournamentImpl,
    as: :call

  defdelegate parse_tournaments_fip(args), to: Pista.HTMLParsers.TournamentsFipImpl, as: :call
  defdelegate parse_tournaments_upt(args), to: Pista.HTMLParsers.TournamentsUPTImpl, as: :call

  defdelegate parse_tournaments_upt_individual_tournament(args),
    to: Pista.HTMLParsers.TournamentsUPTIndividualTournamentImpl,
    as: :call

  @deprecated "This is no longer used, WTP no longer a thing, but it was what was available at the time"
  defdelegate parse_results_wpt(args), to: Pista.ResultsParsers.WPTImpl, as: :call
end
