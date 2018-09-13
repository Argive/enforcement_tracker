class AddRegistryIdToCaseEnforcement < ActiveRecord::Migration[5.1]
  def change
    add_column :case_enforcements, :registry_id, :bigint
  end
end
