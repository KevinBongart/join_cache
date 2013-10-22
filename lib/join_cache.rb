module JoinCache
  extend ActiveSupport::Concern

  included do
    # Generates methods for faster retrieval of HABTM associations
    # by storing foreign keys in cache and avoiding large joins
    #
    # For example:
    # class Employee < ActiveRecord::Base
    #   has_and_belongs_to_many :teams
    #   include JoinCache
    # end
    #
    # Employee.first.cached_team_ids
    # => [4, 8, 15, 16, 23, 42]
    #
    # Employee.first.cached_teams
    # => Team.where(id: [4, 8, 15, 16, 23, 42])
    #
    reflect_on_all_associations(:has_and_belongs_to_many).each do |association|
      singular_name   = association.name.to_s.singularize         # team
      plural_name     = association.plural_name                   # teams
      cached_name     = "cached_#{plural_name}"                   # cached_teams
      cached_ids_name = "cached_#{singular_name}_ids"             # cached_team_ids
      primary_key     = association.foreign_key                   # employee_id
      foreign_key     = association.association_foreign_key       # team_id

      # cached_team_ids
      define_method(cached_ids_name) do
        Rails.cache.fetch("#{cache_key}/#{cached_ids_name}") do
          send(foreign_key.pluralize.to_sym)
        end
      end

      # cached_teams
      define_method(cached_name) do
        association.klass.where(id: send(cached_ids_name))
      end
    end

    has_many_through_associations = reflect_on_all_associations(:has_many).select do |association|
      association.is_a?(ActiveRecord::Reflection::ThroughReflection)
    end

    # Generates methods for faster retrieval of has_many :through associations
    # by storing foreign keys in cache and avoiding large joins
    #
    # For example:
    # class Physician < ActiveRecord::Base
    #   has_many :appointments
    #   has_many :patients, through: :appointments
    #   include JoinCache
    # end
    #
    # Physician.first.cached_patient_ids
    # => [4, 8, 15, 16, 23, 42]
    #
    # Physician.first.cached_patients
    # => Patient.where(id: [4, 8, 15, 16, 23, 42])
    #
    has_many_through_associations.each do |association|
      singular_name   = association.name.to_s.singularize         # patient
      plural_name     = association.plural_name                   # patients
      cached_name     = "cached_#{plural_name}"                   # cached_patients
      cached_ids_name = "cached_#{singular_name}_ids"             # cached_patient_ids
      primary_key     = self.name.foreign_key                     # employee_id
      foreign_key     = association.foreign_key                   # patient_id

      # cached_patient_ids
      define_method(cached_ids_name) do
        Rails.cache.fetch("#{cache_key}/#{cached_ids_name}") do
          send(foreign_key.pluralize.to_sym)
        end
      end

      # cached_patients
      define_method(cached_name) do
        association.klass.where(id: send(cached_ids_name))
      end
    end
  end
end
