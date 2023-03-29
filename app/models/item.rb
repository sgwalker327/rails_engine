class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items
  has_many :invoices, through: :invoice_items

  validates :name, :description, presence: true
  validates :unit_price, presence: true, numericality: true
  validates_numericality_of :merchant_id, presence: true
end