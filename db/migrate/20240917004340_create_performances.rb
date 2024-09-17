class CreatePerformances < ActiveRecord::Migration[7.2]
  def change
    create_table :performances do |t|
      t.string :title
      t.datetime :date
      t.integer :tickets_available

      t.timestamps
    end
  end
end
