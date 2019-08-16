class LessonsController < ApplicationController
   before_action :require_authorized_for_lesson
  def show
  end

  private


  def require_authorized_for_lesson
    if current_user.enrolled_in?(current_lesson.section.course)    
    else
      redirect_to course_path(current_lesson.section.course), alert: 'Please log-in/sign-up to enroll in this course to view lessons'
    end
  end

  helper_method :current_lesson
  def current_lesson
    @current_lesson ||= Lesson.find(params[:id])
  end
end

