class CreateErrataAnnounce < ActiveRecord::Migration[4.2]
  def change

    create_table :upman_erratum do |t|
      t.string :category
      t.integer :errata_id
      t.integer :release
      t.string :name
      t.string :errata_type
      t.string :date
      t.string :synopsis
      t.string :date
      t.string :from
      t.string :description
      t.boolean :reboot
      t.string :dist
      t.string :subject
      t.json :packages
      t.timestamps null: false

    end

  end
end