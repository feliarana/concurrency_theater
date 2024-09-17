class CreateTransactions < ActiveRecord::Migration[7.2]
  def change
    create_table :transactions do |t|
      t.references :user, null: false, foreign_key: true
      t.references :ticket, null: false, foreign_key: true
      t.integer :amount
      t.string :transaction_type
      t.string :status

      t.timestamps
    end
  end
end
