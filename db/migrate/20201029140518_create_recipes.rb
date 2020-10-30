class CreateRecipes < ActiveRecord::Migration[6.0]
  def change
    create_table :recipes do |t|
      t.string :name
      t.time :prep_time
      t.time :cook_time
      t.string :price
      t.string :description
      t.integer :complexity
      t.integer :base_quantity
      t.string :unit
      t.string :type
      t.boolean :favori

      t.timestamps
    end
  end
end
