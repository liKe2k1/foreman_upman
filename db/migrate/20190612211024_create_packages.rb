class CreatePackages < ActiveRecord::Migration[4.2]
  def change

    create_table :upman_packages do |t|

      t.integer :repository_id
      t.string :name
      t.integer :installed_size
      t.string :version
      t.string :architecture
      t.text :description
      t.string :multi_arch
      t.string :homepage
      t.string :description_md5
      t.string :section
      t.string :priority
      t.string :filename
      t.integer :size
      t.string :md5sum
      t.string :sha265
      t.timestamps null: false

    end
    add_index(:upman_packages, [:name, :version], unique: true)
    add_index(:upman_packages, [:repository_id], unique: false)

    add_foreign_key :upman_packages, :upman_repositories, column: :repository_id
  end
end