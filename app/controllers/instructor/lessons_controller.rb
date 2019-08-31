class Instructor::LessonsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :authenticate_user!
  before_action :require_authorized_for_current_lesson, only: [:update]

  def create
    @lesson = current_section.lessons.create(lesson_params)
    redirect_to instructor_course_path(current_section.course)
  end

  def update
    current_lesson.update_attributes(lesson_params)
    render plain: 'updated!'
  end

  def show
    @lesson = current_section.lessons(all)
  end


  private

  def require_authorized_for_current_lesson
    if current_lesson.section.course.user != current_user
      render plain: 'Unauthorized', status: :unauthorized
    end
  end

  helper_method :current_section
  def current_lesson
    @current_lesson ||= Lesson.find(params[:id])
  end

  def current_section
    if params[:section_id] 
    @current_section ||= Section.find(params[:section_id])
  else
    current_lesson.section
  end
end
  
  def lesson_params
    params.require(:lesson).permit(:title, :subtitle, :video, :row_order_position)
  end
end
