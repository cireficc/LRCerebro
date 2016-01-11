class CoursesController < ApplicationController
    before_action :set_course, only: [:show, :edit, :update, :destroy]

    # GET /courses
    def index
        authorize Course
        @courses = Course.all.order(:name)
    end

    # GET /courses/1
    def show
        @course = Course.find(params[:id])
        authorize @course
    end

    # GET /courses/new
    def new
        @course = Course.new
        authorize @course
    end

    # GET /courses/1/edit
    def edit
        authorize Course
    end

    # POST /courses
    def create
    
        @course = Course.new(course_params)
        authorize @course
    
        if @course.save
            flash[:success] = "#{@course.name} has been successfully created"
            redirect_to courses_path
        else
            render :new
        end
    end

    # PATCH/PUT /courses/1
    def update
        
        authorize @course
    
        if @course.update(course_params)
            flash[:success] = "#{@course.name} has been successfully updated"
            redirect_to courses_path
        else
            render :edit
        end
    end

    # DELETE /courses/1
    def destroy
        
        authorize @course
      
        @course.destroy
        flash[:success] = "#{@course.name} has been successfully deleted"
        redirect_to courses_path
    end

    private
    
        # Use callbacks to share common setup or constraints between actions.
        def set_course
            @course = Course.find(params[:id])
        end
    
        # Never trust parameters from the scary internet, only allow the white list through.
        def course_params
            params[:course].permit(:year, :semester, :department, :course, :section, :name, user_ids: [])
        end
end
