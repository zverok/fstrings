Gem::Specification.new do |s|
  s.name     = 'fstrings'
  s.version  = '0.0.2'
  s.authors  = ['Victor Shepelev']
  s.email    = 'zverok.offline@gmail.com'
  s.homepage = 'https://github.com/zverok/fstrings'

  s.summary = 'Python-alike fstrings (formatting strings) for Ruby'
  s.description = <<-EOF
    Python-alike formatting strings with Ruby flavour: f"{x=%.2f}"
  EOF
  s.licenses = ['MIT']

  # We use smart String refinements in Parser.
  # Well, it is honestly not THAT necessary, but the gem is
  # experimental anyways...
  s.required_ruby_version = '>= 2.6.0'

  s.files = `git ls-files lib LICENSE.txt *.md`.split($RS)
  s.require_paths = ["lib"]

  # s.add_runtime_dependency 'backports', '>= 3.15.0'
  s.add_runtime_dependency 'binding_of_caller'

  s.add_development_dependency 'rubocop'
  s.add_development_dependency 'rubocop-rspec'

  s.add_development_dependency 'rspec', '>= 3.8'
  s.add_development_dependency 'rspec-its', '~> 1'
  s.add_development_dependency 'saharspec', '>= 0.0.6'
  s.add_development_dependency 'simplecov', '~> 0.9'

  s.add_development_dependency 'rake'
  s.add_development_dependency 'rubygems-tasks'

  s.add_development_dependency 'yard'
end
