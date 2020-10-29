class CreateListeIngredients < ActiveRecord::Migration[6.0]
  def change
    create_table :liste_ingredients do |t|
      t.references :liste, null: false, foreign_key: true
      t.references :ingredient, null: false, foreign_key: true
      t.boolean :bought

      t.timestamps
    end
  end
end
