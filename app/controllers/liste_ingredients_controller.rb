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
    redirect_to liste_liste_ingredients_path(@liste)
  end

  def index
    @liste_ingredients = ListeIngredient.where(liste: Liste.find(params[:liste_id]))
    quantities = Quantity.where(recipe: Liste.find(params[:liste_id]).recipes)
    @ingredients = []
    quantities.each do |q|
      ingredient = {
        name: q.ingredient.name,
        unit: q.ingredient.unit,
        number: number_ingredient(q)
      }
      if @ingredients.any? { |i| i[:name] == ingredient[:name] }
        changed_ingredient = @ingredients.detect { |i| i[:name] == ingredient[:name] }
        changed_ingredient[:number] += ingredient[:number]
      else
        @ingredients.push(ingredient)
      end
    end
  end

  def update
    @liste_ingredient = ListeIngredient.find(params[:id])
    @liste_ingredient.update(bought: !@liste_ingredient.bought)
    redirect_to liste_liste_ingredients_path(@liste_ingredient.liste)
  end

  private
  def number_ingredient(quantity)
    !quantity.number.nil? ? (quantity.number * current_user.preference.foyer).to_f /  quantity.recipe.base_quantity : 0
  end
end
