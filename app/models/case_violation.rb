# == Schema Information
#
# Table name: case_violations
#
#  id                  :bigint(8)        not null, primary key
#  activity_id         :bigint(8)
#  violation_type_code :string
#  rank_order          :integer
#  violation_type_desc :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

class CaseViolation < ApplicationRecord
  belongs_to :case,
    class_name: 'CaseEnforcement',
    primary_key: :activity_id,
    foreign_key: :activity_id
end
