module ProjectsControllerPatch
	def self.included(base) # :nodoc:
		base.extend(ClassMethods)
		base.send(:include, InstanceMethods)
		base.class_eval do
			alias_method_chain :show, :custom_show
		end
	end

	module ClassMethods
	end

	module InstanceMethods

		def show_with_custom_show
			# try to redirect to the requested menu item
			if params[:jump] && redirect_to_project_menu_item(@project, params[:jump])
				return
			end

			@users_by_role = @project.users_by_role
			@subprojects = @project.children.visible.to_a
			@news = @project.news.limit(5).includes(:author, :project).reorder("#{News.table_name}.created_on DESC").to_a
			@trackers = @project.rolled_up_trackers.visible
			project_cond = @project.project_condition(Setting.display_subprojects_issues?)
			cond = "#{project_cond} OR #{Issue.table_name}.id IN (SELECT issue_id FROM issues_projects WHERE project_id = #{@project.id})"
			@open_issues_by_tracker = Issue.visible.open.where(cond).group(:tracker).count
			@total_issues_by_tracker = Issue.visible.where(cond).group(:tracker).count

			if User.current.allowed_to_view_all_time_entries?(@project)
				@total_hours = TimeEntry.visible.where(project_cond).sum(:hours).to_f
			end

			@key = User.current.rss_key

			respond_to do |format|
				format.html
				format.api
			end
		end
	end
end