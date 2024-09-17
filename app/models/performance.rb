class Performance < ApplicationRecord
  has_many :tickets, dependent: :destroy
end
