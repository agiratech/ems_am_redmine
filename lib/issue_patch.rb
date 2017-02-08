module IssuePatch
	def self.included(base)
		base.send(:include, InstanceMethods)
		base.class_eval do
			# unloadable # Send unloadable so it will not be unloaded in development
			has_and_belongs_to_many :projects
			safe_attributes  'project_ids'
		end
	end
	
	module InstanceMethods
	end
end
