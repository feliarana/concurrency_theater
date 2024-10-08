class Ticket < ApplicationRecord
  belongs_to :performance
  belongs_to :user, optional: true
  enum status: { available: "available", reserved: "reserved", purchased: "purchased", cancelled: "cancelled" }

  validate :user_must_be_present_if_reserved

  def can_be_cancelled?(user_id: nil)
    (status == "reserved" || status == "purchased") && user_id == self.user_id
  end

  def can_be_purchased?(user_id: nil)
    status == "reserved" && user_id == self.user_id
  end

  def available?(user_id: nil)
    status == "available"
  end

  def reserved?(user_id: nil)
    return false if status == "reserved" && reserved_at.nil? && user_id == nil

    if reserved_until.present? && reserved_until >= Time.zone.now
      true
    else
      mark_as_available_if_reserved
      false
    end
  end

  private

  def mark_as_available_if_reserved
    return if status != "reserved"

    update_columns(status: "available", reserved_at: nil, reserved_until: nil, user_id: nil)
  end

  def user_must_be_present_if_reserved
    if reserved? && user_id.nil?
      errors.add(:user, "must be present when the ticket is reserved")
    end
  end
end
