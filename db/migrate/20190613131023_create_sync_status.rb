class CreateSyncStatus < ActiveRecord::Migration[4.2]
  def up
    create_table :upman_sync_status do |t|
      t.integer :repository_id
      t.string :uuid
      t.integer :packages_count
      t.integer :packages_processed
      t.datetime :last_update
      t.string :last_package_name
      t.string :status
      t.timestamps null: false
    end
    add_index(:upman_sync_status, :uuid, unique: true)
  end

  def down
    remove_index :upman_sync_status, :uuid
    drop_table :upman_sync_status
  end
end