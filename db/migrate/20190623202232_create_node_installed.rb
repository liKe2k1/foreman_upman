class CreateNodeInstalled < ActiveRecord::Migration[4.2]
  def up
    create_table :upman_node_installed do |t|
      t.string :uuid
      t.string :package
      t.string :version
      t.string :architecture
      t.string :auto_installed
      t.timestamps null: false
    end

    add_index(:upman_node_installed, %i[uuid package version], unique: true)
  end

  def down
    drop_table :upman_node_installed
  end
end
