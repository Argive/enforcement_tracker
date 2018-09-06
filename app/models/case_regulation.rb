# == Schema Information
#
# Table name: case_regulations
#
#  id          :bigint(8)        not null, primary key
#  case_number :string
#  title       :string
#  part        :string
#  section     :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class CaseRegulation < ApplicationRecord
end
