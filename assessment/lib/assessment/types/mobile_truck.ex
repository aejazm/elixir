defmodule Assessment.Types.MobileTruck do
  alias Assessment.Types.MobileTruck
  alias Geocalc.Shape.Circle

  @moduledoc """
  Module for managing & searching Mobile Trucks located in SFO.
  Possible Enhancements that can be done if more time could be spent on the project
  - Updating the database daily at a desired schedule using a dedicated GenServer
  - Using Ecto/Postgres for more efficient queries & use cases
  - Creating a GraphQL API for more finer grained control over the results
  - Right now all the table objects are brought in memory & local processing filters the
  unwanted rows/objects. Ideally the filtering should happen at the database level to
  have better performance . I attempted to do it on line 132 but need more time to explore
  if Mnesia can do the filtering.
  """

  use Memento.Table,
    attributes: [
      :id,
      :name,
      :type,
      :lat,
      :long,
      :permit_status,
      :geohash,
      :description,
      :address,
      :food_items
    ],
    index: [:geohash, :food_items],
    type: :ordered_set,
    autoincrement: true

  # Index values of the fields needed for searching the trucks
  @name_index 9
  @lat_index 22
  @long_index 23
  @type_index 10
  @location_desc_index 12
  @address_index 13
  @permit_status_index 18
  @food_items_index 19

  @doc """
  Gets the data from the SFO city public link & populates the MobileTruck table
  """
  def populate_table do
    fetch_data()
    # Filter the records with ("0", "0") as latitude/longitude
    |> Enum.filter(fn truck -> Enum.at(truck, @lat_index) != "0" end)
    |> write_records
  end

  # Gets the data from the SFO city public link
  defp fetch_data() do
    req_url = ~s(https://data.sfgov.org/api/views/rqzj-sfat/rows.json?accessType=DOWNLOAD)

    {:ok, %HTTPoison.Response{body: b}} = HTTPoison.get(req_url)
    {:ok, %{"meta" => _, "data" => d}} = Jason.decode(b)
    d
  end

  # Writes the records to the MobileTruck table
  defp write_records(recordList) do
    Memento.transaction!(fn ->
      Enum.each(
        recordList,
        fn item ->
          Memento.Query.write(%MobileTruck{
            name: Enum.at(item, @name_index),
            type: Enum.at(item, @type_index),
            lat: Enum.at(item, @lat_index),
            long: Enum.at(item, @long_index),
            permit_status: Enum.at(item, @permit_status_index),
            geohash:
              Geohash.encode(
                String.to_float(Enum.at(item, @lat_index)),
                String.to_float(Enum.at(item, @long_index)),
                # 12 character geohash
                12
              ),
            description: Enum.at(item, @location_desc_index),
            address: Enum.at(item, @address_index),
            food_items: Enum.at(item, @food_items_index)
          })
        end
      )
    end)
  end

  @doc """
  Finds nearby trucks/carts with required food item within a certain distance from
  (in kilometers)the current position. Returns a list of matching trucks/carts.
  Example,
  iex(32)> MobileTruck.find_nearby_trucks_with_food_item({"37.77529014231951", "-122.4407311621107"}, "Salad", 0.5)

  """
  def find_nearby_trucks_with_food_item(
        {latitude, longitude},
        food_item,
        distance_from_current_location
      ) do
    area = %Circle{
      latitude: String.to_float(latitude),
      longitude: String.to_float(longitude),
      radius: distance_from_current_location * 1000
    }

    Memento.transaction!(fn -> Memento.Query.all(MobileTruck) end)
    |> Enum.filter(fn truck ->
      truck.food_items != nil and
        String.contains?(truck.food_items, food_item) and
        truck.permit_status == "APPROVED" and
        Geocalc.in_area?(area, %{
          lat: String.to_float(truck.lat),
          lng: String.to_float(truck.long)
        })
    end)
  end

  @doc """
  Finds nearby trucks on the basis of Geohash strings. This is based on the property of
  Geohash strings that similar looking strings represent the points close by. Returns a list
  of matching trucks/carts. The third parameter value range is between 0-1 (same as the
  value returned by String.jaro_distance() which measures the degree of string similarity).
  0 means fartherest from the current location passed as {latitude, longitude} argument.
  Example,
  iex(28)> MobileTruck.find_trucks_nearby({"37.76360804110198","-122.50959579624613"}, 0.7)
  """
  def find_nearby_trucks({latitude, longitude}, distance_fraction) do
    current_location_geo = Geohash.encode(String.to_float(latitude), String.to_float(longitude))
    # Find all records where String.jaro_distance(current_location_geo, record_geo) > 0.75
    # guards = {:>= , String.jaro_distance(:geohash, current_location_geo), 0.75}
    Memento.transaction!(fn -> Memento.Query.all(MobileTruck) end)
    |> Enum.filter(fn truck ->
      String.jaro_distance(truck.geohash, current_location_geo) > distance_fraction and
        truck.permit_status == "APPROVED"
    end)
  end
end
