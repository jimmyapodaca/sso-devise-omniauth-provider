# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  admin                  :boolean          default(FALSE)
#  first_name             :string(255)
#  last_name              :string(255)
#  status                 :string(255)
#  expiration_date        :date
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  authentication_token   :string(255)
#  image                  :string(255)
#

class User < ActiveRecord::Base
  has_many :authentications, :dependent => :delete_all
  has_many :access_grants, :dependent => :delete_all

  before_validation :initialize_fields, :on => :create

  before_save :ensure_authentication_token

  devise :database_authenticatable, :registerable,
    :recoverable, :timeoutable, :trackable, :validatable, :rememberable,
    :omniauthable


  attr_accessible :email, :password, :password_confirmation, :remember_me, :first_name, :last_name


  def apply_omniauth(omniauth)
    authentications.build(:provider => omniauth['provider'], :uid => omniauth['uid'])
  end

  def initialize_fields
    self.status = "Active"
    self.expiration_date = 1.year.from_now
  end

  def ensure_authentication_token
    if authentication_token.blank?
      self.authentication_token = generate_authentication_token
    end
  end


  def self.from_omniauth(auth)
    joins(:authentications).where(authentication: {provider: auth.provider,
                                                   uid: auth.uid}).first_or_create do |user|
      user.authentications.build(provider: auth.provider, uid: auth.uid)
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      user.first_name = auth.info.first_name   # assuming the user model has a name
      user.last_name = auth.info.last_name
      user.image = auth.info.image # assuming the user model has an image
    end
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.google_data"] && session["devise.google_data"]["info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end

  private

  def generate_authentication_token
    loop do
      token = Devise.friendly_token
      break token unless User.where(authentication_token: token).first
    end
  end
end
