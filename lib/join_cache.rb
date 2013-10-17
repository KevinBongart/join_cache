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
      join_table      = association.join_table                    # employees_teams
      join_model      = join_table.classify.pluralize.constantize # EmployeesTeams

      # cached_team_ids
      define_method(cached_ids_name) do
        Rails.cache.fetch("#{cache_key}/#{cached_ids_name}") do
          join_model.where(primary_key => id).pluck(foreign_key.to_sym)
        end
      end

      # cached_teams
      define_method(cached_name) do
        association.klass.where(id: send(cached_ids_name))
      end
    end
  end
end
