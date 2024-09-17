class Transaction < ApplicationRecord
  belongs_to :user
  belongs_to :ticket
  enum transaction_type: { reservation: "reservation", purchase: "purchase", cancellation: "cancellation" }
end
