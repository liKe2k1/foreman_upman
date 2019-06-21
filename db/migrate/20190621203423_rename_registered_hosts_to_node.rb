class RenameRegisteredHostsToNode < ActiveRecord::Migration[4.2]
  def up
    rename_table :upman_registered_hosts, :upman_nodes
  end

  def down
    rename_table  :upman_nodes, :upman_registered_hosts
  end
end
