class CreateShelters < ActiveRecord::Migration[5.0]

  def change
    create_table :shelters do |s|
      s.string :name
      s.string :location
    end
  end

end
