class CreateIssuesProjects < ActiveRecord::Migration
  def self.up
    create_table :issues_projects, :id => false do |t|
      t.belongs_to :issue
      t.belongs_to :project
    end
    add_index :issues_projects, [:issue_id, :project_id]
  end
  def self.down
    drop_table :issues_projects
  end
end
