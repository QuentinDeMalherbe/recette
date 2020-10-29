class ListesController < ApplicationController
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
