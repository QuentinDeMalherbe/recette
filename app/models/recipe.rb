class Recipe < ApplicationRecord
  has_many :liste_recipes
  has_many :steps
  has_many :quantities
  has_many :ingredients, through: :quantities

  def ratio(user)
    quantity_user = user.preference.foyer
    return quantity_user.to_f / base_quantity
  end
end
