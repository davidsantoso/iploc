defmodule IpxWeb.PageControllerTest do
  use IpxWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "Pinpoint Any IP Address"
  end
end
