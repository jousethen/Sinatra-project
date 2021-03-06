class Course < ActiveRecord::Base
    belongs_to :teacher
    has_many :student_courses
    has_many :students, through: :student_courses

    extend Slugfiable::ClassMethods
    include Slugfiable::InstanceMethods
end