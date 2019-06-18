class CreateExtendeds < ActiveRecord::Migration[4.2]
  def up
    create_table :upman_extendeds do |t|
      t.string :guid
      t.string :package
      t.string :type
      t.string :version_mask
      t.string :version
      t.string :condition
      t.timestamps null: false
    end
  end

  def down
    drop_table :upman_extendeds
  end
end
