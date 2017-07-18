class VidcamsController < ApplicationController
    
    def index
        @limit = 50
        @order = { start: :desc }
        @includes = [:course]

        @where = {}
        @where[:submitted_by] = params[:submitted_by] if params[:submitted_by].present?
        @where[:course] = params[:course] if params[:course].present?
        # Default archived to false if it hasn't been selected out yet
        params[:archived] = false if params[:archived].blank?
        @where[:archived] = params[:archived]
        
        # Hack Elasticsearch to gain back the functionality that we had with Pundit scoping
        # Director/labasst have full access to all projects, faculty/students only to their own
        @where[:members] = current_user.id if (current_user && (current_user.faculty? || current_user.student?))
        
        @vidcams = VidcamDecorator.decorate_collection(Vidcam.search(
            "*",
            includes: @includes,
            where: @where,
            order: @order, page: params[:page], per_page: @limit
        ))
    end
    
    def new
        
        @vidcam = Vidcam.new
        authorize @vidcam
    end
    
    def create

        @vidcam = Vidcam.new(create_params)
        authorize @vidcam
        
        if @vidcam.save
            @submit_another_html = view_context.link_to("Submit another vidcam request", new_vidcam_path, {class: 'btn btn-info'})
            flash[:success] = t "#{@i18n_path}.success", scope: "forms", course: @vidcam.course.decorate.short_name,
                                location: @vidcam.location, start: @vidcam.start, submit_another_html: @submit_another_html
            redirect_to vidcams_path
        else
            flash[:danger] = t :submission_errors, scope: "forms"
            render :new
        end
    end
    
    def show
        @vidcam = Vidcam.find(params[:id]).decorate
        authorize @vidcam
        
        # Set the present check-box so that it is checked properly when the form is rendered
        @vidcam.present = "1" if !@vidcam.publish_by.nil?
    end
    
    def edit
        @vidcam = Vidcam.find(params[:id]).decorate
        authorize @vidcam
        @vidcam.present = "1" if !@vidcam.publish_by.nil?
    end
    
    def update
        @vidcam = Vidcam.find(params[:id])
        authorize @vidcam
        
        if @vidcam.update_attributes(update_params)
            flash[:success] = t "#{@i18n_path}.success", scope: "forms", course: @vidcam.course.decorate.short_name,
                                location: @vidcam.location, start: @vidcam.start
            redirect_to vidcam_path(@vidcam)
        else
            flash[:danger] = t :submission_errors, scope: "forms"
            render :edit
        end
    end
    
    def destroy
        @vidcam = Vidcam.find(params[:id])
        authorize @vidcam

        @vidcam.destroy
        flash[:success] = t "#{@i18n_path}.success", scope: "forms", course: @vidcam.course.decorate.short_name,
                            location: @vidcam.location, start: @vidcam.start
        redirect_to vidcams_path
    end
    
    private
    
    def create_params
        params.require(:vidcam).permit(policy(Vidcam).create_attributes)
    end
    
    def update_params
        params.require(:vidcam).permit(policy(@vidcam).update_attributes)
    end
end
