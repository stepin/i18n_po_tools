# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'i18n_po_tools/version'

Gem::Specification.new do |spec|
  spec.name          = "i18n_po_tools"
  spec.version       = I18nPoTools::VERSION
  spec.authors       = ["Igor Stepin"]
  spec.email         = ["igor_for_os@stepin.name"]
  spec.homepage      = "http://github.com/stepin/#{spec.name}"
  spec.license       = "MIT"
  spec.summary = "Utils to convert translations from source formats to PO/POT Gettex and vise versa."
  spec.description = <<EOF
Utils to convert translations from source formats to PO/POT Gettex and vise versa.
It allows to separate translations from development of apps.

Supported input/output formats:
* iOS and OS X String Resources
* Android String XML
* Gettext PO/POT
* Rails YAML
* Basic flat YAML
* CVS for easy exchange with other apps

Direct converation between any formats supported.

Rails YAML and PO supports plural forms of messages.
EOF

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  #for Android files support
  spec.add_runtime_dependency "nokogiri"
  #for PO files support
  spec.add_runtime_dependency "get_pomo", "= 0.9.0"
  #for blank?/present?
  spec.add_runtime_dependency "activesupport", "~> 4.1.6"


  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "gem-release"
end
