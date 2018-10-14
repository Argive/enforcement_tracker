class CreateFacilityPrograms < ActiveRecord::Migration[5.1]
  def change
    create_table :facility_programs do |t|
      t.bigint :registry_id
      t.string :program_acronym
      t.string :program_id

      t.timestamps
    end

    add_index :facility_programs, [:registry_id]
  end
end
