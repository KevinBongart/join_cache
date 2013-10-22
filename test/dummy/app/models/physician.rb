class Physician < ActiveRecord::Base
  has_many :appointments
  has_many :patients, through: :appointments
  include JoinCache
end
