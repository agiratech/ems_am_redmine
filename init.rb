Redmine::Plugin.register :ems_am_redmine do
  name 'Ems Am Redmine Plugin plugin'
  author 'Author name'
  description 'This is a plugin for Redmine'
  version '0.0.1'
  url 'http://example.com/path/to/plugin'
  author_url 'http://example.com/about'
end

Rails.application.config.to_prepare do
	Project.send(:include, ProjectPatch)
	Issue.send(:include,IssuePatch)
	ApplicationHelper.send(:include, ApplicationHelperPatch)
	IssuesController.send(:include,IssuesControllerPatch)
  Query.send(:include,QueryPatch)
  IssueQuery.send(:include,IssueQueryPatch)
  ProjectsController.send(:include,ProjectsControllerPatch)
end