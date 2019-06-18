class RenameColTypeExtendeds < ActiveRecord::Migration[4.2]
  def up
    rename_column :upman_extendeds, :type, :extend_type
  end

  def down
    rename_column :upman_extendeds, :extend_type, :type
  end
end
