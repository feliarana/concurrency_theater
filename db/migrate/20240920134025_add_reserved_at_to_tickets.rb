class AddReservedAtToTickets < ActiveRecord::Migration[7.2]
  def change
    add_column :tickets, :reserved_at, :datetime
  end
end
