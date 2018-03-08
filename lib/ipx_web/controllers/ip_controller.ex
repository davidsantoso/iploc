defmodule IpxWeb.IpController do
  use IpxWeb, :controller

  def show(conn, %{"ip" => ip, "lang" => lang}) do
    response = ip |> lookup |> build_response(lang) |> encode
    send_resp(conn, 200, response)
  end

  def show(conn, %{"ip" => ip}) do
    response = ip |> lookup |> build_response(:en) |> encode
    send_resp(conn, 200, response)
  end

  #############################################################################
  # Private functions to query the in memory DB
  #############################################################################

  defp encode(map) do
    map |> Poison.encode_to_iodata!(pretty: true)
  end

  defp lookup(ip) do
    case Geolix.lookup(ip) do
      nil -> nil
      result -> result
    end
  end

  def build_response(nil, _), do: %{error: "Invalid IP address"}
  def build_response(%{asn: nil, geo: nil}, _), do: %{error: "No data for IP address"}
  def build_response(data, lang) do
    geo_data = Map.get(data, :geo)
    asn_data = Map.get(data, :asn)

    %{
      ip: ip(geo_data, lang),
      city: city(geo_data, lang),
      region_code: region_code(geo_data, lang),
      region_name: region_name(geo_data, lang),
      country_code: country_code(geo_data, lang),
      country_name: country_name(geo_data, lang),
      continent: continent(geo_data, lang),
      latitude: latitude(geo_data, lang),
      longitude: longitude(geo_data, lang),
      postal: postal(geo_data, lang),
      time_zone: time_zone(geo_data, lang),
      asn: asn(asn_data),
      network: network(asn_data)
    }
  end

  defp ip(nil, _), do: nil
  defp ip(%{traits: nil}, _), do: nil
  defp ip(%{traits: %{ip_address: ip_address}}, _lang) do
    ip_address |> Tuple.to_list |> Enum.join(".")
  end

  defp city(nil, _), do: nil
  defp city(%{city: nil}, _), do: nil
  defp city(%{city: %Geolix.Record.City{name: name}}, :en), do: name
  defp city(%{city: %Geolix.Record.City{names: names}} = data, lang) do
    case Map.get(names, lang) do
      nil -> city(data, :en)
      city_name -> city_name
    end
  end

  defp region_code(nil, _lang), do: nil
  defp region_code(%{subdivisions: nil}, _lang), do: nil
  defp region_code(%{subdivisions: [%Geolix.Record.Subdivision{iso_code: iso_code}]}, _lang), do: iso_code

  defp region_name(nil, _lang), do: nil
  defp region_name(%{subdivisions: nil}, _lang), do: nil
  defp region_name(%{subdivisions: [%Geolix.Record.Subdivision{name: name}]}, :en), do: name
  defp region_name(%{subdivisions: [%Geolix.Record.Subdivision{names: names}]} = data, lang) do
    case Map.get(names, lang) do
      nil -> region_name(data, :en)
      region_name -> region_name
    end
  end

  defp country_code(nil, _lang), do: nil
  defp country_code(%{country: nil}, _lang), do: nil
  defp country_code(%{country: %Geolix.Record.Country{iso_code: iso_code}}, _), do: iso_code

  defp country_name(nil, _lang), do: nil
  defp country_name(%{country: nil}, _lang), do: nil
  defp country_name(%{country: %Geolix.Record.Country{name: name}}, :en), do: name
  defp country_name(%{country: %Geolix.Record.Country{names: names}}, lang) do
    case Map.get(names, lang) do
      nil -> nil
      country_name -> country_name
    end
  end

  defp continent(nil, _), do: nil
  defp continent(%{continent: nil}, _), do: nil
  defp continent(%{continent: %Geolix.Record.Continent{name: name}}, :en), do: name
  defp continent(%{continent: %Geolix.Record.Continent{names: names}}, lang) do
    case Map.get(names, lang) do
      nil -> nil
      continent_name -> continent_name
    end
  end

  defp latitude(nil, _), do: nil
  defp latitude(%{location: nil}, _), do: nil
  defp latitude(%{location: %Geolix.Record.Location{latitude: latitude}}, _lang), do: latitude

  defp longitude(nil, _), do: nil
  defp longitude(%{location: nil}, _), do: nil
  defp longitude(%{location: %Geolix.Record.Location{longitude: longitude}}, _lang), do: longitude

  defp postal(nil, _), do: nil
  defp postal(%{postal: nil}, _), do: nil
  defp postal(%{postal: %Geolix.Record.Postal{code: code}}, _lang), do: code

  defp time_zone(nil, _), do: nil
  defp time_zone(%{location: nil}, _), do: nil
  defp time_zone(%{location: %Geolix.Record.Location{time_zone: time_zone}}, _lang), do: time_zone

  defp asn(nil), do: nil
  defp asn(%{autonomous_system_number: number}), do: number

  defp network(nil), do: nil
  defp network(%{autonomous_system_organization: network}), do: network
end
