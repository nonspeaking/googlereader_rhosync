class CreateSynctasks < ActiveRecord::Migration
  def self.up
    create_table :synctasks do |t|
      t.integer :source_id
      t.integer :user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :synctasks
  end
end
