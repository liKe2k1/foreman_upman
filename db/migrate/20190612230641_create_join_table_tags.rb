class CreateJoinTableTags < ActiveRecord::Migration[4.2]
  def change

    create_table :upman_package_maintainers , id: false do |t|
      t.belongs_to :upman_packages, index: true, foreign_key: :package_id
      t.belongs_to :upman_maintainers, index: true, foreign_key: :maintainers_id
      t.datetime :assign_date
    end

    create_table :upman_package_tags , id: false do |t|
      t.belongs_to :upman_packages, index: true, foreign_key: :package_id
      t.belongs_to :upman_tags, index: true, foreign_key: :tags_id
      t.datetime :assign_date
    end

    add_index :upman_package_maintainers, [:package_id, :maintainers_id], :unique => true, :name => 'idx_packages_maintainers'
    add_index :upman_package_tags, [:package_id, :tags_id], :unique => true, :name => 'idx_packages_tags'

  end
end