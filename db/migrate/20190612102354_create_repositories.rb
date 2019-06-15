class CreateRepositories < ActiveRecord::Migration[4.2]
  def change
    create_table :upman_repositories do |t|
      t.integer :channel_id
      t.string :label
      t.string :dist
      t.string :component
      t.string :url
      t.text :gpg_key
      t.timestamps null: false
    end
    add_index :upman_repositories, :label, unique: true

    add_foreign_key :upman_repositories, :upman_channels, column: :channel_id

  end
end
