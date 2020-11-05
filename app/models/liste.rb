class Liste < ApplicationRecord
  belongs_to :user
  has_many :liste_recipes
  has_many :liste_ingredients
  has_many :recipes, through: :liste_recipes
end
