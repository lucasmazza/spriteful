# coding: utf-8
Gem::Specification.new do |spec|
  spec.name          = 'spriteful'
  spec.version       = '0.0.3'
  spec.authors       = ['Lucas Mazza']
  spec.email         = ['lucastmazza@gmail.com']
  spec.description   = 'A sprite generation tool'
  spec.summary       = ''
  spec.homepage      = 'https://github.com/lucasmazza/spriteful'
  spec.license       = 'Apache 2.0'

  spec.files         = Dir['LICENSE', 'README.md', 'lib/**/*']
  spec.executables   = Dir['bin/*'].map { |f| File.basename(f) }
  spec.test_files    = Dir['spec/**/*']
  spec.require_paths = ['lib']

  spec.add_dependency 'thor', '>= 0.18.1', '< 2.0'
  spec.add_dependency 'rmagick', '~> 2.13.2'
  spec.add_dependency 'svg_optimizer'

  spec.add_development_dependency 'rspec', '~> 2.14.0'
  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
end
