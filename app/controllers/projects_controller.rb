class ProjectsController < ApplicationController
    
    def new
        @project = Project.new
        @num_training = Project::CATEGORY_TRAINING_EVENTS.values[0]
        @num_editing = Project::CATEGORY_EDITING_EVENTS.values[0]
        
        @num_training.times { @project.project_reservations.build :category => ProjectReservation.categories[:training] }
        @num_editing.times { @project.project_reservations.build :category => ProjectReservation.categories[:editing] }
        
        puts "Project: #{@project.project_reservations.length}"
    end
    
    def create
        @project = params[:project]
        # Convert the DateTimePicker's text value to a DateTime so that it can be stored in the database
        @project[:script_due] = DateTime.strptime(@project[:script_due], DATE_TIME_PICKER_FORMAT) unless @project[:script_due].blank?
        @project[:due] = DateTime.strptime(@project[:due], DATE_TIME_PICKER_FORMAT) unless @project[:due].blank?
        @project[:viewable_by] = DateTime.strptime(@project[:viewable_by], DATE_TIME_PICKER_FORMAT) unless @project[:viewable_by].blank?
        
        
        
        @reservations = @project[:project_reservations_attributes].select { |index, res| res[:_destroy] == "false" && (!res[:start].blank? && !res[:end].blank?) }
        
        @reservations.each do |index, res|
            puts "Index: #{index}, res: #{res}\n\n"
            res[:start] = DateTime.strptime(res[:start], DATE_TIME_PICKER_FORMAT)
            res[:end] = DateTime.strptime(res[:end], DATE_TIME_PICKER_FORMAT)
            res[:lab] = Lab.locations[res[:lab]]
        end
        
        @project_save = Project.new(project_params)
        
        if @project_save.save
            flash[:success] = "Your project, #{@project_save.name}, has been successfully submitted!"
            redirect_to root_path
        else
            render 'new'
        end
    end
    
    private
    
    def project_params
        params.require(:project).permit(:course_id, :category, :name, :description, :script_due, :due, :viewable_by, project_reservations_attributes: [:start, :end, :lab, :_destroy])
    end
end
