class Appointment < ActiveRecord::Base
  belongs_to :physician
  belongs_to :patient
end
