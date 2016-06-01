class FilmsController < ApplicationController
    before_action :set_inventory_and_film, only: [:show, :edit, :update, :destroy]

    # GET /films
    def index
        @films = Film.all
    end

    # GET /films/1
    def show
    end

    # GET /films/new
    def new
        @inventory_item = InventoryItem.new
        @film = Film.new
        
        #@inventory_item.inventoriable = @film
        
        authorize Film
    end

    # GET /films/1/edit
    def edit
        authorize Film
    end

    # POST /films
    def create
    
        @inventory_item = InventoryItem.new(inventory_item_params)
        @film = Film.new(film_params)
        authorize @film
        
        @inventory_item.inventoriable = @film
    
        if @inventory_item.save
            flash[:success] = t "#{@i18n_path}.success", scope: "forms",
                                title: @film.english_title, catalog_number: @inventory_item.catalog_number
            redirect_to films_path
        else
            render :new
        end
    end

    # PATCH/PUT /films/1
    def update
        
        authorize @film
    
        if @inventory_item.update(inventory_item_params) && @film.update(film_params)
            flash[:success] = t "#{@i18n_path}.success", scope: "forms", title: @film.english_title
            redirect_to film_path(@film)
        else
            render :edit
        end
    end

    # DELETE /films/1
    def destroy
        
        authorize @film
      
        @inventory_item.destroy
        flash[:success] = t "#{@i18n_path}.success", scope: "forms", title: @film.english_title
        redirect_to films_path
    end

    private
    
        def set_inventory_and_film
            @inventory_item = InventoryItem.films.find_by(inventoriable_id: params[:id])
            @film = @inventory_item.inventoriable
        end
    
        def film_params
            params[:inventory_item][:film].permit(:film_type, :english_title, :foreign_title, :description, :year,
                    :length, :mpaa_rating, :tag_list, :director_list, :cast_member_list, :genre_list,
                    audio_languages: [], subtitle_languages: [])
        end
end