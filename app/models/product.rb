class Product < ApplicationRecord
  belongs_to :seller
  before_save :set_created_on
  validates :name, :description, :price, :stock, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }
  private

  def set_created_on
    self.created_on ||= Time.zone.now
  end
end
