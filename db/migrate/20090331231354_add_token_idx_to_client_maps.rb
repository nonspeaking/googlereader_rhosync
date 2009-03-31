class AddTokenIdxToClientMaps < ActiveRecord::Migration
  def self.up
    add_index "client_maps", ["token"], :name => "client_map_tok"
  end

  def self.down
    remove :client_maps,"client_map_tok"
  end
end
