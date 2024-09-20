class Ticket < ApplicationRecord
  belongs_to :performance
  belongs_to :user, optional: true
  enum status: { available: "available", reserved: "reserved", purchased: "purchased", cancelled: "cancelled" }

  validate :user_must_be_present_if_reserved

  def reserved?
    return false if reserved_at.nil?

    if reserved_at >= Time.zone.now
      true
    else
      mark_as_available_if_reserved
      false
    end
  end

  private

  def mark_as_available_if_reserved
    update(status: "available") if status == "reserved"
  end

  def user_must_be_present_if_reserved
    if reserved? && user_id.nil?
      errors.add(:user, "must be present when the ticket is reserved")
    end
  end
end
