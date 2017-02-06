module ApplicationHelperPatch
	def self.included(base) # :nodoc:
		base.extend(ClassMethods)
		base.send(:include, InstanceMethods)
		base.class_eval do
		end
	end

	module ClassMethods

	end

	module InstanceMethods
		def collect_linked_projects parent_issue_id
			Issue.find(parent_issue_id).projects.uniq!
		end
	end
end