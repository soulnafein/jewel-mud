class AreaEditorPresenter
  def initialize(view, dialog_presenter)
    @view = view
    @area = load_area
    @view.generate_grid(@area)
    @dialog_presenter = dialog_presenter
    @view.on(:location_editing_started) { |coord| start_location_editing(coord) }
    @dialog_presenter.on(:location_editing_complete) { |location| location_editing_complete(location) }
    @view.on(:saving_requested) { persist_area }
  end

  def location_editing_complete(location)
    @area.add_or_replace_location(location)
    @view.darken_location_button(location.coordinate)
  end

  def start_location_editing(coordinate)
    location = @area.get_location_at_coordinate(coordinate)
    location = Location.new if location.nil?
    location.coordinate = coordinate
    @dialog_presenter.show_edit_location_dialog(location)
  end

  def persist_area
    File.open('area.yaml', 'w')  do |out|
      YAML.dump(@area,out)
    end
  end

  def load_area
    YAML.load_file('area.yaml')
  end
end