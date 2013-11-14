class AddColumnToVoicegems < ActiveRecord::Migration
  def change
    add_column :voicegems, :zen_job_id, :integer
  end
end
