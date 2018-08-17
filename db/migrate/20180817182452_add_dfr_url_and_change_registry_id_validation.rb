class AddDfrUrlAndChangeRegistryIdValidation < ActiveRecord::Migration[5.1]
  def change
    add_column :facilities, :dfr_url, :string
    change_column_null :facilities, :registry_id, true
  end
end
