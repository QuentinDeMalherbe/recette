class AddUnitToQuantities < ActiveRecord::Migration[6.0]
  def change
    add_column :quantities, :unit, :string
  end
end
