class OaunedCreate<%= table_name.camelize %> < ActiveRecord::Migration
  def self.up
    create_table(:<%= table_name %>) do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :<%= table_name %>
  end
end
