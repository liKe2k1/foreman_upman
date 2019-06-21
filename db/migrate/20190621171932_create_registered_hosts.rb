class CreateRegisteredHosts < ActiveRecord::Migration[4.2]
  def up
    create_table :upman_registered_hosts do |t|
      t.string :hostname
      t.string :uuid
      t.string :operatingsystem
      t.string :rubyversion
      t.string :operatingsystemrelease
      t.datetime :last_sync
      t.timestamps null: false
    end
    add_index(:upman_registered_hosts, %i[uuid], unique: true)
  end

  def down
    drop_table :upman_registered_hosts
  end
end
