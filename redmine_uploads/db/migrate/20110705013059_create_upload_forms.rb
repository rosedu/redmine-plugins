class CreateUploadForms < ActiveRecord::Migration
  def self.up
    create_table :upload_forms do |t|
      t.column :title, :string
      t.column :description, :string
      t.column :project_id, :integer
      t.column :created_on, :timestamp
    end
  end

  def self.down
    drop_table :upload_forms
  end
end
