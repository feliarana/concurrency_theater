class Ticket < ApplicationRecord
  belongs_to :performance
  belongs_to :user
  enum status: { available: "available", reserved: "reserved", purchased: "purchased", cancelled: "cancelled" }
end
