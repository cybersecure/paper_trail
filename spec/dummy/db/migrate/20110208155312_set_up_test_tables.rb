class SetUpTestTables < ActiveRecord::Migration
  def self.up
    create_table :post_versions do |t|
      t.string   :item_type, :null => false
      t.integer  :item_id,   :null => false
      t.string   :event,     :null => false
      t.string   :whodunnit
      t.text     :object
      t.datetime :created_at

      t.string :ip
      t.string :user_agent
    end
  end

  def self.down
    drop_table :post_versions
  end
end
