class AreaEditorView
  extend Publisher

  can_fire :location_editing_complete, :location_editing_started,
           :saving_requested

  def initialize(window)
    @window = window
    frame = FXVerticalFrame.new(window, :opts => LAYOUT_FILL)
    add_grid_placeholder(frame)
    add_lower_toolbar(frame)
  end

  def generate_grid(area)
    @grid.numColumns = area.width
    area.height.times do |x|
      area.width.times do |y|
        coordinate = "#{x},#{y}"
        FXButton.new(@grid, '',
                     :opts => FRAME_RAISED | LAYOUT_FIX_WIDTH | LAYOUT_FIX_HEIGHT,
                     :width => 30, :height => 30) do |b|
          b.frameStyle = FRAME_SUNKEN|FRAME_THICK
          darken_location_button(coordinate) if area.get_location_at_coordinate(coordinate)
          b.connect(SEL_COMMAND, lambda { fire(:location_editing_started, coordinate) })
        end
      end
    end
  end

  def darken_location_button(coordinate)
    coordinate =~ /(\d+),(\d+)/
    button = @grid.childAtRowCol($1.to_i, $2.to_i)
    button.backColor = FXRGB(60, 60, 60)
  end

  private
  def add_grid_placeholder(frame)
    scroll_window = FXScrollWindow.new(frame, :opts => LAYOUT_FILL)
    @grid = FXMatrix.new(scroll_window, 10,
                         :opts => MATRIX_BY_COLUMNS | LAYOUT_FILL)
  end

  def add_lower_toolbar(frame)
    buttons = FXHorizontalFrame.new(frame,
                                    :opts => LAYOUT_FILL_X|LAYOUT_SIDE_BOTTOM|PACK_UNIFORM_WIDTH)
    FXLabel.new(buttons, 'Height')
    FXSpinner.new(buttons, 5, :opts => LAYOUT_FILL_ROW|SPIN_NOMAX|SPIN_NOMIN)
    save_button = FXButton.new(buttons, "Save")
    save_button.connect(SEL_COMMAND, lambda { fire :saving_requested })
  end
end



