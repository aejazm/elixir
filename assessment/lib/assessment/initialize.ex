defmodule Assessment.Initialize do
  alias Memento.Schema
  alias Assessment.Types.MobileTruck

  @moduledoc """
  Function to create Mnesia table MobileTrucks
  """

  def setup_db() do
    Memento.stop()
    Schema.create([node()])
    Memento.start()
    Memento.Table.create(MobileTruck, disc_copies: [node()])
    MobileTruck.populate_table()
  end
end
