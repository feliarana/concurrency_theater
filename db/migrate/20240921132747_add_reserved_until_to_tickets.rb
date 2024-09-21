class AddReservedUntilToTickets < ActiveRecord::Migration[7.2]
  def change
    add_column :tickets, :reserved_until, :datetime
  end
end
