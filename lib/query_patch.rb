module QueryPatch
  def self.included(base)
    base.send(:include, InstanceMethods)
    base.class_eval do
      alias_method_chain :project_statement, :linked_projects
    end
  end
  module InstanceMethods
    def project_statement_with_linked_projects
      project_clauses = project_statement_without_linked_projects
      if self.is_a?(IssueQuery)
        if project_clauses
          "((#{project_clauses}) OR #{Issue.table_name}.id IN (SELECT issue_id FROM issues_projects WHERE project_id = #{project.id}))"
        else
          nil
        end
      else
        project_clauses
      end
    end
  end
end
