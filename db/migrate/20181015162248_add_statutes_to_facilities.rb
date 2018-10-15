class AddStatutesToFacilities < ActiveRecord::Migration[5.1]
  def change
    add_column :facilities, :caa_applicable, :boolean, default: false
    add_column :facilities, :cwa_applicable, :boolean, default: false
    add_column :facilities, :epcra_applicable, :boolean, default: false
    add_column :facilities, :rcra_applicable, :boolean, default: false
    add_column :facilities, :sdwa_applicable, :boolean, default: false 
  end
end
