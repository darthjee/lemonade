# frozen_string_literal: true

require 'sinatra'
require 'yaml'
require 'sinclair'
require 'arstotzka'
require 'fileutils'

root_path = File.expand_path(__dir__)
$LOAD_PATH.unshift([root_path, 'app'].join('/'))

require 'application'
require 'endpoint'
require 'route'
require 'config'
require 'config_loader'

set :port, 80
set :bind, '0.0.0.0'

Application.config_file_path('config/routes.yml')
Application.start
