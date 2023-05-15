defmodule Assessment.AssessmentTest do
  use ExUnit.Case
  alias Assessment.Types.MobileTruck

  test "check if Trucks with at the position of an known truck is found" do
    latitude = "37.775774368410254"
    longitude = "-122.43733160784082"
    current_position = {latitude, longitude}
    assert length(MobileTruck.find_nearby_trucks(current_position, 0.75)) >= 0
  end

  test "check if any cold trucks exist at a known location" do
    latitude = "37.775774368410254"
    longitude = "-122.43733160784082"
    current_position = {latitude, longitude}assert length(MobileTruck.find_nearby_trucks_with_food_item(current_position, "Cold", 0.5)) >=
             0
  end
end
