class CreateParts < ActiveRecord::Migration
  def change
    create_table :parts do |t|
      t.string :part_number

      t.timestamps
    end
  end
end
