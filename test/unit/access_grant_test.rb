# == Schema Information
#
# Table name: access_grants
#
#  id                      :integer          not null, primary key
#  code                    :string(255)
#  access_token            :string(255)
#  refresh_token           :string(255)
#  access_token_expires_at :datetime
#  user_id                 :integer
#  client_id               :integer
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  state                   :string(255)
#

require 'test_helper'

class AccessGrantTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end
