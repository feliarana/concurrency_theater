class Ticket < ApplicationRecord
  belongs_to :performance
  belongs_to :user, optional: true
  enum status: { available: "available", reserved: "reserved", purchased: "purchased", cancelled: "cancelled" }

  validate :user_must_be_present_if_reserved


  def can_be_cancelled?(user_id: nil)
    status == "reserved" || status == "purchased"
  end

  def can_be_purchased?(user_id: nil)
  end

  def available?(user_id: nil)
    status == "available"
  end

  def purchased?(user_id: nil)
    status == "purchased"
  end

  def reserved?(user_id: nil)
    return false if reserved_at.nil? && status != "reserved"

    if reserved_at.present? && reserved_at >= Time.zone.now
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
