Gem::Specification.new do |s|
  s.name        = 'piggyback_config'
  s.version     = '0.1'
  s.date        = '2014-11-24'
  s.authors     = ['Alexander Pánek']
  s.email       = 'a.panek@brainsware.org'
  s.files       = ['lib/piggyback_config.rb', 'lib/piggyback_config/configuration.rb']
  s.homepage    = 'https://github.com/Brainsware/piggyback_config'
  s.license     = 'MIT'
  s.summary     = 'Build up application configuration from multiple sources'
  s.description = 'A simple module allowing to build up application configuration in multiple
steps. It is suitable for applications coming with a fixed common configuration
with defaults, user configuration and command line arguments that can override
those configurations.'

  s.add_runtime_dependency 'deep_merge', '= 1.0.1'
end
