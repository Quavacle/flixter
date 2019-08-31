class Instructor::CoursesController < ApplicationController
   skip_before_action :verify_authenticity_token
  before_action :authenticate_user!
  before_action :require_authorized_for_current_course, only: [:show]

  def new
    @course = Course.new
  end

  def create
    @course = current_user.courses.create(course_params)
    if @course.valid?
      redirect_to instructor_course_path(@course)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @course = current_user.courses
    @section = Section.new
    @lesson = Lesson.new
  end
 
  def index
    @course = current_user.courses
  end



  
  private

  def require_authorized_for_current_course
    if current_course.user != current_user
      render plain: "Unauthorized", status: :unauthorized
    end
  end
helper_method :current_course

def current_section
  @current_section = Section.find(params[:id])
end

def current_course
  if params[:course_id]
    @current_course ||= Course.find(params[:course_id])
  else
    current_section.course
  end
end

  def course_params
    params.require(:course).permit(:title, :description, :cost, :image)
  end
end