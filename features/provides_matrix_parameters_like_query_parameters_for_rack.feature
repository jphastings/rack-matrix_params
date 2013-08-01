Feature: Provides matrix URL parameters as if they were given as GET parameters to Rack applications
  As a developer on the rack platform
  I want my application to be able to comprehend [matrix parameter][1] style URLs
  So that I can ensure these parameters are considered when older WWW servers are caching HTTP requests

  Scenario: Matrix parameters are present in the query parameters environment variable
    When I make a GET request of "/normal/path/with/params;a=1;b=2/in;c=3/the/middle"
    Then Rack's "PATH_INFO" environment variable is "/normal/path/with/params/in/the/middle"
    And Rack's "QUERY_STRING" environment variable is "params[a]=1&params[b]=2&in[c]=3"

# [1]: http://www.w3.org/DesignIssues/MatrixURIs.html "Time Berners-Lee's original description of Matrix URIs"