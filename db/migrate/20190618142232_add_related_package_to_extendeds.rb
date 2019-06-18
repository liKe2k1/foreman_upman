class AddRelatedPackageToExtendeds < ActiveRecord::Migration[4.2]
  def up
    add_column :upman_extendeds, :related_package_id, :integer
  end

  def down
    remove_column :upman_extendeds, :related_package_id
  end
end
