class LocationEditingDialogPresenter
  extend Publisher
  can_fire :location_editing_complete

  def initialize(view)
    @view = view 
  end

  def show_edit_location_dialog(location)
    @view.set_initial_fields_value(location.coordinate, location.title, location.description)
    if @view.execute != 0
      location = Location.new
      location.title = @view.location_title.value
      location.description = @view.location_description.value
      location.coordinate = @view.location_coordinate
      fire(:location_editing_complete,location)
    end
  end
end
