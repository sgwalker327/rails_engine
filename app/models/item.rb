class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items
  has_many :invoices, through: :invoice_items

  def merchant_items(merchant_id)
    Item.where(merchant_id: merchant_id)
  end
end