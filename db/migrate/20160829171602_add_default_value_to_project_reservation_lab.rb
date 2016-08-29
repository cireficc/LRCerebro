class AddDefaultValueToProjectReservationLab < ActiveRecord::Migration
  def change
    change_column_default :project_reservations, :lab, Lab.locations[:b]
  end
end
