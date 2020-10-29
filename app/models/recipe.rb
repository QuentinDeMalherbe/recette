class Recipe < ApplicationRecord
  has_many :liste_recipes
  has_many :steps
  has_many :quantities
end
