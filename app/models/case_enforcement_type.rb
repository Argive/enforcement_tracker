# == Schema Information
#
# Table name: case_enforcement_types
#
#  id            :bigint(8)        not null, primary key
#  activity_id   :bigint(8)
#  enf_type_code :string
#  enf_type_desc :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class CaseEnforcementType < ApplicationRecord
end
