class LocationEditingDialogView < FXDialogBox
  def initialize(owner)
    super(owner, "Edit Location", DECOR_TITLE|DECOR_BORDER|DECOR_RESIZE)
    @location_title = FXDataTarget.new("")
    @location_description = FXDataTarget.new("")
    add_text_fields
    set_initial_fields_value("0,0")
    add_exits_picker
    add_terminating_buttons
  end

  attr_accessor :location_title, :location_description, :location_coordinate,
                :has_north_exit, :has_east_exit, :has_south_exit, :has_west_exit,
                :has_up_exit, :has_down_exit

  def set_initial_fields_value(coordinate, title="", description="")
    @title_field.text = title
    @description_field.text = description
    @location_coordinate = coordinate
  end

  def add_text_fields
    form = FXVerticalFrame.new(self,
                               :opts => LAYOUT_FILL_X|LAYOUT_SIDE_TOP|PACK_UNIFORM_WIDTH)
    @title_field = FXTextField.new(form, 50, @location_title, FXDataTarget::ID_VALUE)
    @description_field = FXText.new(form, @location_description, FXDataTarget::ID_VALUE)
  end

  def add_exits_picker
    FXLabel.new(self, "Exits", :opts => LAYOUT_FILL_X)
    frame = FXHorizontalFrame.new(self, :opts => LAYOUT_FILL_X|PACK_UNIFORM_WIDTH)
    @has_north_exit = FXCheckButton.new(frame, "North")
    @has_east_exit = FXCheckButton.new(frame, "East")
    @has_south_exit = FXCheckButton.new(frame, "South")
    @has_west_exit = FXCheckButton.new(frame, "West")
    @has_up_exit = FXCheckButton.new(frame, "Up")
    @has_down_exit = FXCheckButton.new(frame, "Down")
  end

  def add_terminating_buttons
    buttons = FXHorizontalFrame.new(self,
                                    :opts => LAYOUT_FILL_X|LAYOUT_SIDE_BOTTOM|PACK_UNIFORM_WIDTH)
    FXButton.new(buttons, "OK",
                 :target => self, :selector => FXDialogBox::ID_ACCEPT,
                 :opts => BUTTON_NORMAL|LAYOUT_RIGHT)
    FXButton.new(buttons, "Cancel",
                 :target => self, :selector => FXDialogBox::ID_CANCEL,
                 :opts => BUTTON_NORMAL|LAYOUT_RIGHT)
  end
end