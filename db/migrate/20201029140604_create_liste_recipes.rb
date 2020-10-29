class CreateListeRecipes < ActiveRecord::Migration[6.0]
  def change
    create_table :liste_recipes do |t|
      t.references :recipe, null: false, foreign_key: true
      t.references :liste, null: false, foreign_key: true

      t.timestamps
    end
  end
end
