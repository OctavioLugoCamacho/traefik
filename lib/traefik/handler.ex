defmodule Traefik.Handler do
  @moduledoc """
  Handles all the HTTP requests.
  """

  @files_path Path.expand("../../pages", __DIR__)

  import Traefik.Plugs, only: [rewrite_path: 1, log: 1, track: 1]
  import Traefik.Parser, only: [parse: 1]
  alias Traefik.Conn
  @doc """
  Handle a single request, transforms into response.
  """
  def handle(request) do
    request
    |> parse()
    |> rewrite_path()
    |> log()
    |> route()
    |> track()
    |> format_response()
  end

  def route(%Conn{} = conn) do
    route(conn, conn.method, conn.path)
  end

  def route(%Conn{} = conn, "GET", "/hello") do
    %{ conn | status: 200, response: "Hello World!😎"}
  end

  def route(%Conn{} = conn, "GET", "/world") do
    %{ conn | status: 200, response: "Hello MakingDevs!🤓"}
  end

  def route(%Conn{} = conn, "GET", "/all") do
    %{conn | status: 200, response: "All developers greetings!🤙"}
  end

  def route(%Conn{params: params} = conn, "POST", "/new") do
    %{
      conn
      | status: 201,
        response: "A new element created: #{params["name"]} from #{params["company"]} 🆗"
    }
  end

  def route(%Conn{} = conn, "GET", "/about") do
    @files_path
    |> Path.join("about.html")
    |> File.read()
    |> handle_file(conn)
  end

  def route(%Conn{} = conn, _method, path) do
    %{ conn | status: 404, response: "No #{path} found!😰"}
  end

  def handle_file({:ok, content}, %Conn{} = conn),
    do: %{conn | status: 200, response: content}

  def handle_file({:error, reason}, %Conn{} = conn),
    do: %{conn | status: 404, response: "File not found for #{inspect(reason)}"}

  # def route(conn, "GET", "/about") do
  #   Path.expand("../../pages", __DIR__)
  #   |> Path.join("about.html")
  #   |> File.read()
  #   |> case do
  #     {:ok, content} ->
  #       %{conn | status: 200, response: content}

  #     {:error, reason} ->
  #       %{conn | status: 404, response: "File not found for #{inspect(reason)}"}
  #   end
  # end

  def format_response(%Conn{} = conn) do
    """
    HTTP/1.1 #{Conn.status(conn)}
    Host: some.com
    User-Agent: telnet
    Content-Lenght: #{String.length(conn.response)}
    Accept: */*
    #{conn.response}
    """
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

request_5 = """
GET /about HTTP/1.1
Accept: */*
Connection: keep-alive
User-Agent: telnet


"""

request_6 = """
POST /new HTTP/1.1
Accept: */*
Connection: keep-alive
User-Agent: telnet

name=Juan&company=MakingDevs
"""

IO.puts(Traefik.Handler.handle(request_1))
IO.puts("\n")
IO.puts(Traefik.Handler.handle(request_2))
IO.puts("\n")
IO.puts(Traefik.Handler.handle(request_3))
IO.puts("\n")
IO.puts(Traefik.Handler.handle(request_4))
IO.puts("\n")
IO.puts(Traefik.Handler.handle(request_5))
IO.puts("\n")
IO.puts(Traefik.Handler.handle(request_6))
