Redmine::Plugin.register :ems_am_redmine do
  name 'Ems Am Redmine Plugin'
  author 'Agira Technologies'
  description 'This is a plugin for Redmine'
  version '0.0.1'
  url 'https://github.com/agiratech/ems_am_redmine'
  author_url 'http://www.agiratech.com/'
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