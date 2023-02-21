defmodule Traefik.DeveloperController do
  alias Traefik.Conn
  alias Traefik.Organization

  def index(%Conn{} = conn) do
    developers =
      Organization.list_developers()
      |> Enum.map(&("<li>#{&1.id} - #{&1.first_name}</li> "))
      |>Enum.join("\n")

    %{conn | response: developers}
  end
end
