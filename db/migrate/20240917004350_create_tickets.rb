class CreateTickets < ActiveRecord::Migration[7.2]
  def change
    create_table :tickets do |t|
      t.references :performance, null: false, foreign_key: true
      t.references :user, foreign_key: true
      t.integer :price
      t.string :status

      t.timestamps
    end
  end
end
