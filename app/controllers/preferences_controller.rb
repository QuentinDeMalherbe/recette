class PreferencesController < ApplicationController
  def show
    @preference = Preference.find(params[:id])
  end

  def new
    @preference = Preference.new(user: current_user)
  end

  def create
    @preference = Preference.new(preference_params)
    @preference.user = current_user
    if @preference.save
      flash[:success] = "Object successfully created"
      redirect_to listes_path
    else
      flash[:error] = "Something went wrong"
      render 'new'
    end
  end

  private

  def preference_params
    params.require(:preference).permit(:foyer)
  end

end
