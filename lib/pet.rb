class Pet < ActiveRecord::Base
  belongs_to :caretaker
  belongs_to :shelter
end
