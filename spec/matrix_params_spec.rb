require File.join(File.dirname(__FILE__),'spec_helper')

describe Rack::MatrixParams do
	include Rack::Test::Methods

	let(:inner_app) do
        lambda { |env| [200, {'Content-Type' => 'text/plain'}, ['All good!'] ]}
    end
 
    let(:app) { described_class.new(inner_app) }

	it 'should not change a normal GET query' do
		get "/?key=value"

		last_request.env['PATH_INFO'].should == "/"
		last_request.env['REQUEST_METHOD'].should == "GET"
		last_request.env['QUERY_STRING'].should == "key=value"
		last_response.should be_ok
	end

	it 'should not change a normal POST query' do
		post "/",{'key' => "value"}

		last_request.env['PATH_INFO'].should == "/"
		last_request.env['REQUEST_METHOD'].should == "POST"
		last_request.env['rack.input'].read.should == "key=value"
		last_response.should be_ok
	end

	it 'should add variables to the params when a matrix URL is used on a GET request' do
		get "/path/info;key=value/more"

		last_request.env['PATH_INFO'].should == "/path/info/more"
		last_request.env['QUERY_STRING'].should == "info[key]=value"
		last_response.should be_ok
	end

	it 'should not erase data in a query parameter if a matrix parameter has the same keyname' do
		get '/path/info;key=value/more?info[key]=somethingelse'

		last_request.env['QUERY_STRING'].should == "info[key]=somethingelse&info[key]=value"
		last_response.should be_ok
	end

	it 'should put matrix parameters after query parameters' do
		get '/path/info;key=value/more?queryparams'

		last_request.env['QUERY_STRING'].should == "queryparams&info[key]=value"
		last_request.env['QUERY_STRING'].should_not == "info[key]=value&queryparams"
		last_response.should be_ok
	end

	it 'should provide access to the matrix parameters via the params variable' do
		get '/path/info;key=value/more?queryparams'

		last_request.params.should == {'queryparams'=>nil, 'info'=>{'key'=>'value'}}
	end

	it 'should work in the blinkbox books format' do
		get '/client;img:w=200/server;v=0/test/9780111222333.sample.epub/OEBPS/chapter_001.html'

		last_request.params.should == {'client'=>{'img:w' => '200'}, 'server'=>{'v'=>'0'}}
	end
end