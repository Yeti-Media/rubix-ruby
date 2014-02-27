# Rubix::Api
Ruby wrapper for Rubix api.

## Installation

Add this line to your application's Gemfile:

    gem 'rubix-api'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rubix-api

## Usage

First you need to require the gem and you initialize the client by instantiating the Rubix class. To do this you need your _access token_ and you can **optionally** specify _api version_ and _domain_.  

    require 'rubix-api'
    
    client = Rubix.new(access_token, version, domain)
    
To add a matching pattern you need to pass the _file_ itself or an _file url_ for it, a _label_, and the _category name_ to which the pattern belongs. 

    client.add_pattern({file, remote_file_url, label, category_name})
    
To compare histogram you can use the comparison method. It needs a file or file url, a comparison method (correlational or intersectional), the minimum percentage of matching, and the color scale to use (grays, color, or hue-saturation-value).

    client.comparison({file: File, remote_file_url: "http://example.com/path/to/scene", method: "corr|inter", min: 80, matching: 'gray|color|HSV'})

For OCR, Rubix needs the path to image or the file itself, and optionally, the area to be scanned.

    client.ocr({file, remote_file_url, rectangles: [[x1,y1.x2,y2],..,[x1,y1,x2,y2]]}


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
