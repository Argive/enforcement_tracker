class CreateStatuteViolationMatches < ActiveRecord::Migration[5.1]
  def change
    create_table :statute_violation_matches do |t|
      t.string :key, null: false
      t.string :statute_code
      t.string :law_section_code
      t.string :law_section_desc

      t.string :violation_type_code
      t.string :violation_type
      
      t.integer :count

      t.string :top_level_epa_summary
      t.string :top_level_usc

      t.string :drilldown_epa_summary
      t.string :drilldown_usc
      t.string :drilldown_cfr
      t.string :drilldown_fr

      t.string :other_links, array: true

      t.timestamps
    end
  end
end
