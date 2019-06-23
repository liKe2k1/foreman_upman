class CreateNodeHistory < ActiveRecord::Migration[4.2]
  def up
    create_table :upman_node_history do |t|
      t.string :uuid
      t.string :action
      t.string :package
      t.string :architecture
      t.string :old_version
      t.string :target_version
      t.string :created_at
    end

    add_index(:upman_node_history, %i[uuid package created_at], unique: true)
  end

  def down

    drop_table :upman_node_history
  end
end
