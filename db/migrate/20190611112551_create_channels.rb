class CreateChannels < ActiveRecord::Migration[4.2]
  def change
    create_table :upman_channels do |t|
      t.string :name, limit: 50
      t.string :label
      t.integer :parent_id, null: true
      t.string :architecture
      t.string :repository_checksum_type
      t.timestamps null: false
    end
    add_index :upman_channels, :name, unique: true
  end
end
