class ListesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :index ]
  def index
    @listes = Liste.all
  end

  def show
    @liste = Liste.find(params[:id])
  end

  def new
    @liste = Liste.new
  end

  def create
    @liste = Liste.new(liste_params)
    @liste.user = current_user
    if @liste.save
      flash[:success] = "Liste successfully created"
      recipes = Recipe.order(Arel.sql('RANDOM()')).limit(@liste.quantity)
      recipes.each do |recipe|
        liste_recipe = ListeRecipe.new(liste: @liste, recipe: recipe)
        liste_recipe.save
      end
      redirect_to @liste
    else
      flash[:error] = "Something went wrong"
      render 'new'
    end
  end

  private

  def liste_params
    params.require(:liste).permit(:quantity)
  end
end
