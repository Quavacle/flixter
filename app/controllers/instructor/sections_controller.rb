class Instructor::SectionsController < ApplicationController
 skip_before_action :verify_authenticity_token
  before_action :authenticate_user!
  before_action :require_authorized_for_section

  def create
    @section = current_course.sections.create(section_params)
    redirect_to instructor_course_path(current_course)
  end

def update
    current_section.update_attributes(section_params)
    render plain: 'updated!'
end

private
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

def require_authorized_for_section
  if current_course.user != current_user
    render plain: "Unauthorized", status: :unauthorized
  end
end

def section_params
  params.require(:section).permit(:title, :row_order_position)
end
end