class AddQueueSyncToSource < ActiveRecord::Migration
  def self.up
    add_column :sources, :queuesync, :boolean
  end

  def self.down
    remove_column :sources, :queuesync
  end
end
