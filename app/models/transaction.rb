class Transaction < ApplicationRecord
  belongs_to :user
  belongs_to :ticket
  enum transaction_type: { purchase: "purchase", cancellation: "cancellation" }
end
