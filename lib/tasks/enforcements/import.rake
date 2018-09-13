require 'csv'

namespace :import do
  task case_enforcement: :environment do
    path = Rails.root.join('lib', 'tasks', 'enforcements', 'case_downloads', 'CASE_ENFORCEMENTS.csv')
    counter = 0
    CSV.foreach(path, headers: true, encoding: 'ISO-8859-1').each do |row|
      c = CaseEnforcement.new

      c.activity_id = row['ACTIVITY_ID']
      c.activity_name = row['ACTIVITY_NAME'].gsub("\u0000", '') if row['ACTIVITY_NAME']
      c.state_code = row['STATE_CODE'].gsub("\u0000", '') if row['STATE_CODE']
      c.region_code = row['REGION_CODE'].gsub("\u0000", '') if row['REGION_CODE']
      c.fiscal_year = row['FISCAL_YEAR']
      c.case_number = row['CASE_NUMBER'].gsub("\u0000", '') if row['CASE_NUMBER']
      c.case_name = row['CASE_NAME'].gsub("\u0000", '') if row['CASE_NAME']
      c.activity_type_code = row['ACTIVITY_TYPE_CODE'].gsub("\u0000", '') if row['ACTIVITY_TYPE_CODE']
      c.activity_type_desc = row['ACTIVITY_TYPE_DESC'].gsub("\u0000", '') if row['ACTIVITY_TYPE_DESC']
      c.activity_status_code = row['ACTIVITY_STATUS_CODE']
      c.activity_status_desc = row['ACTIVITY_STATUS_DESC'].gsub("\u0000", '') if row['ACTIVITY_STATUS_DESC']
      c.activity_status_date = DateTime.strptime(row['ACTIVITY_STATUS_DATE'], '%m/%d/%y') if DateTime.parse(row['ACTIVITY_STATUS_DATE']) rescue nil
      c.lead = row['LEAD'].gsub("\u0000", '') if row['LEAD']
      c.case_status_date = DateTime.strptime(row['CASE_STATUS_DATE'], '%m/%d/%y') if DateTime.parse(row['CASE_STATUS_DATE']) rescue nil
      c.doj_docket_nmbr = row['DOJ_DOCKET_NMBR'].gsub("\u0000", '') if row['DOJ_DOCKET_NMBR']
      c.enf_outcome_code = row['ENF_OUTCOME_CODE']
      c.enf_outcome_desc = row['ENF_OUTCOME_DESC'].gsub("\u0000", '') if row['ENF_OUTCOME_DESC']
      c.enf_outcome_text = row['ENF_OUTCOME_TEXT'].gsub("\u0000", '') if row['ENF_OUTCOME_TEXT']
      c.total_penalty_assessed_amt = row['TOTAL_PENALTY_ASSESSED_AMT']
      c.total_cost_recovery_amt = row['TOTAL_COST_RECOVERY_AMT']
      c.total_com_action_amt = row['TOTAL_COM_ACTION_AMT']
      c.hq_division = row['HQ_DIVISION'].gsub("\u0000", '') if row['HQ_DIVISION']
      c.branch = row['BRANCH'].gsub("\u0000", '') if row['BRANCH']
      c.voluntary_self_disclosure_flag = row['VOLUNTARY_SELF_DISCLOSURE_FLAG'].gsub("\u0000", '') if row['VOLUNTARY_SELF_DISCLOSURE_FLAG']
      c.multimedia_flag = row['MULTIMEDIA_FLAG'].gsub("\u0000", '') if row['MULTIMEDIA_FLAG']

      c.save

      puts "#{c.case_number} added ..."
      counter += 1
    end

    puts "#{counter} cases added."
  end

  task case_statutes: :environment do
    path = Rails.root.join('lib', 'tasks', 'enforcements', 'case_downloads', 'CASE_LAW_SECTIONS.csv')
    counter = 0

    CSV.foreach(path, headers: true, encoding: 'ISO-8859-1').each do |row|
      c = CaseStatute.new

      c.activity_id = row['ACTIVITY_ID']
      c.case_number = row['CASE_NUMBER'].gsub("\u0000", '') if row['CASE_NUMBER']
      c.rank_order = row['RANK_ORDER']
      c.statute_code = row['STATUTE_CODE'].gsub("\u0000", '') if row['STATUTE_CODE']
      c.law_section_code = row['LAW_SECTION_CODE'].gsub("\u0000", '') if row['LAW_SECTION_CODE']
      c.law_section_desc = row['LAW_SECTION_DESC'].gsub("\u0000", '') if row['LAW_SECTION_DESC']

      c.save
      puts "#{c.case_number} added ..."
      counter += 1
    end

    puts "#{counter} cases added."
  end

  task add_registry_id: :environment do
    path = Rails.root.join('lib', 'tasks', 'enforcements', 'case_downloads', 'CASE_FACILITIES.csv')
    counter = 0

    CSV.foreach(path, headers: true, encoding: 'ISO-8859-1').each do |row|
      c = CaseEnforcement.find_by(activity_id: row['ACTIVITY_ID'])
      c.registry_id = row['REGISTRY_ID']

      c.save

      puts "#{row['FACILITY_NAME']}, #{c.registry_id}"
    end

    puts "#{counter} facilities matched."
  end


end
