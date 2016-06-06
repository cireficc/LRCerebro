class TagsController < ApplicationController
    def index
        @tags = ActsAsTaggableOn::Tag
                .where("name LIKE ?", "#{params[:name]}%")
                .where.not(name: params[:tags_chosen])
                .includes(:taggings)
                .where(taggings: {taggable_type: params[:taggable_type], context: params[:context] })
        render json: @tags
    end
end
