class CreateJoinTableExtended < ActiveRecord::Migration[4.2]
  def up

    create_table :upman_package_extended , id: false do |t|
      t.belongs_to :upman_packages, index: true, foreign_key: :package_id
      t.belongs_to :upman_extendeds, index: true, foreign_key: :extends_id
    end

  end

  def down
    drop_table :upman_package_extended
  end
end
