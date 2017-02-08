module IssuesControllerPatch
	def self.included(base) # :nodoc:
		base.extend(ClassMethods)
		base.send(:include, InstanceMethods)
		base.class_eval do
			alias_method_chain :create, :custom_create
		end
	end

	module ClassMethods
	end

	module InstanceMethods

		def create_with_custom_create
			unless User.current.allowed_to?(:add_issues, @issue.project, :global => true)
				raise ::Unauthorized
			end
			call_hook(:controller_issues_new_before_save, { :params => params, :issue => @issue })
			if params[:issue] && params[:issue][:project_ids]
				@projects = []
				params[:issue][:project_ids].reject!(&:blank?)
				if params[:issue][:project_ids].present?
					Project.find(params[:issue][:project_ids]).each do |p|
					@projects << p unless (params[:project_id] == p.id.to_s || params[:issue][:project_id]  == p.id.to_s)
					end
				end
				@projects.uniq!
			end
			@issue.save_attachments(params[:attachments] || (params[:issue] && params[:issue][:uploads]))
			if @issue.save
				@issue.projects << @projects
				call_hook(:controller_issues_new_after_save, { :params => params, :issue => @issue})
				respond_to do |format|
					format.html {
						render_attachment_warning_if_needed(@issue)
						flash[:notice] = l(:notice_issue_successful_create, :id => view_context.link_to("##{@issue.id}", issue_path(@issue), :title => @issue.subject))
						redirect_after_create
					}
					format.api  { render :action => 'show', :status => :created, :location => issue_url(@issue) }
				end
				return
			else
				respond_to do |format|
					format.html {
						if @issue.project.nil?
							render_error :status => 422
						else
							render :action => 'new'
						end
					}
					format.api  { render_validation_errors(@issue) }
				end
			end
		end
	end
end