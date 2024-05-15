class User < ApplicationRecord
  has_secure_password
  has_one :buyer
  has_one :seller
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, confirmation: true, length: { minimum: 8 }
  before_save :set_created_on

  private

  def set_created_on
    self.created_on ||= Time.zone.now
  end
  
end
