class CreateConnections < ActiveRecord::Migration
  def self.up
    create_table :connections, :force => true do |t|
      t.integer  :user_id
      t.integer  :application_id
      
      t.string   :access_token
      t.string   :refresh_token
      t.datetime :expires_at
      
      t.timestamps
    end
  end

  def self.down
    drop_table   :connections
  end
end
