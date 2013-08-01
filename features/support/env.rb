$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', '..', 'lib'))
require 'rack/matrix_params'
require 'rack/test'

module AppMixin
  include Rack::Test::Methods
  def app
    app = Rack::MatrixParams.new(lambda do |env|
      [200, {'Content-Type' => 'text/plain'}, ['All good!'] ]
    end)
  end
end

World(AppMixin)