defmodule IpxWeb.PageController do
  use IpxWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
