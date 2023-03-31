class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items
  has_many :invoices, through: :invoice_items

  validates :name, :description, presence: true
  validates :unit_price, presence: true, numericality: true
  validates_numericality_of :merchant_id, presence: true

  def self.name_search(name)
    where("name ILIKE ?", "%#{name}%").order("LOWER(name)")
  end

  def self.min_price_search(min_price)
    where("unit_price >= ?", min_price).order("LOWER(name)")
  end

  def self.max_price_search(max_price)
    where("unit_price <= ?", max_price).order("LOWER(name)")
  end

  def self.price_range_search(min_price, max_price)
    where("unit_price >= ? AND unit_price <= ?", min_price, max_price).order("LOWER(name)")
  end
end