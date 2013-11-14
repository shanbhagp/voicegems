class AddAnotherColumnToVoicegems < ActiveRecord::Migration
  def change
    add_column :voicegems, :vgrec, :string
  end
end
