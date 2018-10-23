# == Schema Information
#
# Table name: comments
#
#  id             :bigint(8)        not null, primary key
#  violation_id   :integer          not null
#  commenter_name :string           not null
#  body           :text             not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

require 'test_helper'

class CommentTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
