# == Schema Information
#
# Table name: case_enforcements
#
#  id                             :bigint(8)        not null, primary key
#  activity_id                    :bigint(8)
#  activity_name                  :string
#  state_code                     :string
#  region_code                    :string
#  fiscal_year                    :integer
#  case_number                    :string
#  case_name                      :string
#  activity_type_code             :string
#  activity_type_desc             :string
#  activity_status_code           :integer
#  activity_status_desc           :string
#  activity_status_date           :date
#  lead                           :string
#  case_status_date               :date
#  doj_docket_nmbr                :string
#  enf_outcome_code               :integer
#  enf_outcome_desc               :string
#  enf_outcome_text               :string
#  total_penalty_assessed_amt     :integer
#  total_cost_recovery_amt        :integer
#  total_com_action_amt           :integer
#  hq_division                    :string
#  branch                         :string
#  voluntary_self_disclosure_flag :string
#  multimedia_flag                :string
#  created_at                     :datetime         not null
#  updated_at                     :datetime         not null
#

class CaseEnforcement < ApplicationRecord

  has_many :statutes
end
