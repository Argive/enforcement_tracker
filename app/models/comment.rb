# == Schema Information
#
# Table name: comments
#
#  id             :bigint(8)        not null, primary key
#  violation_id   :integer          not null
#  commenter_name :string           not null
#  body           :string           not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class Comment < ApplicationRecord

  belongs_to :violation,
    class_name: 'StatuteViolationMatch',
    primary_key: :id,
    foreign_key: :violation_id 
end
