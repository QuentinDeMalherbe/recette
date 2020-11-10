class ListeIngredientsController < ApplicationController
  def create_multiple
    @liste = Liste.find(params[:liste_id])
    @liste.recipes.each do |recipe|
      recipe.ingredients.each do |ingredient|
        unless ListeIngredient.where(liste: @liste, ingredient: ingredient).any?
          liste_ingredient = ListeIngredient.new(liste: @liste, ingredient: ingredient)
          liste_ingredient.save
        end
      end
    end
    redirect_to liste_ingredients_path(@liste)
  end
end
