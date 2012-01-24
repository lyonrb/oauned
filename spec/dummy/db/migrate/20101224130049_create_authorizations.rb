class CreateAuthorizations < ActiveRecord::Migration
  def change
    create_table :authorizations do |t|
      t.integer  :user_id
      t.integer  :application_id

      t.string  :code
      t.datetime :expires_at

      t.timestamps
    end
  end
end
