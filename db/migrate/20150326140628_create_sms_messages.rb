class CreateSmsMessages < ActiveRecord::Migration
  def change
    create_table :sms_messages do |t|
      t.string :name
      t.string :phone
      t.string :description
      t.date :effected_at
      t.boolean :status

      t.timestamps null: false
    end
  end
end
