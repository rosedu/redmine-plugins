class CreateTestForms < ActiveRecord::Migration
  def self.up
    create_table "test_forms", :force => true do |t|
      t.integer  "project_id",   :default => 0, :null => false
      t.string   "title",	:limit => 60, :default => "", :null => false
      t.text     "description"
      t.datetime "created_on"
    end
  add_index "test_forms",["created_on"],:name => "index_test_forms_on_created_on"
  add_index "test_forms", ["project_id"], :name => "test_forms_project_id"
end

  def self.down
    drop_table :test_forms
  end
end
