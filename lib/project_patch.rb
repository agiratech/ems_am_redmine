module ProjectPatch
	def self.included(base)
		base.send(:include, InstanceMethods)
    base.class_eval do
    end
	end
	module InstanceMethods
		def projects_list
			Project.all
		end
	end
end
