ENV['RACK_ENV'] = 'test'

require 'rspec'
require 'rack/test'
require 'yarjuf'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'rack/matrix_params'