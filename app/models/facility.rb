# == Schema Information
#
# Table name: facilities
#
#  id                            :bigint(8)        not null, primary key
#  registry_id                   :bigint(8)
#  fac_name                      :string
#  fac_street                    :string
#  fac_city                      :string
#  fac_state                     :string
#  fac_zip                       :integer
#  fac_epa_region                :integer
#  fac_lat                       :float
#  fac_long                      :float
#  fac_naics_codes               :string
#  fac_inspection_count          :integer
#  fac_date_last_inspection      :string
#  fac_informal_count            :integer
#  fac_date_last_informal_action :string
#  fac_formal_action_count       :integer
#  fac_date_last_formal_action   :string
#  fac_total_penalties           :bigint(8)
#  fac_penalty_count             :integer
#  fac_date_last_penalty         :string
#  fac_last_penalty_amount       :bigint(8)
#  caa_evaluation_count          :integer
#  caa_informal_count            :integer
#  caa_formal_action_count       :integer
#  caa_penalties                 :bigint(8)
#  cwa_inspection_count          :integer
#  cwa_informal_count            :integer
#  cwa_formal_action_count       :integer
#  cwa_penalties                 :bigint(8)
#  rcra_inspection_count         :integer
#  rcra_informal_count           :integer
#  rcra_formal_action_count      :integer
#  rcra_penalties                :bigint(8)
#  sdwa_informal_count           :integer
#  sdwa_formal_action_count      :integer
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#  dfr_url                       :string
#  fac_type                      :string
#  caa_applicable                :boolean          default(FALSE)
#  cwa_applicable                :boolean          default(FALSE)
#  epcra_applicable              :boolean          default(FALSE)
#  rcra_applicable               :boolean          default(FALSE)
#  sdwa_applicable               :boolean          default(FALSE)
#

class Facility < ApplicationRecord

  default_scope { order('id') }


  has_many :enforcements,
    class_name: 'CaseEnforcement',
    primary_key: :registry_id,
    foreign_key: :registry_id

  has_many :programs,
    class_name: 'FacilityProgram',
    primary_key: :registry_id,
    foreign_key: :registry_id


  has_many :violated_statutes,
    through: :enforcements

  extend Rack::Reducer
  reduces self.all, filters: [
    ->(id:) { where(id: id.to_i) }, # for testing, remove in prod
    ->(frs:) { where(registry_id: frs) },
    ->(name:) { where('lower(fac_name) like ?', "%#{name.split('%20').join(' ').downcase}%") },
    ->(address:) { where('lower(fac_street) like ?', "%#{address.split('%20').join(' ').downcase}%") },
    ->(state:) { where(fac_state: state.upcase) },
    ->(zip:) { where(fac_zip: zip.to_i) },
    ->(epa_region:) { where(fac_epa_region: epa_region.to_i) },
    ->(inspection_count_max:) { where(fac_inspection_count: 0..inspection_count_max.to_i) },
    ->(inspection_count_min:) { where(fac_inspection_count: inspection_count_min.to_i..Float::INFINITY) },
    ->(fines_max:) { where(fac_total_penalties: 0..fines_max.to_i) },
    ->(fines_min:) { where(fac_total_penalties: fines_min.to_i..Float::INFINITY) },
    ->(naics_available:) { where.not(fac_naics_codes: nil) }, # for testing, remove in prod
    ->(naics:) { where('fac_naics_codes like ? OR fac_naics_codes like ?',  "#{naics}%", "% #{naics}%") },
    ->(type:) { where(fac_type: type) }
  ]

  validates :registry_id, uniqueness: true, allow_nil: true
  validates :fac_type, inclusion: { in: %w{gov small large exempt},
                                         message: "%{value} is invalid type."}


  def self.summarize
    summary = {}

    summary[:facility_count] = Facility.count
    summary[:small_business_count] = Facility.where(fac_type: 'small').count
    summary[:large_business_count] = Facility.where(fac_type: 'large').count
    summary[:gov_count] = Facility.where(fac_type: 'gov').count
    summary[:exempt_count] = Facility.where(fac_type: 'exempt').count

    summary
  end

  # up to two digit only
  def self.count_industries
    counter = Hash.new(0)

    Facility.where.not(fac_naics_codes: nil).pluck(:fac_naics_codes).each do |code_str|
      code_str.split(" ").each { |code| counter[code] += 1}
    end

    counter
  end

  def self.tally_inspections_by_state
    counter = Hash.new(0)

    Facility.where('fac_inspection_count > ?', 0).each do |f|
      counter[f.fac_state] += f.fac_inspection_count
    end

    counter
  end

  def associated_actions
    enforcements_detail = self.enforcements.empty? ? [] : self.enforcements

    inspections = {
      total: (self.fac_inspection_count || 0),
      caa: (self.caa_evaluation_count || 0),
      cwa: (self.cwa_inspection_count || 0),
      rcra: (self.rcra_inspection_count || 0)
    }

    enforcements = {
      total_penalties: (self.fac_total_penalties || 0),
      penalty_count: (self.fac_penalty_count || 0),
      formal_actions: (self.fac_formal_action_count || 0),
      informal_actions: (self.fac_informal_count || 0)
    }

    {
      registry_id: self.registry_id,
      enforcements: enforcements,
      inspections: inspections,
      enforcements_detail: enforcements_detail
    }
  end

  def self.generate_inspection_stats
    stats = {}

    caa_f = Facility.where(caa_applicable: true)
    caa_inspected_count = caa_f.where('caa_evaluation_count > ?', 0).count

    cwa_f = Facility.where(cwa_applicable: true)
    cwa_inspected_count = cwa_f.where('cwa_inspection_count > ?', 0).count

    rcra_f = Facility.where(rcra_applicable: true)
    rcra_inspected_count = rcra_f.where('rcra_inspection_count > ?', 0).count

    stats['caa'] = [
      caa_inspected_count,
      caa_inspected_count / caa_f.count.to_f
    ]

    stats['cwa'] = [
      cwa_inspected_count,
      cwa_inspected_count / cwa_f.count.to_f
    ]

    stats['rcra'] = [
      rcra_inspected_count,
      rcra_inspected_count / rcra_f.count.to_f
    ]

    stats
  end

  def applicable_statutes
    applicable_statutes = {
      'caa' => false,
      'cwa' => false,
      'rcra' => false,
      'sdwa' => false 
    }

    applicable_statutes['caa'] = true if self.caa_applicable
    applicable_statutes['cwa'] = true if self.cwa_applicable
    applicable_statutes['rcra'] = true if self.rcra_applicable

    applicable_statutes
  end

  # def self.search(**args)
  #   zip = args[:zip]
  #   name = args[:name]
  #   address = args[:address]
  #   if !name
  #     facility_matches = Facility.where(fac_zip: zip)
  #                                .where('fac_address LIKE ?', "%#{address}%")
  #   elsif !address
  #     facility_matches = Facility.where(fac_zip: zip)
  #                                .where('fac_name LIKE ?', "%#{name}%")
  #   else
  #     facility_matches = Facility.where(fac_zip: zip)
  #                                .where('fac_address LIKE ?', "%#{address}%")
  #                                .where('fac_name LIKE ?', "%#{name}%")
  #   end
  #
  #   facility_matches
  # end
end
