class CreateParentings < ActiveRecord::Migration[7.0]
  def change
    create_table :parentings do |t|
      t.references :parent, null: false, foreign_key: { to_table: :revisions }, index: true
      t.references :child, null: false, foreign_key: { to_table: :documents }, index: true

      t.integer :ordinal
      t.timestamps
    end
  end
end
