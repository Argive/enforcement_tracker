require 'csv'

path = Rails.root.join('lib', 'seeds', 'echo_exporter_all.csv')

CSV.foreach(path, headers: true, encoding: 'ISO-8859-1').each do |row|
  t = Facility.new

  t.registry_id = row['REGISTRY_ID']
  t.fac_name = row['FAC_NAME']
  t.fac_street = row['FAC_STREET']
  t.fac_city = row['FAC_CITY']
  t.fac_state = row['FAC_STATE']
  t.fac_zip = row['FAC_ZIP']
  t.fac_epa_region = row['FAC_EPA_REGION']
  t.fac_lat = row['FAC_LAT']
  t.fac_long = row['FAC_LONG']
  t.fac_naics_codes = row['FAC_NAICS_CODES']
  t.dfr_url = row['DFR_URL']

  t.fac_inspection_count = row['FAC_INSPECTION_COUNT']
  t.fac_date_last_inspection = row['FAC_DATE_LAST_INSPECTION']

  t.fac_informal_count = row['FAC_INFORMAL_COUNT']
  t.fac_date_last_informal_action = row['FAC_DATE_LAST_INFORMAL_ACTION']
  t.fac_formal_action_count = row['FAC_FORMAL_ACTION_COUNT']
  t.fac_date_last_formal_action = row['FAC_DATE_LAST_FORMAL_ACTION']
  t.fac_total_penalties = row['FAC_TOTAL_PENALTIES']
  t.fac_penalty_count = row['FAC_PENALTY_COUNT']
  t.fac_date_last_penalty = row['FAC_DATE_LAST_PENALTY']
  t.fac_last_penalty_amount = row['FAC_LAST_PENALTY_AMOUNT']

  t.caa_evaluation_count = row['CAA_EVALUATION_COUNT']
  t.caa_informal_count = row['CAA_INFORMAL_COUNT']
  t.caa_formal_action_count = row['CAA_FORMAL_ACTION_COUNT']
  t.caa_penalties = row['CAA_PENALTIES']

  t.cwa_inspection_count = row['CWA_INSPECTION_COUNT']
  t.cwa_informal_count = row['CWA_INFORMAL_COUNT']
  t.cwa_formal_action_count = row['CWA_FORMAL_ACTION_COUNT']
  t.cwa_penalties = row['CWA_PENALTIES']

  t.rcra_inspection_count = row['RCRA_INSPECTION_COUNT']
  t.rcra_informal_count = row['RCRA_INFORMAL_COUNT']
  t.rcra_formal_action_count = row['RCRA_FORMAL_ACTION_COUNT']
  t.rcra_penalties = row['RCRA_PENALTIES']

  t.sdwa_informal_count = row['SDWA_INFORMAL_COUNT']
  t.sdwa_formal_action_count = row['SDWA_FORMAL_ACTION_COUNT']

  t.save
  puts "#{t.fac_name} added ..."
end

puts "#{Facility.count} rows added to Facility table."
