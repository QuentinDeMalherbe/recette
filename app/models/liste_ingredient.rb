class ListeIngredient < ApplicationRecord
  belongs_to :liste
  belongs_to :ingredient
  before_save :default_values
  def default_values
    self.bought ||= false
  end
end
