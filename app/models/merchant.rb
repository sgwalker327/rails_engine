class Merchant < ApplicationRecord
  has_many :items
  has_many :invoices
  has_many :invoice_items, through: :items
  has_many :transactions, through: :invoices
  has_many :customers, through: :invoices

  def self.name_search(name_params)
    where("name ILIKE ?", "%#{name_params}%").order(:name).first
  end
  
end