class CreateCaseRegulations < ActiveRecord::Migration[5.1]
  def change
    create_table :case_regulations do |t|
      t.string :case_number
      t.string :title
      t.string :part
      t.string :section

      t.timestamps
    end
  end
end
