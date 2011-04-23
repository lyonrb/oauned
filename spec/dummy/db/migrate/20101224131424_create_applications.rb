class CreateApplications < ActiveRecord::Migration
  def self.up
    create_table :applications, :force => true do |t|
      t.string   :name,              :limit => 40
      t.string   :website
      t.boolean  :no_confirmation,   :default => false
      
      t.string   :consumer_secret
      t.string   :redirect_uri
      
      t.timestamps
    end
  end

  def self.down
    drop_table   :applications
  end
end
