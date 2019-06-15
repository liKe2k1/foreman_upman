class CreateMaintainers < ActiveRecord::Migration[4.2]
  def change
    create_table :upman_maintainers do |t|
      t.string :name
      t.string :email
      t.timestamps null: false
    end
  end
end
