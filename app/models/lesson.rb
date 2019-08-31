class Lesson < ApplicationRecord
  belongs_to :section
  mount_uploader :video, VideoUploader

  include RankedModel
  ranks :row_order, with_same: :section_id

  def next_lesson
    lesson = section.lessons.where("row_order > ?", self.row_order).rank(:row_order).first
    return lesson
  end

  def previous_lesson
    lesson = section.lessons.where("row_order < ?", self.row_order).rank(:row_order).last
    return lesson
  end
end
