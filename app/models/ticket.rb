class Ticket < ApplicationRecord
  belongs_to :performance
  belongs_to :user, optional: true
  enum status: { available: "available", sold: "sold", cancelled: "cancelled" }
end
