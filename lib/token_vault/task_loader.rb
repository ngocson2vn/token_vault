module TokenVault
	class TaskLoader < Rails::Railtie
		rake_tasks do
			load 'tasks/update_vault.rake'
		end
	end
end
