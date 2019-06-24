class CreateJoinTableNodeRepositories < ActiveRecord::Migration[4.2]
  def up
    create_table :upman_node_repositories, id: false do |t|
      t.belongs_to :upman_node, index: true, foreign_key: :node_id
      t.belongs_to :upman_repository, index: true, foreign_key: :repositories_id
    end
  end

  def down
    drop_table :upman_node_repositories
  end
end
