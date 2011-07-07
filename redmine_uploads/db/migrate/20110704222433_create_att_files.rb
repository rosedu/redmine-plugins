class CreateAttFiles < ActiveRecord::Migration
  def self.up
    create_table :att_files do |t|
     t.column :upload_form_id, :integer
    end
  end

  def self.down
    drop_table :att_files
  end
end
