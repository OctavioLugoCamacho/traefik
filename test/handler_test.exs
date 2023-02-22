defmodule Traefik.HandlerTest do
  use ExUnit.Case

  alias Traefik.Handler

  test "GET /hello" do
    request = """
    GET /hello HTTP/1.1
    Accept: */*
    Connection: keep-alive
    User-Agent: telnet


    """

    response = Handler.handle(request)

    assert response == """
           HTTP/1.1 200 OK
           Host: some.com
           User-Agent: telnet
           Content-Lenght: 13
           Accept: */*
           Hello World!😎
           """
  end

  test "GET /world" do
    request = """
    GET /world HTTP/1.1
    Accept: */*
    Connection: keep-alive
    User-Agent: telnet


    """

    response = Handler.handle(request)

    assert response == """
           HTTP/1.1 200 OK
           Host: some.com
           User-Agent: telnet
           Content-Lenght: 18
           Accept: */*
           Hello MakingDevs!🤓
           """
  end

  test "GET /not-found" do
    request = """
    GET /not-found HTTP/1.1
    Accept: */*
    Connection: keep-alive
    User-Agent: telnet


    """

    response = Handler.handle(request)

    assert response == """
           HTTP/1.1 404 Not Found
           Host: some.com
           User-Agent: telnet
           Content-Lenght: 21
           Accept: */*
           No /not-found found!😰
           """
  end

  test "GET /redirectme" do
    request = """
    GET /redirectme HTTP/1.1
    Accept: */*
    Connection: keep-alive
    User-Agent: telnet


    """

    response = Handler.handle(request)

    assert response == """
           HTTP/1.1 404 Not Found
           Host: some.com
           User-Agent: telnet
           Content-Lenght: 15
           Accept: */*
           No /all found!😰
           """
  end

  test "GET /about" do
    request = """
    GET /about HTTP/1.1
    Accept: */*
    Connection: keep-alive
    User-Agent: telnet


    """

    response = Handler.handle(request)

    assert response == """
    HTTP/1.1 200 OK
    Host: some.com
    User-Agent: telnet
    Content-Lenght: 140
    Accept: */*
    <h1>Octavio Test</h1>
    <p>
    <blockquote>My favorite bands!</blockquote>
    <ul>
    <li>Ghost</li>
    <li>Metallica</li>
    <li>Amon Amarth</li>
    </ul>
    </p>
    """
  end

  test "POST /new" do
    request = """
    POST /new HTTP/1.1
    Accept: */*
    Connection: keep-alive
    Content-Type: application/x-www-form-urlencoded
    User-Agent: telnet

    name=Octavio&company=MakingDevs
    """

    response = Handler.handle(request)

    assert response == """
           HTTP/1.1 201 Created
           Host: some.com
           User-Agent: telnet
           Content-Lenght: 46
           Accept: */*
           New element created: Octavio from MakingDevs
           🆗
           """
  end

  test "GET /developer" do
    request = """
    GET /developer HTTP/1.1
    Accept: */*
    Connection: keep-alive
    Content-Type: application/x-www-form-urlencoded
    User-Agent: telnet

    """

    response = Handler.handle(request)

    assert response == """
           HTTP/1.1 200 OK
           Host: some.com
           User-Agent: telnet
           Content-Lenght: 158
           Accept: */*
           <ul>

           <li>1 - Jerri Rubertis</li>

           <li>2 - Lief Gepson</li>

           <li>3 - Viki Van Halle</li>

           <li>4 - Maribelle Dubose</li>

           <li>5 - Vivian Klarzynski</li>

           </ul>
           """
  end

  test "GET /developer/18" do
    request = """
    GET /developer/17 HTTP/1.1
    Accept: */*
    Connection: keep-alive
    Content-Type: application/x-www-form-urlencoded
    User-Agent: telnet

    """

    response = Handler.handle(request)

    assert response == """
           HTTP/1.1 200 OK
           Host: some.com
           User-Agent: telnet
           Content-Lenght: 52
           Accept: */*
           17 - Slade - Sams - ssamsg@ucoz.com - 157.180.106.51
           """
  end
end
