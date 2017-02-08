module ProjectPatch

	def self.included(base)
		base.send(:include, InstanceMethods)
		base.class_eval do
		end
	end

	module InstanceMethods
		def projects_list
			if User.current.admin?
				Project.active
			else
				User.last.projects.active && Project.where(is_public:true).active
			end
		end
	end
end
