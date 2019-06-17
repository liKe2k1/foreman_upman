class AddBaseUrlToChannels < ActiveRecord::Migration[4.2]
  def up
    add_column :upman_channels, :base_url, :string
  end

  def down
    remove_column :upman_channels, :base_url
  end
end
