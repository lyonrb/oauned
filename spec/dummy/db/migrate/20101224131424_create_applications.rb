class CreateApplications < ActiveRecord::Migration
  def change
    create_table :applications, :force => true do |t|
      t.string   :name,              :limit => 40
      t.string   :website
      t.boolean  :no_confirmation,   :default => false

      t.string   :consumer_secret
      t.string   :redirect_uri

      t.timestamps
    end
  end
end
