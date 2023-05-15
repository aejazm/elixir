# Assessment

## Installation

Load project using "iex -S mix"
Create the Mnesia database(including table MobileTruck) & import the public SFO Mobile truck data using,

iex(1)> Assessment.Initialize.setup_db

## Usage

Once the MobileTruck table is populated with data, following actions are possibe(with
current postion coordinates as reference),

- Finding nearby trucks containing a certain food item in a given radius, using
MobileTrucks.find_nearby_trucks_with_food_item
- Finding any nearby trucks
 

iex(2)> latitude= "37.775774368410254"
iex(3)> longitude = "-122.43733160784082"
iex(4)> current_position = {latitude, longitude}
iex(5)> alias Assessment.Types.MobileTruck
iex(6)> MobileTruck.find_nearby_trucks_with_food_item(current_position, "Cold", 0.5) 
[
  %Assessment.Types.MobileTruck{
    __meta__: Memento.Table,
    id: 350,
    name: "BH & MT LLC",
    type: "Truck",
    lat: "37.77529014231951",
    long: "-122.4407311621107",
    permit_status: "APPROVED",
    geohash: "9q8yvuc3h0mw",
    description: "GROVE ST: BRODERICK ST to BAKER ST (1400 - 1499)",
    address: "1477 GROVE ST",
    food_items: "Cold Truck: Breakfast: Sandwiches: Salads: Pre-Packaged Snacks: Beverages"
  },
  %Assessment.Types.MobileTruck{
    __meta__: Memento.Table,
    id: 355,
    name: "BH & MT LLC",
    type: "Truck",
    lat: "37.775774368410254",
    long: "-122.43733160784082",
    permit_status: "APPROVED",
    geohash: "9q8yvuggg6sr",
    description: "GROVE ST: SCOTT ST to DIVISADERO ST (1200 - 1299)",
    address: "1265 GROVE ST",
    food_items: "Cold Truck: Breakfast: Sandwiches: Salads: Pre-Packaged Snacks: Beverages"
  }
]

iex(7)> MobileTruck.find_nearby_trucks(current_position, 0.75)
MobileTruck.find_nearby_trucks(current_position, 0.75)
[
  %Assessment.Types.MobileTruck{
    __meta__: Memento.Table,
    id: 355,
    name: "BH & MT LLC",
    type: "Truck",
    lat: "37.775774368410254",
    long: "-122.43733160784082",
    permit_status: "APPROVED",
    geohash: "9q8yvuggg6sr",
    description: "GROVE ST: SCOTT ST to DIVISADERO ST (1200 - 1299)",
    address: "1265 GROVE ST",
    food_items: "Cold Truck: Breakfast: Sandwiches: Salads: Pre-Packaged Snacks: Beverages"
  }
]
