class CreateTags < ActiveRecord::Migration[4.2]
  def change
    create_table :upman_tags do |t|
      t.string :label
      t.timestamps null: false
    end
  end
end
