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
#  registry_id                    :bigint(8)
#

class CaseEnforcement < ApplicationRecord

  has_many :violated_statutes,
    class_name: 'CaseStatute',
    primary_key: :activity_id,
    foreign_key: :activity_id

  belongs_to :facility,
    class_name: 'Facility',
    primary_key: :registry_id,
    foreign_key: :registry_id

  validates :activity_id, uniqueness: true

  # must use Facility model to calculate penalties because
  # CaseEnforcement data seems unreliable, e.g. total_penalties == nil
  # where it should very obviously not be.

  def self.summarize
    summary = {}

    penalized_facilities = Facility.where('fac_total_penalties > ?', 0)
    penalized_small_businesses = penalized_facilities.where('fac_type = ?', 'small')

    summary['count'] = CaseEnforcement.count

    summary['facilities_penalized'] =
      penalized_facilities.count

    summary['small_businesses_penalized'] =
      penalized_small_businesses.count

    summary['avg_penalties'] =
      penalized_facilities.average(:fac_total_penalties).to_i

    summary['avg_penalties_small_business'] =
      penalized_small_businesses.average(:fac_total_penalties).to_i

    summary
  end

  def self.group_by_year
    counter = Hash.new(0)

    CaseEnforcement.pluck(:fiscal_year).each do |yr|
      next if (!yr || yr > 2018)
      counter[yr] += 1
    end

    counter
  end

  def group_by_violated_statutes(subset)
    counter = Hash.new(0)

    subset.find_each do |c|
      c.violated_statutes.each do |s|
        statute_identifier = "#{s.statute_code} #{s.law_section_code} - #{s.law_section_desc}"
        counter[statute_identifier] += 1
      end
    end

    counter
  end

end
