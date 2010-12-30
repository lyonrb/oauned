class CreateAuthorizations < ActiveRecord::Migration
  def self.up
    create_table :authorizations do |t|
      t.integer  :user_id
      t.integer  :application_id
      
      t.string  :code
      t.datetime :expires_at
      
      t.timestamps
    end
  end

  def self.down
    drop_table :authorizations
  end
end
