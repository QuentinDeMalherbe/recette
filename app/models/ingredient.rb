class Ingredient < ApplicationRecord
  has_many :quantities
  has_many :liste_ingredients
end
