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
		def select_tracker issue
			@tracker = Tracker.where(" upper(name) = ?","AM ACTIONS").first
			@tracker.present? ? @tracker.id : issue.tracker.id
		end
	end
end