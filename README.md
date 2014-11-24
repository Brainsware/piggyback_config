# piggyback_config

A simple module allowing to build up application configuration in multiple
steps. It is suitable for applications coming with a fixed common configuration
with defaults, user configuration and command line arguments that can override
those configurations.

All passed keys are sanitized and converted to symbols. Spaces and dashes are
substituted with underscores. Keys like `a::b::c: 'value'` are extrapolated to
form a hash `{ a: { b: { c: 'value' } } }`, much like in Hiera [1].

To ease understanding, debugging and traceability, the config is copied on
merge. This means everytime `#merge!` is called, a new version is pushed upon
an internal stack. Calling `#current` gives the current version.

[1] Inspired by [Puppetlabs' Hiera](https://docs.puppetlabs.com/hiera/1/).

## Example

```ruby
require 'piggyback_config'
require 'yaml'

config = Piggyback::Config.new

config.merge!(YAML.load_file('/etc/config.yml'))
config.merge!(YAML.load_file('~/.user_config.yml'))

# You can also use #current() to get the last config
arguments = OptParserOfYourChoice.parse(ARGV, config.current()[:arguments])

config.merge!(arguments)
```

## License

The MIT License (MIT)

Copyright (c) 2014 Brainsware OG

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
