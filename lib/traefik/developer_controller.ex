defmodule Traefik.DeveloperController do
  alias Traefik.Conn
  alias Traefik.Organization

  def index(%Conn{} = conn) do
    developers =
      Organization.list_developers(%{limit: 5, offset: 2})
      |> Enum.map(&("<li>#{&1.id} - #{&1.first_name}</li> "))
      |>Enum.join("\n")

    developers =
      """
      <ul>
        #{developers}
      </ul>
      """

    %{conn | response: developers, status: 200}
  end
end
