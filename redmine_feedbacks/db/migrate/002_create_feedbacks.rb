class CreateFeedbacks < ActiveRecord::Migration
  def self.up
    create_table :feedbacks do |t|
      t.column :project_id, :integer
      t.column :created_on, :Timestamp
      t.column :title, :string
      t.column :description, :string
    end
  end

  def self.down
    drop_table :feedbacks
  end
end
