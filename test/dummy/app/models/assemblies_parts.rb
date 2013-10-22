class AssembliesParts < ActiveRecord::Base
  belongs_to :assembly
  belongs_to :part
end
