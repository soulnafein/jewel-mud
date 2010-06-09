class Application < FXApp
  def initialize
    super
    @main_window = FXMainWindow.new(self, "Area Editor", :width => 500, :height => 500)
    @location_editing_dialog_view = LocationEditingDialogView.new(@main_window)
    @location_editing_dialog_presenter = LocationEditingDialogPresenter.new(@location_editing_dialog_view)
    @area_editor_view = AreaEditorView.new(@main_window)
    @area_editor_presenter = AreaEditorPresenter.new(@area_editor_view,
                                                     @location_editing_dialog_presenter)
  end

  def start
    self.create
    @main_window.show
    self.run 
  end
end