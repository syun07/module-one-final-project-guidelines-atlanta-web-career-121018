class CreateCaretakers < ActiveRecord::Migration[5.0]
  def change
    create_table :caretakers do |c|
      c.string :name
    end
  end
end
