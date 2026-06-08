# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'etl/version'

Gem::Specification.new do |s|
  s.name = %q{activewarehouse-etl}
  s.version = ETL::VERSION
  s.platform = Gem::Platform::RUBY
  s.authors = ["Anthony Eden", "Thibaut Barrère"]
  s.email = ["thibaut.barrere@gmail.com"]
  s.homepage = "https://github.com/activewarehouse/activewarehouse-etl"
  s.summary = %q{Pure Ruby ETL package.}
  s.description = %q{ActiveWarehouse ETL is a pure Ruby Extract-Transform-Load application for loading data into a database.}

  s.required_rubygems_version = ">= 1.3.6"

  s.required_ruby_version = '>= 3.0'

  s.add_runtime_dependency('rake',                '>= 13.0')
  s.add_runtime_dependency('activesupport',       '>= 7.0', '< 8.0')
  s.add_runtime_dependency('activerecord',        '>= 7.0', '< 8.0')
  s.add_runtime_dependency('adapter_extensions',  '>= 1.0.1')
  s.add_runtime_dependency('rexml',               '>= 3.2')
  s.add_runtime_dependency('csv',                 '>= 3.2')

  s.add_development_dependency('shoulda', '~>3.5.0')
  s.add_development_dependency('flexmock', '~> 2.0.4')
  s.add_development_dependency('cartesian')
  s.add_development_dependency('guard')
  s.add_development_dependency('guard-shell')
  s.add_development_dependency('test-unit')

  s.files              = `git ls-files`.split("\n")
  s.test_files         = `git ls-files -- {test}/*`.split("\n")
  s.executables        = %w(etl)
  s.require_path       = "lib"
end
