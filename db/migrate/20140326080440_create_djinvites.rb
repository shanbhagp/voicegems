class CreateDjinvites < ActiveRecord::Migration
  def change
    create_table :djinvites do |t|
      t.string :sender_name
      t.string :sender_email
      t.string :recipient_name
      t.string :recipient_email
      t.datetime :sent_at
      t.string :invite_type

      t.timestamps
    end
  end
end
