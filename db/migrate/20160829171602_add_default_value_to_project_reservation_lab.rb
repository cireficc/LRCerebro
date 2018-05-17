class AddDefaultValueToProjectReservationLab < ActiveRecord::Migration[4.2]

def change
    change_column_default :project_reservations, :lab, Lab.locations[:b]
  end
end
