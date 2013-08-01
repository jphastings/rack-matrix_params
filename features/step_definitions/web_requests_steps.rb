When(/^I make a GET request of "(.+)"$/) do |url|
  get url
end

Then(/^Rack's "([^\"]+)" environment variable is "(.+)"$/) do |key, value|
  last_request.env[key].should == value
end