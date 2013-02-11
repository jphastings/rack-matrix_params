Rack::MatrixParams
==================

Just simple Rack middleware to enable 'matrix' params.

*Originally developed by [Michal Fojtik](https://github.com/mifo/rack-matrix-params).*

Features
--------

- Allow you to use Matrix URLs:
  - http://localhost:9393/library;category=biology/book;author=Bond;hardcover=yes
  - http://localhost:9393/library/book;author=Bond;hardcover=yes
  - http://localhost:9393/library;category=biology/book?id=123

Examples
--------

### Example Sinatra server

    require 'sinatra'
    require 'rack/matrix_params'

    use Rack::MatrixParams

    get '/' do
      "Visit <a href=\"/library;category=biology/book;author=Bond;hardcover=yes\">a matrix URL</a>."
    end

    get '/library/book' do
      params.inspect
    end

When you run this ruby script, you can visit the URL on the `/` root page, and see how sinatra's `params` variable is populated with the information in the matrix parameters.

### Example return values

http://localhost:9393/library;category=biology/book;author=Bond;hardcover=yes

    params['library']['category']='biology'
    params['book']['author']='Bond'
    params['book']['hardcover']='yes'

http://localhost:9393/library;category=biology/book?id=123

    params['library']['category']='biology'
    params['id']=123

To Do
-----

* Write more tests!
* Investigate which environment variables are changed, so that hopefully the Rack Log (eg. in Sinatra) doesn't have the hacked query string visible.

LICENSE
-------

Licensed to the Apache Software Foundation (ASF) under one or more
contributor license agreements.  See the NOTICE file distributed with
this work for additional information regarding copyright ownership.  The
ASF licenses this file to you under the Apache License, Version 2.0 (the
"License"); you may not use this file except in compliance with the
License.  You may obtain a copy of the License at

      http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.  See the
License for the specific language governing permissions and limitations
under the License.
