Redmine::Plugin.register :ems_am_redmine do
  name 'EMS AM Redmine Plugin'
  author 'Agira Technologies'
  description 'This is a plugin for Redmine - AM Events & AM Action'
  version '1.0.0'
  url 'http://www.agiratech.com/'
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
