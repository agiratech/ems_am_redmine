module IssueQueryPatch
  def self.included(base)
    base.extend(ClassMethods)
    base.send(:include, InstanceMethods)
    base.class_eval do
      alias_method_chain :versions, :linked_projects
    end
  end
  module ClassMethods

  end
  module InstanceMethods
    def versions_with_linked_projects(options={})
      Version.visible.
          where(project_statement_without_linked_projects).
          where(options[:conditions]).
          includes(:project).
          references(:project).
          to_a
    rescue ::ActiveRecord::StatementInvalid => e
      raise StatementInvalid.new(e.message)
    end
  end
end
