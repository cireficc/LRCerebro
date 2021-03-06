class FilmsController < ApplicationController
	before_action :set_film, only: [:show, :edit, :update, :destroy]

	# GET /films/autocomplete
	def autocomplete
		@films = FilmDecorator.decorate_collection(
				Film.search(params[:search],
				            match: :word_start,
				            fields: [:english_title, :foreign_title, :transliterated_foreign_title, :catalog_number],
				            misspellings: {edit_distance: 2, below: 1},
				            limit: 5,
				            order: {catalog_number: :asc}))
		render json: @films, each_serializer: FilmAutocompleteSerializer
	end

	# GET /films
	def index

		# For exports, get all records, otherwise, paginate at 25 per page
		@limit = params[:all_records] ? Film.count : 25
		@order = {catalog_number: :asc}
		@includes = [:genres, :directors, :cast_members, :digitized_versions]

		@where = {}
		@where[:audio_languages] = {all: params[:audio_languages]} if params[:audio_languages].present?
		@where[:subtitle_languages] = {all: params[:subtitle_languages]} if params[:subtitle_languages].present?
		# One input for any taggable field, so OR them together
		@tag_array = params[:tag_list].split(",") if params[:tag_list].present?
		@where[:or] = [[
				               {director_list: @tag_array},
				               {cast_member_list: @tag_array},
				               {genre_list: @tag_array}
		               ]] if @tag_array

		if params[:search].present?
			@films = FilmDecorator.decorate_collection(Film.search(
					params[:search],
					includes: @includes,
					fields: [
							:english_title,
							:foreign_title,
							:description,
							{catalog_number: :exact}
					],
					misspellings: {edit_distance: 2, below: 1},
					where: @where,
					order: @order, page: params[:page], per_page: @limit
			))
		else
			@films = FilmDecorator.decorate_collection(Film.search(
					"*",
					includes: @includes,
					where: @where,
					order: @order, page: params[:page], per_page: @limit
			))
		end

		respond_to do |format|
			format.html
			format.xls do
				response.headers['Content-Type'] = 'text/xls; charset=UTF-8; header=present'
				response.headers['Content-Disposition'] = 'attachment; filename=LRC film export.xls'
				render 'index', layout: false
			end
		end
	end

	# GET /films/1
	def show
		lrc_wired_subnet = IPAddr.new("35.39.169.0/24")
		lrc_wireless_subnet = IPAddr.new("35.39.168.0/24")
		ip = IPAddr.new(request.ip)
		@ip_in_lrc_subnet = ((lrc_wired_subnet.include? ip) || (lrc_wireless_subnet.include? ip))
	end

	# GET /films/new
	def new
		@film = Film.new

		authorize Film
	end

	# GET /films/1/edit
	def edit
		authorize Film
	end

	# POST /films
	def create

		@film = Film.new(film_params)
		authorize @film

		if @film.save
			flash[:success] = t "#{@i18n_path}.success", scope: "forms",
			                    title: @film.english_title, catalog_number: @film.catalog_number
			redirect_to films_path
		else
			flash[:danger] = t :submission_errors, scope: 'forms'
			render :new
		end
	end

	# PATCH/PUT /films/1
	def update

		authorize @film

		if @film.update(film_params)
			flash[:success] = t "#{@i18n_path}.success", scope: "forms", title: @film.english_title
			redirect_to film_path(@film)
		else
			flash[:danger] = t :submission_errors, scope: 'forms'
			render :edit
		end
	end

	# DELETE /films/1
	def destroy

		authorize @film

		@film.destroy
		flash[:success] = t "#{@i18n_path}.success", scope: "forms", title: @film.english_title
		redirect_to films_path
	end

	private

	def set_film
		@film = Film.find(params[:id])
	end

	def film_params
		params[:film].permit(:catalog_number, :more_info_link, :film_type, :english_title, :foreign_title,
		                     :transliterated_foreign_title, :description, :year, :length, :mpaa_rating,
		                     :director_list, :cast_member_list, :genre_list, :cover, :cover_cache,
		                     :remote_cover_url, audio_languages: [], subtitle_languages: [],
		                     digitized_versions_attributes: [:id, :foreign_title, :english_title, :audio_language,
		                                                     :subtitle_language, :direct_link, :embed_code, :_destroy])
	end
end
