class Ticket < ApplicationRecord
  belongs_to :performance
  belongs_to :user, optional: true
  enum status: { available: "available", reserved: "reserved", purchased: "purchased", cancelled: "cancelled" }

  validate :user_must_be_present_if_reserved

  private

  def user_must_be_present_if_reserved
    if reserved? && user_id.nil?
      errors.add(:user, "must be present when the ticket is reserved")
    end
  end
end
