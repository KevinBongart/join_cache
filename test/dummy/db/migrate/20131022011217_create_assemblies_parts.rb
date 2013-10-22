class CreateAssembliesParts < ActiveRecord::Migration
  def change
    create_table :assemblies_parts do |t|
      t.references :assembly, index: true
      t.references :part, index: true
    end
  end
end
