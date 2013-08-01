# Copyright (C) 2011  Red Hat, Inc.
#
# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.  The
# ASF licenses this file to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance with the
# License.  You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.  See the
# License for the specific language governing permissions and limitations
# under the License.

# Methods added to this helper will be available to all templates in the application.

module Rack

  require 'cgi'

  class MatrixParams
    def initialize(app)
      @app = app
    end

    # This will allow to use 'matrix' params in requests, like:
    #
    # http://example.com/library;section=nw/books;topic=money;binding=hardcover
    #
    # Will result in this params matrix:
    #
    # => params['library']['section'] = 'nw'
    # => params['books']['topic'] = 'money'
    # => params['books']['binding'] = 'hardcover'
    #
    # All HTTP methods are supported, in case of POST they will be passed as a
    # regular <form> parameters.
    
    def call(env)
      # Split URI to components and then extract ;var=value pairs
      uri_components = env['PATH_INFO'].split('/')
      matrix_params = {}
      uri_components.each do |component|
       sub_components, value = component.split(/\;([\w:]+)\=/), nil
        next unless sub_components.first  # Skip subcomponent if it's empty (usually /)
        while param = sub_components.pop do
          if value
            # There are matrix components to this path element
            (matrix_params[sub_components.first] ||= {}).merge!( param => value )

            value = nil
            next
          else
            # There are no matrix components to this path element
            value = param
          end
        end
      end

      # No need for anything else if there are no matrix params
      return @app.call(env) if matrix_params.keys.empty?

      # If request method is POST, simply include matrix params in form_hash
      env['rack.request.form_hash'].merge!(matrix_params) if env['rack.request.form_hash']

      # For other methods it's a way complicated ;-)
      if env['REQUEST_METHOD'] != 'POST'

        # Rewrite current path and query string and strip all query params from it
        env['PATH_INFO'] = env['PATH_INFO'].gsub(/;([^\/]*)/, '').gsub(/\?(.*)$/, '')

        env['QUERY_STRING'] = env['QUERY_STRING'].gsub(/;([^\/]*)/, '').freeze
        
        new_params = matrix_params.collect do |component, params|
          params.collect do |k,v|
            "#{component}[#{k}]=#{CGI::escape(v.to_s)}"
          end.reverse
        end.flatten

      	# Add matrix params as a regular GET params
      	env['QUERY_STRING'] += '&' if not env['QUERY_STRING'].empty?
      	env['QUERY_STRING'] += "#{new_params.join('&')}"
      end

      @app.call(env)
    end
  end
end
