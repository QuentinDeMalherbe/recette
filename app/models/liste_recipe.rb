class ListeRecipe < ApplicationRecord
  belongs_to :recipe
  belongs_to :liste
end
