Gem::Specification.new do |s|
  s.name = 'file_transfer-client'
  s.version = '0.0.0'
  s.summary = 'File Transfer Client'
  s.description = ' '

  s.authors = ['Anderson Saunders']
  s.homepage = 'https://github.com/andsbf/file-transfer-start'
  s.licenses = ['MIT']

  s.require_paths = ['lib']

  files =  Dir.glob('lib/file_transfer/**/*')
  files += Dir.glob("lib/file_transfer_component/commands/*")
  files += Dir.glob("lib/file_transfer_component/controls/commands/*")
  files += Dir.glob("lib/file_transfer_component/controls/events/*")
  files += Dir.glob("lib/file_transfer_component/messages/**/*")

  s.files = files

  s.platform = Gem::Platform::RUBY
  s.required_ruby_version = '>= 2.3.3'

  s.add_runtime_dependency 'eventide-postgres'

  s.add_development_dependency 'test_bench'
end
