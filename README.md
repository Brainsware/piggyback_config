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

```yaml
---
# defaults.yml, shipped with the application's gem
config:    /etc/project/config.yml
port:      3333
ssl:       on
log-level: warn
```

```yaml
---
# /etc/project/config.yml
# The config the application is deployed with, changing some of the defaults
port: 3456
log-level: debug
```

```ruby
require 'piggyback_config'
require 'yaml'
require 'pp'

# Feed Piggyback::Configuration with the most basic defaults
config = Piggyback::Configuration.new({
  config:    './config.yml',
  log_level: :warn,
})

pp config.current()
#=> { :config=>"defaults.yml", :log_level=>:warn }

# Add some more defaults from a YAML file
defaults_yaml = File.expand_path(File.join(File.dirname(__FILE__), '../etc/defaults.yml'))
defaults      = YAML.load_file(defaults_yaml)

if defaults
  config.merge!(defaults)

  pp config.current()
  #=>{ :config    => "/etc/project/config.yml",
  #    :log_level => "warn",
  #    :port      => 3333,
  #    :ssl       => "on"}

end

# Use the default config path to load and add the user config
config_yaml = config.current()[:defaults][:config]

if File.exists?(config_yaml)
  config.merge!(YAML.load_file(config_yaml))

  pp config.current()
  #=>{ :config   => "/etc/project/config.yml",
  #    :log_level=> "debug",
  #    :port     => 3456,
  #    :ssl      => "on"}

end

# Use all of the above config to configure the OptParserOfYourChoice
arguments = OptParserOfYourChoice.parse(ARGV, config.current()[:arguments])

#=> { "port" => 6543, "log-level" => "info" }

# Finally: also merge in the options gathered from the CLI
config.merge!(arguments)

pp config.current()
#=> { :config                => "/etc/project/config.yml",
#     :log_level             => "info",
#     :port                  => 6543,
#     :ssl                   => "on",
#     :and_some_other_option => true}

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
