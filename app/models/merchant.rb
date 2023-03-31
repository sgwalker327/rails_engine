class Merchant < ApplicationRecord
  has_many :items
  has_many :invoices
  has_many :invoice_items, through: :items
  has_many :transactions, through: :invoices
  has_many :customers, through: :invoices

  def self.name_search(name)
    where("name ILIKE ?", "%#{name}%").order("LOWER(name)").first
  end
end