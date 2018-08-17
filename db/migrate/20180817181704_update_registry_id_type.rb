class UpdateRegistryIdType < ActiveRecord::Migration[5.1]
  def change
    change_column :facilities, :registry_id, :bigint
  end
end
