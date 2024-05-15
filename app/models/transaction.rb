class Transaction < ApplicationRecord
  belongs_to :buyer
  belongs_to :product
  before_save :set_created_on

  private

  def set_created_on
    self.created_on ||= Time.zone.now
  end
end
