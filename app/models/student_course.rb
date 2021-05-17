class StudentCourse < ActiveRecord::Base
    belongs_to :Student
    belongs_to :course
end