defmodule Pista.Requests do
  def get(url) do
    impl().get(url)
  end

  def post_fip(body) do
    impl().post_fip(body)
  end

  defp impl do
    Application.get_env(:pista, :requests_impl)
  end
end
