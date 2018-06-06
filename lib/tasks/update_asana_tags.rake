require 'asana'

namespace :asana do
	desc 'Updates tags in Asana for the new semester course/faculty data'
	task update_tags: :environment do

		AsanaHelper.update_tags
	end
end
