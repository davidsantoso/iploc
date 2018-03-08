defmodule IpxWeb.IpControllerTest do
  use IpxWeb.ConnCase

  test "GETs an ip address", %{conn: conn} do
    conn = get conn, "/api/98.26.4.61"

    assert conn.resp_body =~ response_ip_98_26_4_61()
    assert conn.status == 200
  end

  test "handles lots of missing data for an ip", %{conn: conn} do
    conn = get conn, "/api/102.26.4.61"

    assert conn.resp_body =~ response_ip_102_26_4_61()
    assert conn.status == 200
  end

  defp response_ip_98_26_4_61() do
    %{
      time_zone: "America/New_York",
      region_name: "North Carolina",
      region_code: "NC",
      postal: "27704",
      network: "Time Warner Cable Internet LLC",
      longitude: -78.8391,
      latitude: 36.0355,
      ip: "98.26.4.61",
      country_name: "United States",
      country_code: "US",
      continent: "North America",
      city: "Durham",
      asn: 11426
    } |> Poison.encode!(pretty: true)
  end

  defp response_ip_102_26_4_61() do
    %{error: "No data for IP address"} |> Poison.encode!(pretty: true)
  end
end
