defmodule Traefik.Handler do
  def handle(request) do
    request
    |> parse()
    |> rewrite_path()
    |> log()
    |> route()
    |> format_response()
  end

  def parse(request) do
    [method, path, _protocol] =
      request
      |> String.split("\n")
      |> List.first()
      |> String.split(" ")

    %{method: method, path: path, response: "", status: nil}
  end

  def rewrite_path(%{path: "/redirectme"} = conn) do
    %{conn | path: "/all"}
  end

  def rewrite_path(conn), do: conn

  def log(conn), do: IO.inspect(conn, label: "Logger")

  def route(conn) do
    route(conn, conn.method, conn.path)
  end

  def route(conn, "GET", "/hello") do
    %{ conn | status: 200, response: "Hello World!😎"}
  end

  def route(conn, "GET", "/world") do
    %{ conn | status: 200, response: "Hello MakingDevs!🤓"}
  end

  def route(conn, "GET", "/all") do
    %{conn | status: 200, response: "All developers greetings!🤙"}
  end

  def route(conn, _method, path) do
    %{ conn | status: 404, response: "No #{path} found!😰"}
  end

  def format_response(conn) do
    """
    HTTP/1.1 #{conn.status} #{status_reason(conn.status)}
    Host: some.com
    User-Agent: telnet
    Content-Lenght: #{String.length(conn.response)}
    Accept: */*
    #{conn.response}
    """
  end

  defp status_reason(code) do
    %{
      200 => "OK",
      201 => "Created",
      401 => "Unauthorized",
      403 => "Forbbiden",
      404 => "Not found",
      500 => "Internal Error"
    }
    |> Map.get(code)
  end
end

request_1 = """
GET /hello HTTP/1.1
Accept: */*
Connection: keep-alive
User-Agent: telnet
"""

request_2 = """
GET /world HTTP/1.1
Accept: */*
Connection: keep-alive
User-Agent: telnet
"""

request_3 = """
GET /not-found HTTP/1.1
Accept: */*
Connection: keep-alive
User-Agent: telnet
"""

request_4 = """
GET /redirectme HTTP/1.1
Accept: */*
Connection: keep-alive
User-Agent: telnet
"""

IO.puts(Traefik.Handler.handle(request_1))
IO.puts("\n")
IO.puts(Traefik.Handler.handle(request_2))
IO.puts("\n")
IO.puts(Traefik.Handler.handle(request_3))
IO.puts("\n")
IO.puts(Traefik.Handler.handle(request_4))
