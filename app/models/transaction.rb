class Transaction < ApplicationRecord
  belongs_to :user
  belongs_to :ticket
  enum transaction_type: { reserve: "reserve", purchase: "purchase", cancel: "cancel" }
end
