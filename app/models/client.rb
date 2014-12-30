# == Schema Information
#
# Table name: clients
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  app_id     :string(255)
#  app_secret :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Client < ActiveRecord::Base

  def self.authenticate(app_id, app_secret)
    where(["app_id = ? AND app_secret = ?", app_id, app_secret]).first
  end
end
