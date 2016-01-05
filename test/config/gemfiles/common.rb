def declare_gems(activerecord_version)
  source 'https://rubygems.org'

  gem 'activerecord', activerecord_version
  gem 'adapter_extensions', :git => 'https://github.com/activewarehouse/adapter_extensions.git'

  gem 'pg'
  gem 'activerecord-sqlserver-adapter'

  gem 'awesome_print'
  gem 'rake'
  gem 'flexmock'
  gem 'shoulda', '3.5.0'
  gem 'test-unit'
  gem 'sqlite3'

  gem 'spreadsheet'
  gem 'nokogiri'
  gem 'fastercsv'

  gem 'standalone_migrations'
end