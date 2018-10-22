class RailsComInit < ActiveRecord::Migration[5.2]
  def change
    create_table :active_storage_blob_defaults do |t|
      t.string :record_class
      t.string :name
      t.timestamps
    end
  end
end