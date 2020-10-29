class Liste < ApplicationRecord
  belongs_to :user
  has_many :liste_ingredients
  has_many :liste_recipes
end
