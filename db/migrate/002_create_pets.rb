class CreatePets < ActiveRecord::Migration[5.0]

  def change
    create_table :pets do |p|
      p.belongs_to :caretaker, index: true
      p.belongs_to :shelter, index: true

      p.string :name
      p.string :type

    end
  end


end
