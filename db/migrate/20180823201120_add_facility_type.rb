class AddFacilityType < ActiveRecord::Migration[5.1]
  def change
    add_column :facilities, :facility_type, :string
  end
end
