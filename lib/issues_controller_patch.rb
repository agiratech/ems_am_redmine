module IssuesControllerPatch
	def self.included(base) # :nodoc:
		base.extend(ClassMethods)
		base.send(:include, InstanceMethods)
		base.class_eval do
			alias_method_chain :create, :custom_create
			alias_method_chain :update, :custom_update
			alias_method_chain :new, :custom_new
		end
	end

	module ClassMethods
	end

	module InstanceMethods

		def new_with_custom_new
			if @issue.tracker.name.upcase == "AM EVENTS" && params[:issue] && params[:issue][:parent_issue_id].present?
				@issue.tracker = Tracker.find_by_name("AM ACTIONS" || "AM Actions")
				@issue.parent_issue_id = params[:issue][:parent_issue_id]
			end
			respond_to do |format|
				format.html { render :action => 'new', :layout => !request.xhr? }
				format.js
			end
		end

		def create_with_custom_create
			unless User.current.allowed_to?(:add_issues, @issue.project, :global => true)
				raise ::Unauthorized
			end
			call_hook(:controller_issues_new_before_save, { :params => params, :issue => @issue })
			find_linked_projects(params)
			@issue.project_ids = []
			@issue.save_attachments(params[:attachments] || (params[:issue] && params[:issue][:uploads]))
			if @issue.save
				@issue.projects << @projects if @projects
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

	  def update_with_custom_update
	    return unless update_issue_from_params
	    find_linked_projects(params)
	    @issue.project_ids = []
	    @issue.projects << @projects if @projects
	    @issue.save_attachments(params[:attachments] || (params[:issue] && params[:issue][:uploads]))
	    saved = false
	    begin
	      saved = save_issue_with_child_records
	    rescue ActiveRecord::StaleObjectError
	      @conflict = true
	      if params[:last_journal_id]
	        @conflict_journals = @issue.journals_after(params[:last_journal_id]).to_a
	        @conflict_journals.reject!(&:private_notes?) unless User.current.allowed_to?(:view_private_notes, @issue.project)
	      end
	    end

	    if saved
	      render_attachment_warning_if_needed(@issue)
	      flash[:notice] = l(:notice_successful_update) unless @issue.current_journal.new_record?

	      respond_to do |format|
					if Redmine::VERSION::MAJOR >= 3 && Redmine::VERSION::MINOR >=3
						format.html { redirect_back_or_default issue_path(@issue, previous_and_next_issue_ids_params) }
					else
						format.html { redirect_back_or_default issue_path(@issue) }
					end
	        format.api  { render_api_ok }
	      end
	    else
	      respond_to do |format|
	        format.html { render :action => 'edit' }
	        format.api  { render_validation_errors(@issue) }
	      end
	    end
	  end

		def find_linked_projects params
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
		end

	end
end