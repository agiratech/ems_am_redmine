module CalendarsControllerPatch
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
	    if params[:year] and params[:year].to_i > 1900
	      @year = params[:year].to_i
	      if params[:month] and params[:month].to_i > 0 and params[:month].to_i < 13
	        @month = params[:month].to_i
	      end
	    end
	    @year ||= User.current.today.year
	    @month ||= User.current.today.month

	    @calendar = Redmine::Helpers::Calendar.new(Date.civil(@year, @month, 1), current_language, :month)
	    retrieve_query
	    @query.group_by = nil
	    if @query.valid?
	      events = []
	      events += @query.issues(:include => [:tracker, :assigned_to, :priority],
	                              :conditions => ["((start_date BETWEEN ? AND ?) OR (due_date BETWEEN ? AND ?))", @calendar.startdt, @calendar.enddt, @calendar.startdt, @calendar.enddt]
	                              )
	      # events += @query.versions(:conditions => ["effective_date BETWEEN ? AND ?", @calendar.startdt, @calendar.enddt])

	      @calendar.events = events
	    end

	    render :action => 'show', :layout => false if request.xhr?
	  end
	end
end