class CreateCaseStatutes < ActiveRecord::Migration[5.1]
  def change
    create_table :case_statutes do |t|
      t.integer :activity_id
      t.string :case_number
      t.integer :rank_order
      t.string :statute_code
      t.string :law_section_code
      t.string :law_section_desc

      t.timestamps
    end
  end
end
