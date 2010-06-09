require 'rubygems'
require 'bundler'
Bundler.setup
require 'fox16'
require 'publisher'
require 'yaml'
include Fox
require 'lib/views/area_editor_view'
require 'lib/views/location_editing_dialog_view'
require 'lib/presenters/area_editor_presenter'
require 'lib/presenters/location_editing_dialog_presenter'
require 'lib/models/area'
require 'lib/models/location'
require 'lib/application'

app = Application.new
app.start
