namespace :searchkick do
	desc 'Delete Searchkick/Elasticsearch indexes and reindex (avoids cluster_block_exception on index writes)'
	task reset_indexes: :environment do

		Course.search_index.delete
		Film.search_index.delete
		FilmDigitization.search_index.delete
		MiniProject.search_index.delete
		Project.search_index.delete
		StandardReservation.search_index.delete
		User.search_index.delete
		Vidcam.search_index.delete
		Work.search_index.delete

		Rake::Task['searchkick:reindex:all'].invoke
	end
end
