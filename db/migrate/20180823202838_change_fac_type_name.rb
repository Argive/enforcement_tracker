class ChangeFacTypeName < ActiveRecord::Migration[5.1]
  def change
    rename_column :facilities, :facility_type, :fac_type
  end
end
