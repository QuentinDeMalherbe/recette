class ListeIngredient < ApplicationRecord
  belongs_to :liste
  belongs_to :ingredient
end
