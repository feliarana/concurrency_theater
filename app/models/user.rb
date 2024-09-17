class User < ApplicationRecord
  has_many :tickets
  has_many :transactions
end
