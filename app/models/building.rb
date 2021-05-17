class Building < ActiveRecord::Base
    has_many :teachers
    has_many :students through: :teachers
end