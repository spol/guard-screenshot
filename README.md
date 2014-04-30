# Guard-Screenshot

Guard-Screenshot saves a screenshot (in PNG format) of an HTML page whenever a
resource (e.g. the HTML file itself, or a CSS/JS file) is updated. If no visible
changes have occurred since the last screenshot the new one is discarded.

_This is my first shot at a Guard plugin to scratch a personal itch. I'm 
releasing it incase it can be helpful to others, but the code could probably do
with some tidying._

## Installation

Guard-Screenshot is not yet submitted to Rubygems.org. In the meantime, add this
line to your application's Gemfile:

    gem 'guard-screenshot', :github => 'spol/guard-screenshot'

And then execute:

    $ bundle

Guard-Screenshot depends on [PhantomJS][phantom] being in the user's path.

## Usage

Please read the [Guard usage documentation][gdoc].

### Guardfile

To initialise your guardfile run the following.

    bundle exec guard init screenshot

This will add the following to your guardfile:

    guard :screenshot, :page => 'html/index.html', :dest => 'screenshots' do
        watch(%r{^(.+)\.(html|css|js|png|jpe?g|gif|svg)$})
    end

Out of the box, this will render a screenshot of `html/index.html` into the
folder `screenshots` everytime an HTML, CSS, JS or image file is changed.

#### Options

    :page => 'html/index.html'          # Relative path to the HTML file to
                                        # render when changes are detected.
                                        # default: index.html

    :dest => 'screenshots'              # Folder to save images to.
                                        # default: 'screenshots'

    :width => 1024                      # Width of the viewport when rendering.
                                        # default: 1024

    :keep_paths => true                 # Preserve file paths when generating images.
                                        # E.g. html/index.html outputs to
                                        # screenshots/html/20130101-000000-index.png

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

[phantom]: http://phantomjs.org/
[gdoc]:    http://github.com/guard/guard#readme